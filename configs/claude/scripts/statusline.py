#!/usr/bin/env python3
import json
import os
import pathlib
import re
import subprocess
import sys
import time

################################################################################
# Utilities
################################################################################

GREEN = 32
RED = 31
CYAN = 36
YELLOW = 33


def color(text, code):
   return f"\033[{code}m{text}\033[0m"


def bar(pct, width=10):
   filled = max(0, min(width, round(pct / 100 * width)))
   return "█" * filled + "░" * (width - filled)


def fmt_k(n):
   return f"{n // 1000}k" if n and n >= 1000 else str(n) if n else "?"


def time_remaining(epoch):
   secs = max(0, int(epoch - time.time()))
   h, rem = divmod(secs, 3600)
   m = rem // 60
   return f"{h}h{m:02d}m" if h > 0 else f"{m}m"


def usage_color(pct):
   if pct is None:
      return None
   if pct >= 80:
      return RED
   if pct >= 60:
      return YELLOW
   if pct >= 40:
      return GREEN
   return None


def maybe_color(text, pct):
   c = usage_color(pct)
   return color(text, c) if c else text


################################################################################
# Components
################################################################################


class ModelComponent:
   def __init__(self, data: dict):
      model = data.get("model", {})
      self.name = model.get("display_name") or model.get("id") or "?"

   def render(self):
      return f"🧠{color(self.name, CYAN)}"


class DirComponent:
   def __init__(self, data: dict):
      cwd = pathlib.Path(data.get("cwd", ""))
      self.name = cwd.name if cwd.exists() else "?"

   def render(self):
      return f"📁{color(self.name, CYAN)}"


class GitComponent:
   def __init__(self, data: dict):
      self.cwd = pathlib.Path(data.get("cwd", ""))
      self.branch = None
      self.changed_files = 0
      self.insertions = 0
      self.deletions = 0
      self._collect()

   def _git(self, args):
      result = subprocess.run(["git"] + args, cwd=self.cwd, capture_output=True, text=True)
      return result.stdout.strip() if result.returncode == 0 else None

   def _collect(self):
      self.branch = self._git(["rev-parse", "--abbrev-ref", "HEAD"])
      if not self.branch:
         return

      diff_stat = self._git(["diff", "--shortstat", "HEAD"])
      if diff_stat:
         if m := re.search(r"(\d+) insertion", diff_stat):
            self.insertions = int(m.group(1))
         if m := re.search(r"(\d+) deletion", diff_stat):
            self.deletions = int(m.group(1))

      status_out = self._git(["status", "--porcelain", "--untracked-files=all"])
      if status_out:
         self.changed_files = len({line[3:] for line in status_out.splitlines() if line.strip()})

   def render(self):
      if not self.branch:
         return None
      files_str = f" {self.changed_files}f" if self.changed_files else ""
      diff_str = ""
      if self.insertions or self.deletions:
         diff_str = f" {color(f'+{self.insertions}', GREEN)}/{color(f'-{self.deletions}', RED)}"
      return f"🔀{self.branch}{files_str}{diff_str}"


class VersionComponent:
   def __init__(self, data: dict):
      self.version = data.get("version")

   def render(self):
      return f"v{self.version}" if self.version else None


class ContextUsageComponent:
   def __init__(self, data: dict):
      ctx = data.get("context_window", {})
      self.pct = ctx.get("used_percentage")
      self.max = ctx.get("context_window_size")
      current = ctx.get("current_usage", {})
      self.used = sum(
         current.get(k, 0)
         for k in ("input_tokens", "output_tokens", "cache_creation_input_tokens", "cache_read_input_tokens")
      )

   def render(self):
      if self.pct is None:
         return None
      tokens = f"{fmt_k(self.used)}/{fmt_k(self.max)}" if self.used and self.max else fmt_k(self.max)
      text = f"💬{bar(self.pct)}{self.pct:.0f}% {tokens}"
      return maybe_color(text, self.pct)


class SessionUsageComponent:
   def __init__(self, data: dict):
      five_hour = data.get("rate_limits", {}).get("five_hour", {})
      self.pct = five_hour.get("used_percentage")
      self.resets_at = five_hour.get("resets_at")

   def render(self):
      if self.pct is None:
         return None
      time_str = f" -{time_remaining(self.resets_at)}" if self.resets_at else ""
      text = f"⏱️{bar(self.pct)}{self.pct:.0f}%{time_str}"
      return maybe_color(text, self.pct)


class WeeklyUsageComponent:
   def __init__(self, data: dict):
      seven_day = data.get("rate_limits", {}).get("seven_day", {})
      self.pct = seven_day.get("used_percentage")
      self.resets_at = seven_day.get("resets_at")

   def render(self):
      if self.pct is None:
         return None
      time_str = f" -{time_remaining(self.resets_at)}" if self.resets_at else ""
      text = f"📅{bar(self.pct)}{self.pct:.0f}%{time_str}"
      return maybe_color(text, self.pct)


################################################################################
# Entry point
################################################################################


def main():
   raw = sys.stdin.read()

   if os.environ.get("DEBUG_CLAUDE_CODE_STATUSLINE"):
      with open("/tmp/statusline-debug.json", "w") as f:
         f.write(raw)

   data = json.loads(raw)

   line1 = [
      ModelComponent(data),
      DirComponent(data),
      GitComponent(data),
      VersionComponent(data),
   ]
   line2 = [
      ContextUsageComponent(data),
      SessionUsageComponent(data),
      WeeklyUsageComponent(data),
   ]

   for line in [line1, line2]:
      parts = [c.render() for c in line]
      parts = [p for p in parts if p]
      if parts:
         print(" | ".join(parts))


if __name__ == "__main__":
   main()

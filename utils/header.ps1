function header {
   param([string]$type)
   $h = "[" + $type.ToUpper() + "]"
   return $h.PadRight(9)
}

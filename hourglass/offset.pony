primitive Offset
  fun apply(h: I32 = 0, m: I32 = 0, s: I32 = 0, mil: I32 = 0) : I32 =>
    (((((h * 60) + m) * 60) + s) * 1000) + mil

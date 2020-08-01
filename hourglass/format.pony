primitive _Format
  fun pad(x: Stringable, w: USize = 2): String iso^ =>
    let s = recover x.string() end
    var negativ = s.at("-")
    if negativ then try s.shift()? end end
    while s.codepoints() < w do
      s.unshift('0')
    end
    if negativ then s.unshift('-') end
    consume s

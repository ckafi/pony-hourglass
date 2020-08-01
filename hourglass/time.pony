trait Time is (Comparable[Time] & Stringable)
  new now()
  new from_posix(t: ILong, milli': I32 = 0, offset': I32 = 0)

  fun hour(): I32
  fun minute(): I32
  fun second(): I32
  fun milli(): I32
  fun offset(): I32

  fun ref advance(d: TimeDuration)

  fun clone(): Time iso^
  fun max(): Time iso^
  fun min(): Time iso^

  fun eq(that: box->Time): Bool =>
    (hour() == that.hour()) and
    (minute() == that.minute()) and
    (second() == that.second()) and
    (milli() == that.milli())

  fun lt(that: box->Time): Bool =>
    match (
      hour().compare(that.hour()),
      minute().compare(that.minute()),
      second().compare(that.second())
    )
    | (Less, _, _) => true
    | (Equal, Less, _) => true
    | (Equal, Equal, Equal) => milli() < that.milli()
    else
      false
    end

  fun string(): String iso^ =>
    let offset' = offset().abs()
    var off_minute = offset'.fld(60)
    let off_hour = off_minute.fld(60)
    off_minute = off_minute - (off_hour * 60)

    let output = recover String(18) end
    output
      .> append(_Format.pad(hour()))
      .> append(":")
      .> append(_Format.pad(minute()))
      .> append(":")
      .> append(_Format.pad(second()))
      .> append(".")
      .> append(_Format.pad(milli(), 3))
      .> append(if offset() < 0 then "-" else "+" end)
      .> append(_Format.pad(off_hour))
      .> append(":")
      .> append(_Format.pad(off_minute))
    consume output

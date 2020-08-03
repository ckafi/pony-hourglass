trait Time is (Comparable[Time] & Stringable)
  new now()

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
    var off_minute = offset'.fld(60*1000)
    let off_hour = off_minute.fld(60)
    off_minute = off_minute - (off_hour * 60)
    var buffer = recover ("\0" * 20) end
    var format = "%02d:%02d:%02d.%03d%+03d:%02d"
    let n = @sprintf[I32](
      buffer.cstring(),
      format.cstring(),
      hour(),
      minute(),
      second(),
      milli(),
      off_hour,
      off_minute
    )
    buffer.delete(n.isize(), USize.max_value())
    consume buffer

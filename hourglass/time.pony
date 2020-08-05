trait Time is (Comparable[Time] & Stringable)
  new now(tz: (TimeZone | None))

  fun hour(): I32
  fun minute(): I32
  fun second(): I32
  fun milli(): I32
  fun offset(): I32

  fun ref advance(d: TimeDuration)

  fun clone(): Time iso^
  fun max_value(): Time iso^
  fun min_value(): Time iso^

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
    var off_minute = offset().div(60*1000)
    let off_hour = off_minute.div(60)
    off_minute = off_minute - (off_hour * 60)
    var buffer = recover ("\0" * 20) end
    var format = "%02i:%02i:%02i.%03i%+03i:%02i"
    let n = @sprintf[I32](
      buffer.cstring(),
      format.cstring(),
      hour(),
      minute(),
      second(),
      milli(),
      off_hour,
      off_minute.abs()
    )
    buffer.delete(n.isize(), USize.max_value())
    consume buffer

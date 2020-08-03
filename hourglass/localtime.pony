use stdtime = "time"

class LocalTime is Time
  var _timestamp: I32
  var _offset: I32

  new create(
    hour': I32 = 0,
    minute': I32 = 0,
    second': I32 = 0,
    milli': I32 = 0,
    offset': I32 = 0)
  =>
    _timestamp = (((((hour' * 60) + minute') * 60) + second') * 1000) + milli'
    _offset = offset'

  new now() => None
    let now' = stdtime.Time.now()
    let second' = now'._1 % 86400
    let milli' = now'._2.fld(1_000_000).i32()
    _timestamp = (second'.i32() * 1000) + milli'
    _offset = 0

  new from_posix(t: I64, milli': I32 = 0, offset': I32 = 0) =>
    let t' = (t + offset'.i64()) % 86400
    _timestamp = (t'.i32() * 1000) + milli'
    _offset = offset'

  new _from_timestamp(t: I32, o: I32) =>
    _timestamp = t
    _offset = o

  fun hour(): I32 => _timestamp.fld(1000 * 60 * 60)
  fun minute(): I32 => _timestamp.fld(1000 * 60) % 60
  fun second(): I32 => _timestamp.fld(1000) % 60
  fun milli(): I32 => _timestamp % 1000
  fun offset(): I32 => _offset

  fun ref advance(d: TimeDuration) => None

  fun ref set_offset(offset': I32) =>
    let old_offset = _offset = offset'
    _timestamp = _timestamp + -old_offset + offset'

  fun clone(): LocalTime iso^ =>
    recover
      LocalTime._from_timestamp(_timestamp, _offset)
    end

  fun max(): LocalTime iso^ =>
    recover
      LocalTime.create(24, 59, 60, 999, _offset)
    end

  fun min(): LocalTime iso^ =>
    recover
      LocalTime(0, 0, 0, 0, _offset)
    end

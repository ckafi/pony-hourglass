class LocalTime is Time
  var _hour: I32
  var _minute: I32
  var _second: I32
  var _milli: I32
  var _offset: I32

  new create(
    hour': I32 = 0,
    minute': I32 = 0,
    second': I32 = 0,
    milli': I32 = 0,
    offset': I32 = 0)
  =>
    _hour = hour'
    _minute = minute'
    _second = second'
    _milli = milli'
    _offset = offset'

  new now() => None
    let now' = _CTime.now()
    let tm = _CTime.localtime(now'._1)
    _hour = tm.tm_hour
    _minute = tm.tm_min
    _second = tm.tm_sec
    _milli = now'._2.fld(1_000_000).i32()
    _offset = tm.tm_gmtoff.i32()

  new from_posix(t: ILong, milli': I32 = 0, offset': I32 = 0) =>
    let t': ILong = t + offset'.ilong()
    let tm = _CTime.gmtime(t')
    _hour = tm.tm_hour
    _minute = tm.tm_min
    _second = tm.tm_sec
    _milli = milli'
    _offset = offset'

  fun hour(): I32 => _hour
  fun minute(): I32 => _minute
  fun second(): I32 => _second
  fun milli(): I32 => _milli
  fun offset(): I32 => _offset

  fun ref advance(d: TimeDuration) => None

  fun clone(): LocalTime iso^ =>
    recover
      LocalTime.create(_hour, _minute, _second, _milli, _offset)
    end

  fun max(): LocalTime iso^ =>
    recover
      LocalTime.create(24, 59, 60, 999, _offset)
    end

  fun min(): LocalTime iso^ =>
    recover
      LocalTime(0, 0, 0, 0, _offset)
    end

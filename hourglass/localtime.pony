use stdtime = "time"

class LocalTime is Time
  var _t_milli: I32 /* milliseconds since midnight */
  var _offset: I32 = 0 /* in milliseconds */

  new create(
    hour': I32 = 0,
    minute': I32 = 0,
    second': I32 = 0,
    milli': I32 = 0)
  =>
    _t_milli = (((((hour' * 60) + minute') * 60) + second') * 1000) + milli'

  new now(tz: (TimeZone | None) = None) =>
    let now' = stdtime.Time.now()
    let t_milli = (now'._1 * 1000) + now'._2.fld(1_000_000)
    _offset = match tz
    | None => 0
    | let tz': TimeZone => tz'(t_milli)._1
    end
    _t_milli = ((t_milli + _offset.i64()) %% (86400 * 1000)).i32()

  new from_unix(t_second: I64, milli': I32 = 0, tz: (TimeZone | None) = None) =>
    _offset = match tz
    | None => 0
    | let tz': TimeZone => tz'(t_second * 1000)._1
    end
    _t_milli = (((t_second * 1000) + _offset.i64()) %% (86400 * 1000)).i32()

  fun hour(): I32 => _t_milli.fld(1000 * 60 * 60)
  fun minute(): I32 => _t_milli.fld(1000 * 60) % 60
  fun second(): I32 => _t_milli.fld(1000) % 60
  fun milli(): I32 => _t_milli % 1000
  fun offset(): I32 => _offset

  fun ref advance(d: TimeDuration) => None

  fun ref set_offset(
    h: I32 = 0,
    m: I32 = 0,
    s: I32 = 0,
    mil: I32 = 0)
  =>
    let offset' = (((((h * 60) + m) * 60) + s) * 1000) + mil
    let old_offset = _offset = offset'
    _t_milli = (_t_milli + -old_offset + offset') %% (86400 * 1000)

  fun clone(): LocalTime iso^ =>
    let that = recover LocalTime end
    that._t_milli = _t_milli
    that._offset = _offset
    consume that

  fun max_value(): LocalTime iso^ =>
    recover
      LocalTime.create(24, 59, 60, 999)
    end

  fun min_value(): LocalTime iso^ =>
    recover
      LocalTime(0, 0, 0, 0)
    end

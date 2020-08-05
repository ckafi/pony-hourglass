use stdtime = "time"

class LocalTime is Time
  var _t_milli_midn: I32 /* milliseconds since midnight */
  var _offset: I32 = 0 /* in milliseconds */

  new create(
    hour': I32 = 0,
    minute': I32 = 0,
    second': I32 = 0,
    milli': I32 = 0)
  =>
    _t_milli_midn = (((((hour' * 60) + minute') * 60) + second') * 1000) + milli'

  new now(offset': (TimeZone | I32) = 0) =>
    let now' = stdtime.Time.now()
    let t_milli = (now'._1 * 1000) + now'._2.fld(1_000_000)
    _offset = match offset'
    | let off: I32 => off
    | let tz': TimeZone => tz'(t_milli)._1
    end
    _t_milli_midn = ((t_milli + _offset.i64()) %% (86400 * 1000)).i32()

  new from_unix(
    t_second: I64,
    milli': I32 = 0,
    offset': (TimeZone | I32) = 0)
  =>
    _offset = match offset'
    | let off: I32 => off
    | let tz': TimeZone => tz'(t_second * 1000)._1
    end
    _t_milli_midn = (((t_second * 1000) + _offset.i64()) %% (86400 * 1000)).i32()

  fun hour(): I32 => _t_milli_midn.fld(1000 * 60 * 60)
  fun minute(): I32 => _t_milli_midn.fld(1000 * 60) % 60
  fun second(): I32 => _t_milli_midn.fld(1000) % 60
  fun milli(): I32 => _t_milli_midn % 1000
  fun offset(): I32 => _offset

  fun ref advance(d: TimeDuration) => None

  fun ref set_offset(offset': I32) =>
    let old_offset = _offset = offset'
    _t_milli_midn = (_t_milli_midn + -old_offset + offset') %% (86400 * 1000)

  fun clone(): LocalTime iso^ =>
    let that = recover LocalTime end
    that._t_milli_midn = _t_milli_midn
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

use stdtime = "time"

class LocalDate is Date
  var _t_days: I32 = 0// days since epoch
  // this is duplicate information, but we shouldn't go through the whole
  // `civil_from_days` rigmarole for each `year()`,`month()`,`day()`
  var _date_tuple: (I32, I32, I32) = (0,0,0) // year, month, day

  new create(
    year': I32 = 0,
    month': I32 = 0,
    day': I32 = 0)
  =>
    _t_days = _days_since_epoch(year', month', day')
    _date_tuple = _calc_date_tuple()

  new now(offset': (TimeZone | I32) = 0) =>
    let t_second = stdtime.Time.now()._1
    _t_days = _epoch_from_unix(t_second, offset')
    _date_tuple = _calc_date_tuple()

  new from_unix(
    t_second: I64,
    offset': (TimeZone | I32) = 0)
  =>
    _t_days = _epoch_from_unix(t_second, offset')
    _date_tuple = _calc_date_tuple()

  new min_value() =>
    _t_days = I32.min_value()
    _date_tuple = _calc_date_tuple()

  new max_value() =>
    _t_days = I32.max_value() - Epoch._epoch_offset()
    _date_tuple = _calc_date_tuple()

  fun year(): I32 => _date_tuple._1
  fun month(): I32 => _date_tuple._2
  fun day_of_month(): I32 => _date_tuple._3
  fun days_since_epoch(): I32 => _t_days

  fun ref next(w: Weekday) => None
  fun ref advance(d: DateDuration) => None

  fun clone(): LocalDate iso^ =>
    let that = recover LocalDate end
    that._t_days = _t_days
    that._date_tuple = _date_tuple
    consume that

  fun tag _epoch_from_unix(
    t_second: I64,
    offset': (TimeZone | I32) = 0)
    : I32
  =>
    let offset: I32 = match offset'
    | let off: I32 => off
    | let tz: TimeZone => tz(t_second * 1000)._1
    end
    (((t_second * 1000) + offset.i64()).fld(86400 * 1000)).i32()

  fun _calc_date_tuple(): (I32, I32, I32) =>
    // Based on the `civil_from_days` algorithm by Howard Hinnant.
    // An era is a 400 year span beginning at Mar 1st
    // of the first year of an Gregorian cycle.
    let days_in_era: I32 = (400 * 365) + 97
    let z = _t_days + Epoch._epoch_offset() // days since 0000-03-01
    let era = z.fld(days_in_era)
    let doe = z %% days_in_era
    // divisors are days which are (or aren't) leap days
    let yoe = (doe + -(doe / 1460) + (doe / 36524) + -(doe / 146096)) / 365
    let doy = doe - ((365 * yoe) + (yoe / 4) + -(yoe / 100))
    let mp = ((5 * doy) + 2) / 153 // magic, month idx in [Mar,Feb]
    let d = doy + -(((153 * mp) + 2) / 5) + 1 // more magic
    let m = ((mp + 2) % 12) + 1 // back to normal month numbering
    let y = yoe + (era * 400) + if m <= 2 then 1 else 0 end
    (y, m, d)

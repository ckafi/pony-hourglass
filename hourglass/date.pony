trait Date is (Comparable[Date] & Stringable)
  new max_value()
  new min_value()

  fun year(): I32
  fun month(): I32
  fun day_of_month(): I32

  fun ref next(w: Weekday)
  fun ref advance(d: DateDuration)

  fun clone(): Date iso^

  fun day_of_year(): I32 =>
    let m = month()
    let d = day_of_month()
    let days_before = [
      as I32: 0; 31; 59; 90; 120; 151; 181; 212; 243; 273; 304; 334
    ]
    let leapday: I32 = if (m > 2) and is_leapyear() then 1 else 0 end
    try days_before((m - 1).usize()) + d + leapday
    else 0
    end

  fun weekday(): Weekday => Epoch.weekday() + days_since_epoch()

  fun weekdate(): (I32, I32, I32) =>
    // iso week numbering is so stupid and needlessly complex
    var year' = year()
    let wd = weekday()
    let doy = day_of_year()
    let weekday_jan04 = wd - (doy - 4)
    // offset between civil year and iso week year
    let offset' = 3 - Monday.diff(weekday_jan04)
    var day_of_isoyear = doy - offset'
    if day_of_isoyear <= 0 then
      year' = year' - 1
      day_of_isoyear = (_num_weeks(year') * 7) + day_of_isoyear + -1
    end
    var weeknum = ((day_of_isoyear - 1) / 7) + 1
    if weeknum > _num_weeks(year') then
      year' = year' + 1
      weeknum = 1
    end
    (year', weeknum, wd())

  fun is_leapyear(): Bool => _is_leapyear(year())
  fun tag _is_leapyear(y: I32): Bool =>
    ((y % 4) == 0) and (((y % 100) != 0) or ((y % 400) == 0))

  fun num_weeks(): I32 => _num_weeks(year())
  fun tag _num_weeks(y: I32): I32 =>
    // I have no idea how this works
    // and blind trust in Wikipedia
    let p = {(y': I32): I32 =>
      (y' + y'.fld(4) + -(y'.fld(100)) + y'.fld(400)) %% 7
    }
    if (p(y) == 4) or (p(y-1) == 3) then 53
    else 52 end

  fun days_since_epoch(): I32 => _days_since_epoch(year(), month(), day_of_month())
  fun tag _days_since_epoch(y: I32, m: I32, d: I32): I32 =>
    // Based on the `days_from_civil` algorithm by Howard Hinnant.
    // An era is a 400 year span beginning at Mar 1st
    // of the first year of an Gregorian cycle.
    let y' = y - if m <= 2 then 1 else 0 end
    let days_in_era: I32 = (400 * 365) + 97
    let era = y'.fld(400)
    let yoe = y' %% 400
    let m' = (m + 9) % 12 // month idx in [Mar,Feb]
    let doy = (((153 * m') + 2) / 5) + d + -1 // magic
    let doe = (yoe * 365) + (yoe / 4) + -(yoe / 100) + doy
    // days since 0000-03-01 minus epoch offset
    (era * days_in_era) + doe + -Epoch._epoch_offset()

  fun eq(that: box->Date): Bool =>
    (year() == that.year()) and
    (day_of_year() == day_of_year())

  fun lt(that: box->Date): Bool =>
    match year().compare(that.year())
    | Less => true
    | Equal => day_of_year() < that.day_of_year()
    | Greater => false
    end

  fun calendar_string(): String iso^ =>
    let y = year()
    let m = month()
    let d = day_of_month()
    var buffer = recover ("\0" * 20) end
    var format = "%s%04i-%02i-%02i"
    let n = @sprintf[I32](
      buffer.cstring(),
      format.cstring(),
      (if y < 0 then "-" else "" end).cstring(),
      y.abs(), m, d
    )
    buffer.delete(n.isize(), USize.max_value())
    consume buffer

  fun weekdate_string(): String iso^ =>
    (let y, let w, let d) = weekdate()
    var buffer = recover ("\0" * 20) end
    var format = "%s%04i-W%02i-%i"
    let n = @sprintf[I32](
      buffer.cstring(),
      format.cstring(),
      (if year() < 0 then "-" else "" end).cstring(),
      y, w, d
    )
    buffer.delete(n.isize(), USize.max_value())
    consume buffer

  fun ordinal_string(): String iso^ =>
    let y = year()
    let d = day_of_year()
    var buffer = recover ("\0" * 20) end
    var format = "%s%04i-%03i"
    let n = @sprintf[I32](
      buffer.cstring(),
      format.cstring(),
      (if y < 0 then "-" else "" end).cstring(),
      y, d
    )
    buffer.delete(n.isize(), USize.max_value())
    consume buffer

  fun string(): String iso^ => calendar_string()

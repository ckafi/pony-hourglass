use "files"

class TimeZones
  let _base: (AmbientAuth | FilePath)
  let rootpath: String

  new create(
    base: (AmbientAuth | FilePath | None),
    rootpath': String = "/usr/share/zoneinfo") ?
  =>
    if base is None then error
    else _base = base as (AmbientAuth | FilePath) end
    rootpath = rootpath'

  fun apply(tzid: String) : TimeZone ?  =>
    let tz_path = Path.join(rootpath, tzid)
    let fpath = FilePath(_base, tz_path)?
    if not fpath.exists() then
      _Debug.throw_error("Time zone id invalid: " + tzid)?
    end
    TimeZone._from_tziffile(fpath, tzid)?

  fun from_file(path: String): TimeZone ? =>
    let fpath = FilePath(_base, path)?
    TimeZone._from_tziffile(fpath)?

  fun local(): TimeZone ? =>
    from_file("/etc/localtime")?

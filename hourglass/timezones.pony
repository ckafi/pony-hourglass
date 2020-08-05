use "files"

class TimeZones
  let _auth: AmbientAuth
  let rootpath: String

  new create(
    auth: (AmbientAuth | None),
    rootpath': String = "/usr/share/zoneinfo") ?
  =>
    match auth
    | let auth': AmbientAuth => _auth = auth'
    else error
    end
    rootpath = rootpath'

  fun apply(tzid: String) : TimeZone ?  =>
    let tz_path = Path.join(rootpath, tzid)
    let fpath = FilePath(_auth, tz_path)?
    if not fpath.exists() then
      _Debug.throw_error("Time zone id invalid: " + tzid)?
    end
    TimeZone._from_tziffile(fpath, tzid)?

  fun from_file(path: String): TimeZone ? =>
    let fpath = FilePath(_auth, path)?
    TimeZone._from_tziffile(fpath)?

  fun local(): TimeZone ? =>
    from_file("/etc/localtime")?

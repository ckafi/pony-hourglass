use "buffered"
use "collections"
use "files"

class val TimeZone
  let id: (String | None)
  var _times: Array[_TransitionTime] = _times.create()
  var _types: Array[_TransitionType] = _types.create()
  var _designations: String val = ""

  fun apply(t: I64): (I32, Bool, String val) =>
    var typeidx = USize(0)
    for (i,v) in _times.pairs() do
      if v.time > t then break
      else typeidx = v.typeidx end
    end

    try
      let ttype = _types(typeidx)?
      (
        ttype.utcoff,
        ttype.isdst,
        _get_desig(ttype.desigidx)
      )
    else
      (0, false, recover String end)
    end

  fun string(): String iso^ =>
    let s = recover String(200) end
    s .> append("Time zone id: ")
      .> append(id.string())
      .> append("\nTransition times:\n")
      .> append("\n".join(_times.values()))
      .> append("\nTransition types:\n")
      .> append("\n".join(_types.values()))
    consume s

  fun eq(that: box->TimeZone): Bool =>
    var result = false
    try
      for (i, v) in _times.pairs() do
        if v != that._times(i)? then return false end
      end
      for (i, v) in _types.pairs() do
        if v != that._types(i)? then return false end
      end
      result = true
    end
    result

  new val _from_tziffile(fpath: FilePath, id': (String | None) = None ) ? =>
    id = id'
    let file = File.open(fpath)
    try
      var bytewidth = _handle_header(file)?
      let isutcnt = _read_u32(file)
      let isstdcnt = _read_u32(file)
      let leapcnt = _read_u32(file)
      let timecnt = _read_u32(file)
      let typecnt = _read_u32(file)
      let charcnt = _read_u32(file)
      _check_file(file)?
      _populate(timecnt, typecnt)
      // parsing all the fields
      _transition_times(file, timecnt, bytewidth)?
      _transition_types(file, timecnt)?
      _local_time_type_records(file, typecnt)?
      _time_zone_designations(file, charcnt)
      _skip_leap_seconds(file, leapcnt, bytewidth)?
      _standard_wall_indicators(file, isstdcnt)?
      _ut_local_indicators(file, isutcnt)?
    else error
    then file.dispose() // won't use `with`, because its eats the error
    end

  fun _handle_header(file: File): USize ? =>
    var bytewidth: USize = 4
    let magic = file.read_string(4)
    if magic != "TZif" then
      _Debug.throw_error("Not a TZif file: " + file.path.path)?
    end
    match file.read(1)(0)?
    | '2' => _seek_next_header(file)?; bytewidth = 8
    | '3' => _seek_next_header(file)?; bytewidth = 8
    end
    file.seek(15)
    bytewidth

  fun _seek_next_header(file: File) ? =>
    repeat // search for next header magic
      try while file.read(1)(0)? != 'T' do None end
      else _Debug.throw_error("Malformed TZif file: " + file.path.path)?
      end
    until file.read_string(3) == "Zif" end
    file.read(1) // skip version number
    _check_file(file)?

  fun ref _populate(timecnt: U32, typecnt: U32) =>
    for c in Range[U32](0, timecnt) do _times.push(_TransitionTime) end
    for c in Range[U32](0, typecnt) do _types.push(_TransitionType) end

  fun ref _transition_times(file: File, timecnt: U32, bytewidth: USize) ? =>
    var count: USize = 0
    while count.u32() < timecnt do
      _times(count)?.time =
        if bytewidth == 4 then _read_u32(file).i64()
        else _read_u64(file).i64() end * 1000
      count = count + 1
    end
    _check_file(file)?

  fun ref _transition_types(file: File, timecnt: U32) ? =>
    var count: USize = 0
    while count.u32() < timecnt do
      _times(count)?.typeidx = file.read(1)(0)?.usize()
      count = count + 1
    end
    _check_file(file)?

  fun ref _local_time_type_records(file: File, typecnt: U32) ? =>
    var count: USize = 0
    while count.u32() < typecnt do
      let t = _types(count)?
      t.utcoff = _read_u32(file).i32() * 1000
      t.isdst = (file.read(1)(0)? != 0)
      t.desigidx = file.read(1)(0)?.usize()
      count = count + 1
    end
    _check_file(file)?

  fun ref _time_zone_designations(file: File, charcnt: U32) =>
    _designations = file.read_string(charcnt.usize())

  fun ref _skip_leap_seconds(file: File, leapcnt: U32, bytewidth: USize) ? =>
    if leapcnt != 0 then
      _Debug.print_warning(
        "Given TZif file contains leap seconds: " + file.path.path
        + "\n         Hourglass does not adjust for leap seconds.")
    end
    file.seek((leapcnt.usize() * (bytewidth + 4)).isize())
    _check_file(file)?

  fun ref _standard_wall_indicators(file: File, isstdcnt: U32) ? =>
    var count: USize = 0
    let isstdcnt' = if isstdcnt == 0 then _types.size().u32() else isstdcnt end
    while count.u32() < isstdcnt' do
      _types(count)?.isstd = (file.read(1)(0)? != 0)
      count = count + 1
    end
    _check_file(file)?

  fun ref _ut_local_indicators(file: File, isutcnt: U32) ? =>
    var count: USize = 0
    let isutcnt' = if isutcnt == 0 then _types.size().u32() else isutcnt end
    while count.u32() < isutcnt do
      _types(count)?.isut = (file.read(1)(0)? != 0)
      count = count + 1
    end
    _check_file(file)?

  fun _check_file(file: File) ? =>
    if file.errno() isnt FileOK then
      _Debug.throw_error("Malformed TZif file: " + file.path.path)?
    end

  fun _read_u32(file: File): U32 =>
    var res = U32(0)
    for v in file.read(4).values() do
      res = (res << 8) or v.u32()
    end
    res

  fun _read_u64(file: File): U64 =>
    var res = U64(0)
    for v in file.read(8).values() do
      res = (res << 8) or v.u64()
    end
    res

  fun _get_desig(idx: USize): String val =>
    try
      let end' = _designations.find("\0", idx.isize())?
      _designations.trim(idx, end'.usize())
    else recover String end end


class _TransitionTime is Equatable[_TransitionTime]
  var time: I64 = 0 /* *milliseconds* since unix epoch */
  var typeidx: USize = 0

  fun string(): String iso^ =>
    let a = [as Stringable: time; typeidx]
    let s = ", ".join(a.values())
    consume s

  fun eq(that: box->_TransitionTime): Bool =>
    (time == that.time) and (typeidx == that.typeidx)

class _TransitionType is Equatable[_TransitionType]
  var utcoff: I32 = 0 /* in *milliseconds* */
  var isdst: Bool = false
  var desigidx: USize = 0
  // not sure we need these
  var isstd: Bool = false
  var isut: Bool = false

  fun string(): String iso^ =>
    let a = [as Stringable: utcoff; isdst; desigidx; isstd; isut]
    let s = ", ".join(a.values())
    consume s

  fun eq(that: box->_TransitionType): Bool =>
    (utcoff == that.utcoff) and
    (isdst == that.isdst) and
    (desigidx == that.desigidx) and
    (isstd == that.isstd) and
    (isut == that.isut)

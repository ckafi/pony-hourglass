struct _Tm
  var tm_sec: I32 = 0
  var tm_min: I32 = 0
  var tm_hour: I32 = 0
  var tm_mday: I32 = 0
  var tm_mon: I32 = 0
  var tm_year: I32 = 0
  var tm_wday: I32 = 0
  var tm_yday: I32 = 0
  var tm_isdst: I32 = 0
  var tm_gmtoff: ILong = 0

  new create() => None

primitive _CTime
  fun now(): (ILong, ILong) =>
    ifdef linux or bsd then
      var ts: (ILong, ILong) = (0, 0)
      @clock_gettime[I32](U32(0), addressof ts)
      ts
    else
      compile_error "unsupported platform"
    end

  fun localtime(time: ILong): _Tm =>
    ifdef linux or bsd then
      var t = time
      let tm = _Tm
      @localtime_r[Pointer[_Tm]](addressof t, NullablePointer[_Tm](tm))
      tm
    else
      compile_error "unsupported platform"
    end

  fun gmtime(time: ILong): _Tm =>
    ifdef linux or bsd then
      var t = time
      let tm = _Tm
      @gmtime_r[Pointer[_Tm]](addressof t, NullablePointer[_Tm](tm))
      tm
    else
      compile_error "unsupported platform"
    end


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
  fun localtime(): _Tm =>
    ifdef linux or bsd then
      let tm = _Tm
      @localtime_r[Pointer[_Tm]](ISize(0), NullablePointer[_Tm](tm))
      tm
    else
      compile_error "unsupported platform"
    end

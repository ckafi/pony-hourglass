primitive _Debug
  fun print(s: Stringable) =>
    @printf[I32](s.string().cstring())
    @printf[I32]("\n".cstring())

  fun print_stderr(msg: String) =>
    let msg' = (msg + "\n").cstring()
    @fprintf[I32](
      @pony_os_stderr[Pointer[U8]](),
      msg'
    )

  fun print_warning(msg: String) =>
    print_stderr("WARNING: " + msg)

  fun print_error(msg: String) =>
    print_stderr("ERROR: " + msg)

  fun throw_error(msg: String) ? =>
    print_error(msg)
    error

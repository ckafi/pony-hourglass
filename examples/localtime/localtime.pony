// in your code this `use` statement would be:
// use "hourglass"
use "../../hourglass"

actor Main

  new create(env: Env) =>
    let print = {(s: Stringable) => env.out.print(s.string()) }
    let write = {(s: Stringable) => env.out.write(s.string()) }
    let u: I64 = 1_000_000_000

    print("--- System Time ---")
    write("Now:        ")
    print(LocalTime.now())
    write("UNIX(10^9): ")
    print(LocalTime.from_unix(u))

    print("\n--- Simple Offsets ---")
    write("Now+02:00:        ")
    print(LocalTime.now() .> set_offset(2))
    write("Now-03:30:        ")
    print(LocalTime.now() .> set_offset(-3,-30))
    write("UNIX(10^9)+02:00: ")
    print(LocalTime.from_unix(u) .> set_offset(2))
    write("UNIX(10^9)-03:30: ")
    print(LocalTime.from_unix(u) .> set_offset(-3,-30))

    print("\n--- Offset from Time Zones ---")
    // The time zone needs absolute timestamp,
    // so we need to provide it during `now` or `from_unix`.
    try
      let zone = TimeZones(env.root)?
      let local = zone.local()?
      let london = zone("Europe/London")?
      let honolulu = zone("Pacific/Honolulu")?
      write("Now locally:            ")
      print(LocalTime.now(local))
      write("Now in London:          ")
      print(LocalTime.now(london))
      write("Now in Honolulu:        ")
      print(LocalTime.now(honolulu))
      write("UNIX(10^9) locally:     ")
      print(LocalTime.from_unix(u where tz = local))
      write("UNIX(10^9) in London:   ")
      print(LocalTime.from_unix(u where tz = london))
      write("UNIX(10^9) in Honolulu: ")
      print(LocalTime.from_unix(u where tz = honolulu))
    end

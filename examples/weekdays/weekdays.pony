// in your code this `use` statement would be:
// use "hourglass"
use "../../hourglass"

actor Main

  new create(env: Env) =>
    let print = {(s: Stringable) => env.out.print(s.string()) }
    let write = {(s: Stringable) => env.out.write(s.string()) }

    print("--- Differences between weekdays ---")
    for v1 in Weekdays.values() do
      for v2 in Weekdays.values() do
        write(v1); write(" -> "); write(v2)
        write(" = "); print(v1.diff(v2))
      end
    end

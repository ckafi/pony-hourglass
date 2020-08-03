// in your code this `use` statement would be:
// use "hourglass"
use "../../hourglass"

actor Main

  fun compare(x: Weekday, y: Weekday): String =>
    x.string() + " is " +
      if x == y then "" else "not " end +
      "the same weekday as " +
      y.string()


  new create(env: Env) =>
    let x:Weekday = Monday
    let y:Weekday = Monday
    let z:Weekday = Sunday

    env.out.print(compare(x, y))
    env.out.print(compare(x, z))

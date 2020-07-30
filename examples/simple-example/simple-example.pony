// in your code this `use` statement would be:
// use "hourglass"
use "../../hourglass"

actor Main

  new create(env: Env) =>
    let x:Weekday = Monday
    let y:Weekday = Monday
    let z:Weekday = Sunday

    env.out.print("1" + if x == y then "true" else "false" end)
    env.out.print("2" + if x == z then "true" else "false" end)

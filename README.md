![Hourglass](https://raw.githubusercontent.com/ckafi/pony-hourglass/master/logo.png)

An ISO 8601 conform, time zone aware date and time package for pony.

## Status

[![CircleCI](https://circleci.com/gh/ckafi/pony-hourglass.svg?style=svg)](https://circleci.com/gh/ckafi/pony-hourglass)

Hourglass is pre-alpha software. Test coverage is not great yet, and breaking changes **will** occur. Use at your own peril.

## Progess

- [X] Local time
- [X] Local date
- [ ] Combined local date/time
- [X] Time zones
- [X] Zoneinfo parser
- [ ] Zoned time
- [ ] Zoned date
- [ ] Combined zoned date/time
- [ ] Durations
- [ ] Intervals
- [ ] 'Moments' (monotonic time points)
- [ ] Conversion to different calendar systems
- [ ] Leap seconds (maybe)

## Caveats

- Hourglass uses the proleptic Gregorian calendar (as by ISO 8601:2004), meaning it is assumed that the Gregorian calendar is in effect at all times in the past and future, and that the year before 1 AD is the year 0.
- Hourglass does not (yet) handle leap seconds. All internal computation is based on leap second free UTC. If your system time is based on TAI, this package might no be for you.
- There is (next to) no input validation, meaning you could try to create a time point `2020-13-55 -12:66:91` without raising an error. Sensible defaults will be substituted, and Hourglass will print a warning, but: garbage in, garbage out.

## Acknowledgments

My thanks goes to Howard Hinnant, whose excellent paper [chrono-Compatible Low-Level Date Algorithms](https://howardhinnant.github.io/date_algorithms.html) helped a lot during first implementation.

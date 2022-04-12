<!--
SPDX-License-Identifier: MIT
SPDX-FileCopyrightText: 2022 Tobias Frilling
-->
## Caveats
- **No support leap seconds**

  Listen, man, leap seconds are … _complicated_, leading to complicated decisions with weird consequences. What about the time before atomic time keeping? Are we just just going to pretend that before 1958 the rotation of earth was super stable, and that `TAI-UTC` has always been 0? More pressingly, what about future leap seconds? Will there be a leap second six month from now? Who knows! [Maybe there will never be another leap second.](https://en.wikipedia.org/wiki/Leap_second#International_proposals_for_elimination_of_leap_seconds)
  
  Okay, maybe you can live with that, at least leap seconds are always integers, right? Fun fact: Did you know that UTC started _with a 1.422818 second difference to TAI?_ And that between 1961 and 1972 the solution for the drift between UTC and UT2 was to _deliberately slow down the atomic clocks_?! So to calculate the difference to TAI you'd have to do a [linear interpolation of the frequency shifts](https://hpiers.obspm.fr/iers/bul/bulc/UTC-TAI.history). This can sometime lead to negative values, which means the length of a minute can basically be _any value between 59e9 and 61e9 nanoseconds._ Oh, and the relationship between UTC and TAI in the time from 1958 to 1961 is _not formally defined_. Fun!

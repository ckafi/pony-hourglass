use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestWeekdayCreation)
    test(_TestWeekdayValue)
    test(_TestWeekdaySting)
    test(_TestWeekdayDiff)
    test(_TestWeekdayAddSub)

    test(_TestWeekDateWiki)

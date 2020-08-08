use "ponytest"
use "random"

class iso _TestWeekdayCreation is UnitTest
  fun name(): String => "Create weekdays from ints"
  fun apply(h: TestHelper) =>
    h.assert_eq[Weekday](Weekdays(0), Sunday)
    h.assert_eq[Weekday](Weekdays(1), Monday)
    h.assert_eq[Weekday](Weekdays(2), Tuesday)
    h.assert_eq[Weekday](Weekdays(3), Wednesday)
    h.assert_eq[Weekday](Weekdays(4), Thursday)
    h.assert_eq[Weekday](Weekdays(5), Friday)
    h.assert_eq[Weekday](Weekdays(6), Saturday)
    h.assert_eq[Weekday](Weekdays(7), Sunday)

class iso _TestWeekdayValue is UnitTest
  fun name(): String => "Numerical values of weekdays"
  fun apply(h: TestHelper) =>
    h.assert_eq[I32](Monday(), 1)
    h.assert_eq[I32](Tuesday(), 2)
    h.assert_eq[I32](Wednesday(), 3)
    h.assert_eq[I32](Thursday(), 4)
    h.assert_eq[I32](Friday(), 5)
    h.assert_eq[I32](Saturday(), 6)
    h.assert_eq[I32](Sunday(), 7)

class iso _TestWeekdaySting is UnitTest
  fun name(): String => "Numerical values of weekdays"
  fun apply(h: TestHelper) =>
    h.assert_eq[String](Monday.string(), "Monday")
    h.assert_eq[String](Tuesday.string(), "Tuesday")
    h.assert_eq[String](Wednesday.string(), "Wednesday")
    h.assert_eq[String](Thursday.string(), "Thursday")
    h.assert_eq[String](Friday.string(), "Friday")
    h.assert_eq[String](Saturday.string(), "Saturday")
    h.assert_eq[String](Sunday.string(), "Sunday")

class iso _TestWeekdayDiff is UnitTest
  fun name(): String => "Difference between weekdays"
  fun apply(h: TestHelper) =>
    let a: Array[Array[I32]] =
    [
      [0; 1; 2; 3; 4; 5; 6]
      [6; 0; 1; 2; 3; 4; 5]
      [5; 6; 0; 1; 2; 3; 4]
      [4; 5; 6; 0; 1; 2; 3]
      [3; 4; 5; 6; 0; 1; 2]
      [2; 3; 4; 5; 6; 0; 1]
      [1; 2; 3; 4; 5; 6; 0]
    ]
    for d1 in Weekdays.values() do
      for d2 in Weekdays.values() do
        try
          h.assert_eq[I32](
            d1.diff(d2),
            a(d1().usize() - 1)?(d2().usize() - 1)?)
        else h.fail() end
      end
    end

class iso _TestWeekdayAddSub is UnitTest
  fun name(): String => "Weekday add and sub"
  fun apply(h: TestHelper) =>
    let rand = Rand.u16().i32() * 7
    for d1 in Weekdays.values() do
      for d2 in Weekdays.values() do
        h.assert_eq[Weekday](d1 + (rand + d1.diff(d2)), d2)
        h.assert_eq[Weekday](d1 - (rand + d2.diff(d1)), d2)
      end
    end

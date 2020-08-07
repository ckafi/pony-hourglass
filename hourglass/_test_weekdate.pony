use "ponytest"

type T is (I32, I32, I32)

class iso _TestWeekDateWiki is UnitTest
  fun name(): String => "Week date from Wikipedia Examples"

  fun test_dates(d: T, w: T, h: TestHelper) =>
    h.assert_array_eq[I32](
      to_array(LocalDate(d._1,d._2,d._3).weekdate()),
      to_array(w),
      tuple_string(d)
    )

  fun to_array(t: T): Array[I32] =>
    [as I32: t._1; t._2; t._3]

  fun tuple_string(x:T): String iso^ =>
    let s = recover String end
    s.>append("(").>append(x._1.string())
     .>append(",").>append(x._2.string())
     .>append(",").>append(x._3.string())
     .>append(")")
    consume s

  fun apply(h: TestHelper) =>
    test_dates((2005,01,01),(2004,53,6),h)
    test_dates((2005,01,01),(2004,53,6),h)
    test_dates((2005,01,02),(2004,53,7),h)
    test_dates((2005,12,31),(2005,52,6),h)
    test_dates((2006,01,01),(2005,52,7),h)
    test_dates((2006,01,02),(2006,01,1),h)
    test_dates((2006,12,31),(2006,52,7),h)
    test_dates((2007,01,01),(2007,01,1),h)
    test_dates((2007,12,30),(2007,52,7),h)
    test_dates((2007,12,31),(2008,01,1),h)
    test_dates((2008,01,01),(2008,01,2),h)
    test_dates((2008,12,28),(2008,52,7),h)
    test_dates((2008,12,29),(2009,01,1),h)
    test_dates((2008,12,30),(2009,01,2),h)
    test_dates((2008,12,31),(2009,01,3),h)
    test_dates((2009,01,01),(2009,01,4),h)
    test_dates((2009,12,31),(2009,53,4),h)
    test_dates((2010,01,01),(2009,53,5),h)
    test_dates((2010,01,02),(2009,53,6),h)

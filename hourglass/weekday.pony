type Weekday is
  ( Sunday
  | Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday)

primitive Sunday is Equatable[Weekday]
  fun string(): String iso^ => "sunday".string()
  fun apply(): I32 => 0

primitive Monday is Equatable[Weekday]
  fun string(): String iso^ => "monday".string()
  fun apply(): I32 => 1

primitive Tuesday is Equatable[Weekday]
  fun string(): String iso^ => "tuesday".string()
  fun apply(): I32 => 2

primitive Wednesday is Equatable[Weekday]
  fun string(): String iso^ => "wednesday".string()
  fun apply(): I32 => 3

primitive Thursday is Equatable[Weekday]
  fun string(): String iso^ => "thursday".string()
  fun apply(): I32 => 4

primitive Friday is Equatable[Weekday]
  fun string(): String iso^ => "friday".string()
  fun apply(): I32 => 5

primitive Saturday is Equatable[Weekday]
  fun string(): String iso^ => "saturday".string()
  fun apply(): I32 => 6

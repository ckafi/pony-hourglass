type Weekday is
  ( Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday
  | Sunday)

trait WeekdayT is (Stringable & Equatable[Weekday])
  fun string(): String iso^
  fun apply(): I32
  fun add(i: I32): Weekday => Weekdays((this.apply() + i) %% 7)
  fun sub(i: I32): Weekday => add(-i)
  fun diff(that: Weekday): I32 => (that() - this()) %% 7

primitive Monday is WeekdayT
  fun string(): String iso^ => "Monday".string()
  fun apply(): I32 => 1

primitive Tuesday is WeekdayT
  fun string(): String iso^ => "Tuesday".string()
  fun apply(): I32 => 2

primitive Wednesday is WeekdayT
  fun string(): String iso^ => "Wednesday".string()
  fun apply(): I32 => 3

primitive Thursday is WeekdayT
  fun string(): String iso^ => "Thursday".string()
  fun apply(): I32 => 4

primitive Friday is WeekdayT
  fun string(): String iso^ => "Friday".string()
  fun apply(): I32 => 5

primitive Saturday is WeekdayT
  fun string(): String iso^ => "Saturday".string()
  fun apply(): I32 => 6

primitive Sunday is WeekdayT
  fun string(): String iso^ => "Sunday".string()
  fun apply(): I32 => 7

primitive Weekdays
  fun apply(d: I32): Weekday =>
    match d
    | 0 => Sunday
    | 1 => Monday
    | 2 => Tuesday
    | 3 => Wednesday
    | 4 => Thursday
    | 5 => Friday
    | 6 => Saturday
    | 7 => Sunday
    else
      // I don't feel like making this a partial function
      _Debug.print_warning("Not a weekday value: " + d.string())
      Sunday
    end

  fun values(): ArrayValues[Weekday, Array[Weekday]]^ =>
    let a = [Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday]
    ArrayValues[Weekday, Array[Weekday]](a)

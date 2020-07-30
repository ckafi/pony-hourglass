type Weekday is ( Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday)


primitive Monday is Equatable[Weekday]
    fun string(): String iso^ => "monday".string()


primitive Tuesday is Equatable[Weekday]
    fun string(): String iso^ => "tuesday".string()


primitive Wednesday is Equatable[Weekday]
    fun string(): String iso^ => "wednesday".string()


primitive Thursday is Equatable[Weekday]
    fun string(): String iso^ => "thursday".string()


primitive Friday is Equatable[Weekday]
    fun string(): String iso^ => "friday".string()


primitive Saturday is Equatable[Weekday]
    fun string(): String iso^ => "saturday".string()


primitive Sunday is Equatable[Weekday]
    fun string(): String iso^ => "sunday".string()

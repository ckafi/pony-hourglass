type Duration is (DateDuration | TimeDuration)

trait val DateDuration
  fun amount(): U32

trait val TimeDuration
  fun amount(): U32

class Years is DateDuration
  let _amount: U32

  new create(amount': U32) => _amount = amount'

  fun amount(): U32 => _amount

class Months is DateDuration
  let _amount: U32

  new create(amount': U32) => _amount = amount'

  fun amount(): U32 => _amount

class Days is DateDuration
  let _amount: U32

  new create(amount': U32) => _amount = amount'

  fun amount(): U32 => _amount


class Hours is TimeDuration
  let _amount: U32

  new create(amount': U32) => _amount = amount'

  fun amount(): U32 => _amount

class Minutes is TimeDuration
  let _amount: U32

  new create(amount': U32) => _amount = amount'

  fun amount(): U32 => _amount

class Seconds is TimeDuration
  let _amount: U32

  new create(amount': U32) => _amount = amount'

  fun amount(): U32 => _amount


class Millis is TimeDuration
  let _amount: U32

  new create(amount': U32) => _amount = amount'

  fun amount(): U32 => _amount

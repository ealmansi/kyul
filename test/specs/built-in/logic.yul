{
  assertEqualBool(
    and(false:bool, false:bool),
    false:bool
  )
  assertEqualBool(
    and(false:bool, true:bool),
    false:bool
  )
  assertEqualBool(
    and(true:bool, false:bool),
    false:bool
  )
  assertEqualBool(
    and(true:bool, true:bool),
    true:bool
  )
  assertEqualBool(
    not(false:bool),
    true:bool
  )
  assertEqualBool(
    not(true:bool),
    false:bool
  )
  assertEqualBool(
    or(false:bool, false:bool),
    false:bool
  )
  assertEqualBool(
    or(false:bool, true:bool),
    true:bool
  )
  assertEqualBool(
    or(true:bool, false:bool),
    true:bool
  )
  assertEqualBool(
    or(true:bool, true:bool),
    true:bool
  )
  assertEqualBool(
    xor(false:bool, false:bool),
    false:bool
  )
  assertEqualBool(
    xor(false:bool, true:bool),
    true:bool
  )
  assertEqualBool(
    xor(true:bool, false:bool),
    true:bool
  )
  assertEqualBool(
    xor(true:bool, true:bool),
    false:bool
  )

  function assert (c:bool) { if not(c) { abort() } }
  function assertEqualBool (a:bool, b:bool) { assert(not(xor(a, b))) }
}

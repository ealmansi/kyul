{
  // mulu256(x:u256, y:u256) -> z:u256
  assertEqualU256(
    mulu256(123456:u256, 3456789:u256),
    426761342784:u256
  )

  function assert (c:bool) { if not(c) { abort() } }
  function assertEqualBool (a:bool, b:bool) { assert(not(xor(a, b))) }
  function assertEqualS256 (a:s256, b:s256) { assert(eqS256(a, b)) }
  function assertEqualU256 (a:u256, b:u256) { assert(eqU256(a, b)) }
  function eqS256 (a:s256, b:s256) -> r:bool { r := not(or(lts256(a, b), lts256(b, a))) }
  function eqU256 (a:u256, b:u256) -> r:bool { r := equ256(a, b) }
}

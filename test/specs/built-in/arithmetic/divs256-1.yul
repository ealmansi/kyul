{
  // divs256(x:s256, y:s256) -> z:s256
  assertEqualS256(
    divs256(8:s256, 3:s256),
    2:s256
  )

  function assert (c:bool) { if not(c) { abort() } }
  function assertEqualBool (a:bool, b:bool) { assert(not(xor(a, b))) }
  function assertEqualS256 (a:s256, b:s256) { assert(eqS256(a, b)) }
  function assertEqualU256 (a:u256, b:u256) { assert(eqU256(a, b)) }
  function eqS256 (a:s256, b:s256) -> r:bool { r := not(or(lts256(a, b), lts256(b, a))) }
  function eqU256 (a:u256, b:u256) -> r:bool { r := equ256(a, b) }
}

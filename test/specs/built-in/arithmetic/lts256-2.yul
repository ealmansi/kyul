{
  // lts256(x:s256, y:s256) -> z:bool
  assertEqualBool(
    lts256(0:s256, 1:s256),
    true:bool
  )
  assertEqualBool(
    lts256(
      -57896044618658097711785492504343953926634992332820282019728792003956564819968:s256,
      57896044618658097711785492504343953926634992332820282019728792003956564819967:s256
    ),
    true:bool
  )

  function assert (c:bool) { if not(c) { abort() } }
  function assertEqualBool (a:bool, b:bool) { assert(not(xor(a, b))) }
  function assertEqualS256 (a:s256, b:s256) { assert(eqS256(a, b)) }
  function assertEqualU256 (a:u256, b:u256) { assert(eqU256(a, b)) }
  function eqS256 (a:s256, b:s256) -> r:bool { r := not(or(lts256(a, b), lts256(b, a))) }
  function eqU256 (a:u256, b:u256) -> r:bool { r := equ256(a, b) }
}

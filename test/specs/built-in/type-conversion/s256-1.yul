{
  assertEqualBool(
    s256tobool(0:s256),
    false:bool
  )

  function assert (c:bool) { if not(c) { abort() } }
  function assertEqualBool (a:bool, b:bool) { assert(not(xor(a, b))) }
  function assertEqualS256 (a:s256, b:s256) { assert(eqS256(a, b)) }
  function assertEqualU256 (a:u256, b:u256) { assert(eqU256(a, b)) }
  function assertEqualU32 (a:u32, b:u32) { assert(equ256(u32tou256(a), u32tou256(b))) }
  function assertEqualU64 (a:u64, b:u64) { assert(equ256(u64tou256(a), u64tou256(b))) }
  function eqS256 (a:s256, b:s256) -> r:bool { r := not(or(lts256(a, b), lts256(b, a))) }
  function eqU256 (a:u256, b:u256) -> r:bool { r := equ256(a, b) }
}

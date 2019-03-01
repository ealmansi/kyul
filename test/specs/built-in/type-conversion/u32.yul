{
  assertEqualBool(
    u32tobool(0:u32),
    false:bool
  )
  assertEqualBool(
    u32tobool(1:u32),
    true:bool
  )
  assertEqualBool(
    u32tobool(2:u32),
    true:bool
  )
  assertEqualBool(
    u32tobool(3:u32),
    true:bool
  )
  assertEqualBool(
    u32tobool(10:u32),
    true:bool
  )
  assertEqualBool(
    u32tobool(1000:u32),
    true:bool
  )
  assertEqualBool(
    u32tobool(100000:u32),
    true:bool
  )
  assertEqualBool(
    u32tobool(10000000:u32),
    true:bool
  )
  assertEqualBool(
    u32tobool(4294967294:u32),
    true:bool
  )
  assertEqualBool(
    u32tobool(4294967295:u32),
    true:bool
  )
  assertEqualU64(
    u32tou64(0:u32),
    0:u64
  )
  assertEqualU64(
    u32tou64(1:u32),
    1:u64
  )
  assertEqualU64(
    u32tou64(2:u32),
    2:u64
  )
  assertEqualU64(
    u32tou64(3:u32),
    3:u64
  )
  assertEqualU64(
    u32tou64(10:u32),
    10:u64
  )
  assertEqualU64(
    u32tou64(1000:u32),
    1000:u64
  )
  assertEqualU64(
    u32tou64(100000:u32),
    100000:u64
  )
  assertEqualU64(
    u32tou64(10000000:u32),
    10000000:u64
  )
  assertEqualU64(
    u32tou64(4294967294:u32),
    4294967294:u64
  )
  assertEqualU64(
    u32tou64(4294967295:u32),
    4294967295:u64
  )
  assertEqualU256(
    u32tou256(0:u32),
    0:u256
  )
  assertEqualU256(
    u32tou256(1:u32),
    1:u256
  )
  assertEqualU256(
    u32tou256(2:u32),
    2:u256
  )
  assertEqualU256(
    u32tou256(3:u32),
    3:u256
  )
  assertEqualU256(
    u32tou256(10:u32),
    10:u256
  )
  assertEqualU256(
    u32tou256(1000:u32),
    1000:u256
  )
  assertEqualU256(
    u32tou256(100000:u32),
    100000:u256
  )
  assertEqualU256(
    u32tou256(10000000:u32),
    10000000:u256
  )
  assertEqualU256(
    u32tou256(4294967294:u32),
    4294967294:u256
  )
  assertEqualU256(
    u32tou256(4294967295:u32),
    4294967295:u256
  )
  assertEqualS256(
    u32tos256(0:u32),
    0:s256
  )
  assertEqualS256(
    u32tos256(1:u32),
    1:s256
  )
  assertEqualS256(
    u32tos256(2:u32),
    2:s256
  )
  assertEqualS256(
    u32tos256(3:u32),
    3:s256
  )
  assertEqualS256(
    u32tos256(10:u32),
    10:s256
  )
  assertEqualS256(
    u32tos256(1000:u32),
    1000:s256
  )
  assertEqualS256(
    u32tos256(100000:u32),
    100000:s256
  )
  assertEqualS256(
    u32tos256(10000000:u32),
    10000000:s256
  )
  assertEqualS256(
    u32tos256(4294967294:u32),
    4294967294:s256
  )
  assertEqualS256(
    u32tos256(4294967295:u32),
    4294967295:s256
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
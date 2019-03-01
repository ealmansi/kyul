{
  // addmodu256(x:u256, y:u256, m:u256) -> z:u256
  assertEqualU256(
    addmodu256(2:u256, 2:u256, 3:u256),
    1:u256
  )

  // addu256(x:u256, y:u256) -> z:u256
  assertEqualU256(
    addu256(0:u256, 0:u256),
    0:u256
  )
  assertEqualU256(
    addu256(2:u256, 2:u256),
    4:u256
  )
  assertEqualU256(
    addu256(1234567:u256, 234567:u256),
    1469134:u256
  )
  assertEqualU256(
    addu256(
      115792089237316195423570985008687907853269984665640564039457584007913129639935:u256,
      1:u256
    ),
    0:u256
  )
  assertEqualU256(
    addu256(
      115792089237316195423570985008687907853269984665640564039457584007913129639935:u256,
      1000000000:u256
    ),
    999999999:u256
  )

  // byte(n:u256, x:u256) -> v:u256
  assertEqualU256(
    byte(0:u256, 0:u256),
    0:u256
  )
  assertEqualU256(
    byte(31:u256, 0:u256),
    0:u256
  )
  assertEqualU256(
    byte(0:u256, 115792089237316195423570985008687907853269984665640564039457584007913129639935:u256),
    255:u256
  )
  assertEqualU256(
    byte(31:u256, 115792089237316195423570985008687907853269984665640564039457584007913129639935:u256),
    255:u256
  )

  // divs256(x:s256, y:s256) -> z:s256
  assertEqualS256(
    divs256(8:s256, 3:s256),
    2:s256
  )
  assertEqualS256(
    divs256(8:s256, -3:s256),
    -2:s256
  )
  assertEqualS256(
    divs256(-8:s256, 3:s256),
    -2:s256
  )
  assertEqualS256(
    divs256(-8:s256, -3:s256),
    2:s256
  )
  assertEqualS256(
    divs256(1:s256, 2:s256),
    0:s256
  )
  assertEqualS256(
    divs256(1:s256, -2:s256),
    0:s256
  )
  assertEqualS256(
    divs256(-1:s256, 2:s256),
    0:s256
  )
  assertEqualS256(
    divs256(-1:s256, -2:s256),
    0:s256
  )

  // divu256(x:u256, y:u256) -> z:u256
  assertEqualU256(
    divu256(8:u256, 3:u256),
    2:u256
  )
  assertEqualU256(
    divu256(1:u256, 2:u256),
    0:u256
  )

  // equ256(x:u256, y:u256) -> z:bool
  assertEqualBool(
    equ256(0:u256, 0:u256),
    true:bool
  )
  assertEqualBool(
    equ256(0:u256, 1:u256),
    false:bool
  )

  // expu256(x:u256, y:u256) -> z:u256
  assertEqualU256(
    expu256(2:u256, 10:u256),
    1024:u256
  )
  assertEqualU256(
    expu256(11:u256, 2:u256),
    121:u256
  )

  // gts256(x:s256, y:s256) -> z:bool
  assertEqualBool(
    gts256(1:s256, 0:s256),
    true:bool
  )
  assertEqualBool(
    gts256(-1:s256, 0:s256),
    false:bool
  )

  // gtu256(x:u256, y:u256) -> z:bool
  assertEqualBool(
    gtu256(2:u256, 1:u256),
    true:bool
  )
  assertEqualBool(
    gtu256(0:u256, 1:u256),
    false:bool
  )

  // iszerou256(x:u256) -> z:bool
  assertEqualBool(
    iszerou256(0:u256),
    true:bool
  )
  assertEqualBool(
    iszerou256(1:u256),
    false:bool
  )

  // lts256(x:s256, y:s256) -> z:bool
  assertEqualBool(
    lts256(-1:s256, 0:s256),
    true:bool
  )
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

  // ltu256(x:u256, y:u256) -> z:bool
  assertEqualBool(
    ltu256(0:u256, 1:u256),
    true:bool
  )
  assertEqualBool(
    ltu256(
      115792089237316195423570985008687907853269984665640564039457584007913129639934:u256,
      115792089237316195423570985008687907853269984665640564039457584007913129639935:u256
    ),
    true:bool
  )

  // mods256(x:s256, y:s256) -> z:s256
  assertEqualS256(
    mods256(8:s256, 3:s256),
    2:s256
  )
  assertEqualS256(
    mods256(8:s256, -3:s256),
    2:s256
  )
  assertEqualS256(
    mods256(-8:s256, 3:s256),
    -2:s256
  )
  assertEqualS256(
    mods256(-8:s256, -3:s256),
    -2:s256
  )
  assertEqualS256(
    mods256(1:s256, 2:s256),
    1:s256
  )
  assertEqualS256(
    mods256(1:s256, -2:s256),
    1:s256
  )
  assertEqualS256(
    mods256(-1:s256, 2:s256),
    -1:s256
  )
  assertEqualS256(
    mods256(-1:s256, -2:s256),
    -1:s256
  )

  // modu256(x:u256, y:u256) -> z:u256
  assertEqualU256(
    modu256(8:u256, 3:u256),
    2:u256
  )
  assertEqualU256(
    modu256(1:u256, 2:u256),
    1:u256
  )

  // mulmodu256(x:u256, y:u256, m:u256) -> z:u256
  assertEqualU256(
    mulmodu256(2:u256, 2:u256, 3:u256),
    1:u256
  )

  // mulu256(x:u256, y:u256) -> z:u256
  assertEqualU256(
    mulu256(2:u256, 2:u256),
    4:u256
  )

  // notu256(x:u256) -> z:u256
  assertEqualU256(
    notu256(0:u256),
    115792089237316195423570985008687907853269984665640564039457584007913129639935:u256
  )

  // subu256(x:u256, y:u256) -> z:u256
  assertEqualU256(
    subu256(1:u256, 1:u256),
    0:u256
  )
  assertEqualU256(
    subu256(0:u256, 1:u256),
    115792089237316195423570985008687907853269984665640564039457584007913129639935:u256
  )

  function assert (c:bool) { if not(c) { abort() } }
  function assertEqualBool (a:bool, b:bool) { assert(not(xor(a, b))) }
  function assertEqualS256 (a:s256, b:s256) { assert(eqS256(a, b)) }
  function assertEqualU256 (a:u256, b:u256) { assert(eqU256(a, b)) }
  function eqS256 (a:s256, b:s256) -> r:bool { r := not(or(lts256(a, b), lts256(b, a))) }
  function eqU256 (a:u256, b:u256) -> r:bool { r := equ256(a, b) }
}

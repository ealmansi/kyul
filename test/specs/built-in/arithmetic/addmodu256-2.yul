{
  // addmodu256(x:u256, y:u256, m:u256) -> z:u256
  assertEqualU256(
    addmodu256(38820:u256, 2341:u256, 12964:u256),
    2269:u256
  )
  assertEqualU256(
    addmodu256(40761:u256, 11705:u256, 16205:u256),
    3851:u256
  )
  assertEqualU256(
    addmodu256(42702:u256, 18728:u256, 19446:u256),
    3092:u256
  )
  assertEqualU256(
    addmodu256(44643:u256, 21069:u256, 22687:u256),
    20338:u256
  )
  assertEqualU256(
    addmodu256(46584:u256, 23410:u256, 25928:u256),
    18138:u256
  )
  assertEqualU256(
    addmodu256(48525:u256, 49161:u256, 29169:u256),
    10179:u256
  )
  assertEqualU256(
    addmodu256(50466:u256, 51502:u256, 32410:u256),
    4738:u256
  )
  assertEqualU256(
    addmodu256(91227:u256, 53843:u256, 35651:u256),
    2466:u256
  )
  assertEqualU256(
    addmodu256(93168:u256, 56184:u256, 38892:u256),
    32676:u256
  )
  assertEqualU256(
    addmodu256(95109:u256, 58525:u256, 42133:u256),
    27235:u256
  )
  assertEqualU256(
    addmodu256(97050:u256, 60866:u256, 45374:u256),
    21794:u256
  )
  assertEqualU256(
    addmodu256(155280:u256, 63207:u256, 48615:u256),
    24027:u256
  )
  assertEqualU256(
    addmodu256(157221:u256, 105345:u256, 51856:u256),
    3286:u256
  )
  assertEqualU256(
    addmodu256(182454:u256, 112368:u256, 55097:u256),
    19337:u256
  )
  assertEqualU256(
    addmodu256(184395:u256, 114709:u256, 58338:u256),
    7414:u256
  )
  assertEqualU256(
    addmodu256(186336:u256, 117050:u256, 61579:u256),
    57070:u256
  )
  assertEqualU256(
    addmodu256(188277:u256, 177916:u256, 64820:u256),
    42093:u256
  )
  assertEqualU256(
    addmodu256(190218:u256, 180257:u256, 68061:u256),
    30170:u256
  )
  assertEqualU256(
    addmodu256(192159:u256, 182598:u256, 71302:u256),
    18247:u256
  )
  assertEqualU256(
    addmodu256(197982:u256, 245805:u256, 74543:u256),
    71072:u256
  )
  assertEqualU256(
    addmodu256(199923:u256, 250487:u256, 77784:u256),
    61490:u256
  )
  assertEqualU256(
    addmodu256(306678:u256, 252828:u256, 81025:u256),
    73356:u256
  )
  assertEqualU256(
    addmodu256(308619:u256, 311353:u256, 324147:u256),
    295825:u256
  )
  assertEqualU256(
    addmodu256(310560:u256, 313694:u256, 326088:u256),
    298166:u256
  )

  function assert (c:bool) { if not(c) { abort() } }
  function assertEqualBool (a:bool, b:bool) { assert(not(xor(a, b))) }
  function assertEqualS256 (a:s256, b:s256) { assert(eqS256(a, b)) }
  function assertEqualU256 (a:u256, b:u256) { assert(eqU256(a, b)) }
  function eqS256 (a:s256, b:s256) -> r:bool { r := not(or(lts256(a, b), lts256(b, a))) }
  function eqU256 (a:u256, b:u256) -> r:bool { r := equ256(a, b) }
}

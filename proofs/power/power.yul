{
  let b:u256 := 2:u256
  let e:u256 := 3:u256
  // power
  let p:u256 := b
  let r:u256 := 1:u256
  for {} ltu256(0:u256, e) {} {
    if equ256(modu256(e, 2:u256), 1:u256) {
      r := mulu256(r, p)
    }
    e := divu256(e, 2:u256)
    p := mulu256(p, p)
  }
  #debug r
}

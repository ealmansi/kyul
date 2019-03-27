object "o1" {
  code {
    {
      let v1:bool, v2:u8
      let v3:u256 := 0:u256
      v1 := true:bool
      v1 := v1
      v1, v2 := fn(v1, v2)
      gn()
      let j:u256
      for { let i:u256 := 0:u256 } ltu256(i, 5:u256) { i := addu256(i, 1:u256) } {
        j := hn(i)
        function hn (p:u256) -> r:u256 { r := p }
      }
      if not(ltu256(j, 5:u256)) { j := 0:u256 }
      switch j
        case 0:u256 { let k:u256 := j }
        case 1:u256 { let k:u256 := j }
        default { let k:u256 := j }
      function fn (p1:bool, p2:u8) -> r1:bool, r2:u8 { r1 := p1 r2 := p2 }
      function gn () {}
    }
  }
  object "o2" {
    code {}
    data "s1" "s2"
  }
}

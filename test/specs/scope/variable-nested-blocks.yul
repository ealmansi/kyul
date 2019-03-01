{
  let v1:bool := true:bool
  {
    let v2:bool := true:bool
    {
      function assert (c:bool) { if not(c) { abort() } }
      function assertEqualBool (a:bool, b:bool) { assert(not(xor(a, b))) }
      assertEqualBool(v1, v2)
    }
  }
}

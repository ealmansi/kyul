{
  function fn() -> r1:bool, r2:bool {}
  function gn() -> r1:bool, r2:bool, r3:bool {}
  let x1:bool
  let x2:bool, y2:bool
  let x3:bool, y3:bool, z3:bool
  let x4:bool := false:bool
  let x5:bool, y5:bool := fn()
  let x6:bool, y6:bool, z6:bool := gn()
  x1 := x1
  x2, y2 := fn()
  x3, y3, z3 := gn()
}

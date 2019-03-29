{
  function fn() -> r:bool {}
  function gn(p1:bool, p2:bool) -> r:bool {}
  function hn(p:bool) -> r1:bool, r2:bool, r3:bool {}
  let x:bool := false:bool
  let y:bool := gn(gn(true:bool, fn()), gn(fn(), gn(x, false:bool)))
  let u:bool, v:bool, w:bool := hn(fn())
}

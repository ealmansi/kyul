{
  let v1:bool := false:bool
  let v2:bool := true:bool
  if true:bool {}
  if true:bool { if true:bool {} }
  if v1 {}
  if v2 { if v1 {} }
}

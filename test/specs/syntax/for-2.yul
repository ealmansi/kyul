{
  for {} false:bool {} {}
  for {
    let v1:bool := true:bool
    let v2:u8 := 0:u8
  } v1 {
    v1 := false:bool
  } {
    if v1 {
      v2 := 1:u8
    }
  }
  for {} true:bool {} {
    break
  }
  for {
    let v:bool := true:bool
  } v {} {
    v := false:bool
    continue
    v := true:bool
  }
}

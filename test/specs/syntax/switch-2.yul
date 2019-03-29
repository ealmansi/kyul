{
  let v1:bool
  let v2:u8 := 0:u8
  switch true:bool
    case true:bool {}
    case false:bool {}
  switch v1
    case true:bool {}
    default {}
  switch v1
    case false:bool {}
    default {}
  switch v1
    default {}
  switch v1
    default {
      switch v1
        default {
          switch v1
            default {}
        }
    }
  switch v2
    case 0:u8 { v2 := 1:u8 }
    case 1:u8 { v2 := 2:u8 }
    default { v2 := 3:u8 }
}

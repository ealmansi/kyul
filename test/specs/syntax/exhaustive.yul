object "o1" {
  code {
    {}
    { {} {} }
    {
      let v1:bool
      let v2:bool, v3:bool
      let v4:bool, v5:bool, v6:bool
      let v7:bool := true:bool
      v1 := true:bool
      v2 := v1
      v3 := v2
      v4 := v3
      v5 := v4
      v6 := v5
      v7 := v6
    }
    {
      function fn1 () {}
      function fn2 (a:bool) {}
      function fn3 (a:bool, b:bool) {}
      function fn4 () -> a:bool {}
      function fn5 () -> a:bool, b:bool {}
      function fn6 (a:bool) -> b:bool {}
      function fn7 (a:bool, b:bool) -> c:bool, d:bool {}
    }
    {
      let v1:bool := false:bool
      let v2:bool := true:bool
      if true:bool {}
      if true:bool { if true:bool {} }
      if v1 {}
      if v2 { if v1 {} }
    }
    {
      let v1:bool
      let v2:u8 := 0:u8
      switch true:bool case true:bool {} case false:bool {}
      switch v1 case true:bool {} default {}
      switch v1 case false:bool {} default {}
      switch v1 default {}
      switch v1 default { switch v1 default { switch v1 default {} } }
      switch v2 case 0:u8 { v2 := 1:u8 } case 1:u8 { v2 := 2:u8 } default { v2 := 3:u8 }
    }
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
      for {
        let v1:bool := true:bool
        let v2:u8 := 0:u8
      } v1 {
        switch v2 case 0:u8 { v2 := 1:u8 } case 1:u8 { v2 := 2:u8 } default { v2 := 3:u8 }
      } {
        switch v2 case 3:u8 { v1 := false:bool } default { v1 := true:bool }
      }
      for {} true:bool {} { break }
      for { let v:bool := true:bool } v {} {
        v := false:bool
        continue
        v := true:bool
      }
    }
    {
      function fn1 () {}
      function fn2 () -> b:bool {}
      function fn3 (a:bool) -> b:bool {}
      function fn4 (a:bool, b:bool) -> c:bool, d:bool {}
      function fn5 (a:bool, b:bool, c:bool) {}
      fn1()
      let v1:bool := fn2()
      let v2:bool := fn3(false:bool)
      let v3:bool, v4:bool := fn4(false:bool, false:bool)
      v3, v4 := fn4(false:bool, false:bool)
      fn5(v1, fn3(fn2()), false:bool)
    }
    {
      let v1:bool
      v1 := false:bool
      v1 := true:bool
      let v2:u8
      v2 := 0:u8
      v2 := 255:u8
      let v3:u32
      v3 := 0:u32
      v3 := 4294967295:u32
      let v4:u64
      v4 := 0:u64
      v4 := 18446744073709551615:u64
      let v5:u128
      v5 := 0:u128
      v5 := 340282366920938463463374607431768211455:u128
      let v6:u256
      v6 := 0:u256
      v6 := 115792089237316195423570985008687907853269984665640564039457584007913129639935:u256
      let v7:s8
      v7 := -128:s8
      v7 := 0:s8
      v7 := 127:s8
      let v8:s32
      v8 := -2147483648:s32
      v8 := 0:s32
      v8 := 2147483647:s32
      let v9:s64
      v9 := -9223372036854775808:s64
      v9 := 0:s64
      v9 := 9223372036854775807:s64
      let v10:s128
      v10 := -170141183460469231731687303715884105728:s128
      v10 := 0:s128
      v10 := 170141183460469231731687303715884105727:s128
      let v11:s256
      v11 := -57896044618658097711785492504343953926634992332820282019728792003956564819968:s256
      v11 := 0:s256
      v11 := 57896044618658097711785492504343953926634992332820282019728792003956564819967:s256
    }
  }
  object "o2" {
    code {
    }
    object "o3" {
      code {
      }
    }
    object "o4" {
      code {
      }
      data "s1" "s2"
    }
    object "o5" {
      code {
      }
      data "s3" "s4"
      data "s5" "s6"
      data "s7" hex'00'
      data "s8" hex"00"
    }
    object "o6" {
      code {
      }
      object "o7" {
        code {
        }
      } 
      data "s9" "s10"
    }
  }
}

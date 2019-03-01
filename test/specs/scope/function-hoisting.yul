{
  {
    let v1:bool := fn1()
    let v2:bool := fn2()
    let v3:bool := fn3()
    function fn1 () -> r:bool {}
    function fn2 () -> r:bool {}
    function fn3 () -> r:bool {}
  }
  {
    fn1()
    let v1:bool := fn2(true:bool)
    {
      fn1()
      fn3()
      let v2:bool := fn2(true:bool)
      let v3:bool := fn4(true:bool)
      function fn3 () {}
      function fn4 (a:bool) -> b:bool { b := a }
      for {
        let v5:bool := fn5()
        function fn5 () -> r:bool {}
      } false:bool {} {
        let v6:bool := fn5()
        fn6()
        function fn6 () {}
      }
    }
    function fn1 () {}
    function fn2 (a:bool) -> b:bool { b := a }
  }
}

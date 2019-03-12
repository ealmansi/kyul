requires "./yul-configuration.k"
requires "./yul-evaluation.k"
requires "./yul-syntax.k"
requires "./yul-utility.k"
requires "./yul-value.k"

module YUL-BUILT-IN-ARITHMETIC
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-EVALUATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  /**
  * addmodu256(x:u256, y:u256, m:u256) -> z:u256
  *
  * Returns (x + y) % m, calculated with arbitrary precision arithmetic.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      addmodu256,
      ValueTuple(
        3,
        ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)) ListItem(ValueU256(I3:Int))
      )
    ) =>
    makeValueTuple(ValueU256(((I1 +Int I2) modInt I3)))

  /**
  * addu256(x:u256, y:u256) -> z:u256
  *
  * Returns x + y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      addu256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueU256(((I1 +Int I2) modInt (2 ^Int 256))))

  /**
  * andu256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise and of x and y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(andu256, _:ValueTuple) =>
    NotImplementedError()

  /**
  * byte(n:u256, x:u256) -> v:u256
  *
  * Returns the nth byte of x, where the most significant byte is the 0th byte.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      byte,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueU256(((I2 /Int (256 ^Int (31 -Int I1))) modInt 256)))
    requires 0 <=Int I1 andBool I1 <=Int 31

  /**
  * divs256(x:s256, y:s256) -> z:s256
  *
  * Returns x / y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      divs256,
      ValueTuple(2, ListItem(ValueS256(I1:Int)) ListItem(ValueS256(I2:Int)))
    ) =>
    makeValueTuple(ValueS256((I1 /Int I2)))

  /**
  * divu256(x:u256, y:u256) -> z:u256
  *
  * Returns x / y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      divu256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueU256((I1 /Int I2)))

  /**
  * equ256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x == y, false otherwise.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      equ256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueBool(I1 ==Int I2))

  /**
  * expu256(x:u256, y:u256) -> z:u256
  *
  * Returns x to the power of y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      expu256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueU256(((I1 ^Int I2) modInt (2 ^Int 256))))

  /**
  * gts256(x:s256, y:s256) -> z:bool
  *
  * Returns true if x > y, false otherwise.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      gts256,
      ValueTuple(2, ListItem(ValueS256(I1:Int)) ListItem(ValueS256(I2:Int)))
    ) =>
    makeValueTuple(ValueBool(I1 >Int I2))

  /**
  * gtu256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x > y, false otherwise.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      gtu256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueBool(I1 >Int I2))

  /**
  * iszerou256(x:u256) -> z:bool
  *
  * Returns true if x == 0, false otherwise.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(iszerou256, ValueTuple(1, ListItem(ValueU256(I:Int)))) =>
    makeValueTuple(ValueBool(I ==Int 0))

  /**
  * lts256(x:s256, y:s256) -> z:bool
  *
  * Returns true if x < y, false otherwise.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      lts256,
      ValueTuple(2, ListItem(ValueS256(I1:Int)) ListItem(ValueS256(I2:Int)))
    ) =>
    makeValueTuple(ValueBool(I1 <Int I2)) // >

  /**
  * ltu256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x < y, false otherwise.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      ltu256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueBool(I1 <Int I2)) // >

  /**
  * mods256(x:s256, y:s256) -> z:s256
  *
  * Returns x % y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      mods256,
      ValueTuple(2, ListItem(ValueS256(I1:Int)) ListItem(ValueS256(I2:Int)))
    ) =>
    makeValueTuple(ValueS256((I1 %Int I2)))

  /**
  * modu256(x:u256, y:u256) -> z:u256
  *
  * Returns x % y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      modu256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueU256((I1 modInt I2)))

  /**
  * mulmodu256(x:u256, y:u256, m:u256) -> z:u256
  *
  * Returns (x * y) % m, calculated with arbitrary precision arithmetic.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      mulmodu256,
      ValueTuple(
        3,
        ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)) ListItem(ValueU256(I3:Int))
      )
    ) =>
    makeValueTuple(ValueU256(((I1 *Int I2) modInt I3)))

  /**
  * mulu256(x:u256, y:u256) -> z:u256
  *
  * Returns x * y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      mulu256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueU256(((I1 *Int I2) modInt (2 ^Int 256))))

  /**
  * notu256(x:u256) -> z:u256
  *
  * Returns ~x, where every bit of x is negated.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(notu256, ValueTuple(1, ListItem(ValueU256(I:Int)))) =>
    makeValueTuple(ValueU256((((2 ^Int 256) -Int 1) -Int I)))

  /**
  * oru256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise or of x and y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(oru256, _:ValueTuple) =>
    NotImplementedError()

  /**
  * sars256(x:s256, y:u256) -> z:u256
  *
  * Returns arithmetic right shift of x by y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(sars256, _:ValueTuple) =>
    NotImplementedError()

  /**
  * shlu256(x:u256, y:u256) -> z:u256
  *
  * Returns logical left shift of x by y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(shlu256, _:ValueTuple) =>
    NotImplementedError()

  /**
  * shru256(x:u256, y:u256) -> z:u256
  *
  * Returns logical right shift of x by y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(shru256, _:ValueTuple) =>
    NotImplementedError()

  /**
  * signextendu256(i:u256, x:u256) -> z:u256
  *
  * Returns sign extension from (i*8+7)th bit counting from least significant.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(signextendu256, _:ValueTuple) =>
    NotImplementedError()

  /**
  * subu256(x:u256, y:u256) -> z:u256
  *
  * Returns x - y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      subu256,
      ValueTuple(2, ListItem(ValueU256(I1:Int)) ListItem(ValueU256(I2:Int)))
    ) =>
    makeValueTuple(ValueU256(((I1 -Int I2) modInt (2 ^Int 256))))

  /**
  * xoru256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise xor of x and y.
  */

  rule
    evaluateExpressionFunctionCallBuiltIn(xoru256, _:ValueTuple) =>
    NotImplementedError()

endmodule

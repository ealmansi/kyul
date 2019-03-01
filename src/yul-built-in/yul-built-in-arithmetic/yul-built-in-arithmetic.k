require "../../yul-configuration/yul-configuration.k"
require "../../yul-syntax/yul-syntax.k"
require "../../yul-utility/yul-utility.k"
require "../../yul-value/yul-value.k"

module YUL-BUILT-IN-ARITHMETIC
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  syntax KItem ::=
    "#BuiltInAddModU256" |
    "#BuiltInAddU256" |
    "#BuiltInAndU256" |
    "#BuiltInByte" |
    "#BuiltInDivS256" |
    "#BuiltInDivU256" |
    "#BuiltInEqU256" |
    "#BuiltInExpU256" |
    "#BuiltInGtS256" |
    "#BuiltInGtU256" |
    "#BuiltInIsZeroU256" |
    "#BuiltInLtS256" |
    "#BuiltInLtU256" |
    "#BuiltInModS256" |
    "#BuiltInModU256" |
    "#BuiltInMulModU256" |
    "#BuiltInMulU256" |
    "#BuiltInNotU256" |
    "#BuiltInOrU256" |
    "#BuiltInSarS256" |
    "#BuiltInShlU256" |
    "#BuiltInShrU256" |
    "#BuiltInSignExtendU256" |
    "#BuiltInSubU256" |
    "#BuiltInXorU256"

  /**
  * addmodu256(x:u256, y:u256, m:u256) -> z:u256
  *
  * Returns (x + y) % m, calculated with arbitrary precision arithmetic.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInAddModU256
        ...
      </k>
      requires I ==K String2Id("addmodu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) (#ValueU256 I3) ~> #BuiltInAddModU256 =>
      .ValueSequence (#ValueU256 ((I1 +Int I2) modInt I3))
      ...
    </k>

  /**
  * addu256(x:u256, y:u256) -> z:u256
  *
  * Returns x + y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInAddU256
        ...
      </k>
      requires I ==K String2Id("addu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInAddU256 =>
      .ValueSequence #ValueU256 ((I1 +Int I2) modInt (2 ^Int 256))
      ...
    </k>

  /**
  * andu256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise and of x and y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInAndU256
        ...
      </k>
      requires I ==K String2Id("andu256")

  /**
  * byte(n:u256, x:u256) -> v:u256
  *
  * Returns the nth byte of x, where the most significant byte is the 0th byte.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInByte
        ...
      </k>
      requires I ==K String2Id("byte")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInByte =>
      .ValueSequence (#ValueU256 ((I2 /Int (256 ^Int (31 -Int I1))) modInt 256))
      ...
    </k>
    requires 0 <=Int I1 andBool I1 <=Int 31

  /**
  * divs256(x:s256, y:s256) -> z:s256
  *
  * Returns x / y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInDivS256
        ...
      </k>
      requires I ==K String2Id("divs256")

  rule
    <k>
      .ValueSequence (#ValueS256 I1) (#ValueS256 I2) ~> #BuiltInDivS256 =>
      .ValueSequence (#ValueS256 (I1 /Int I2))
      ...
    </k>

  /**
  * divu256(x:u256, y:u256) -> z:u256
  *
  * Returns x / y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInDivU256
        ...
      </k>
      requires I ==K String2Id("divu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInDivU256 =>
      .ValueSequence (#ValueU256 (I1 /Int I2))
      ...
    </k>

  /**
  * equ256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x == y, false otherwise.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInEqU256
        ...
      </k>
      requires I ==K String2Id("equ256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInEqU256 =>
      .ValueSequence (#ValueBool (I1 ==Int I2))
      ...
    </k>

  /**
  * expu256(x:u256, y:u256) -> z:u256
  *
  * Returns x to the power of y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInExpU256
        ...
      </k>
      requires I ==K String2Id("expu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInExpU256 =>
      .ValueSequence (#ValueU256 ((I1 ^Int I2) modInt (2 ^Int 256)))
      ...
    </k>

  /**
  * gts256(x:s256, y:s256) -> z:bool
  *
  * Returns true if x > y, false otherwise.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInGtS256
        ...
      </k>
      requires I ==K String2Id("gts256")

  rule
    <k>
      .ValueSequence (#ValueS256 I1) (#ValueS256 I2) ~> #BuiltInGtS256 =>
      .ValueSequence (#ValueBool (I1 >Int I2))
      ...
    </k>

  /**
  * gtu256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x > y, false otherwise.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInGtU256
        ...
      </k>
      requires I ==K String2Id("gtu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInGtU256 =>
      .ValueSequence (#ValueBool (I1 >Int I2))
      ...
    </k>

  /**
  * iszerou256(x:u256) -> z:bool
  *
  * Returns true if x == 0, false otherwise.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInIsZeroU256
        ...
      </k>
      requires I ==K String2Id("iszerou256")

  rule
    <k>
      .ValueSequence (#ValueU256 I) ~> #BuiltInIsZeroU256 =>
      .ValueSequence (#ValueBool (I ==Int 0))
      ...
    </k>

  /**
  * lts256(x:s256, y:s256) -> z:bool
  *
  * Returns true if x < y, false otherwise.
  */

  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInLtS256
      ...
    </k>
    requires I ==K String2Id("lts256")

  rule
    <k>
      .ValueSequence (#ValueS256 I1) (#ValueS256 I2) ~> #BuiltInLtS256 =>
      .ValueSequence (#ValueBool (I1 <Int I2))
      ...
    </k>

  /**
  * ltu256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x < y, false otherwise.
  */

  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInLtU256
      ...
    </k>
    requires I ==K String2Id("ltu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInLtU256 =>
      .ValueSequence (#ValueBool (I1 <Int I2))
      ...
    </k>

  /**
  * mods256(x:s256, y:s256) -> z:s256
  *
  * Returns x % y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInModS256
        ...
      </k>
      requires I ==K String2Id("mods256")

  rule
    <k>
      .ValueSequence (#ValueS256 I1) (#ValueS256 I2) ~> #BuiltInModS256 =>
      .ValueSequence (#ValueS256 (I1 %Int I2))
      ...
    </k>

  /**
  * modu256(x:u256, y:u256) -> z:u256
  *
  * Returns x % y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInModU256
        ...
      </k>
      requires I ==K String2Id("modu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInModU256 =>
      .ValueSequence (#ValueU256 (I1 modInt I2))
      ...
    </k>

  /**
  * mulmodu256(x:u256, y:u256, m:u256) -> z:u256
  *
  * Returns (x * y) % m, calculated with arbitrary precision arithmetic.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInMulModU256
        ...
      </k>
      requires I ==K String2Id("mulmodu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) (#ValueU256 I3) ~> #BuiltInMulModU256 =>
      .ValueSequence (#ValueU256 ((I1 *Int I2) modInt I3))
      ...
    </k>

  /**
  * mulu256(x:u256, y:u256) -> z:u256
  *
  * Returns x * y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInMulU256
        ...
      </k>
      requires I ==K String2Id("mulu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInMulU256 =>
      .ValueSequence (#ValueU256 ((I1 *Int I2) modInt (2 ^Int 256)))
      ...
    </k>

  /**
  * notu256(x:u256) -> z:u256
  *
  * Returns ~x, where every bit of x is negated.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInNotU256
        ...
      </k>
      requires I ==K String2Id("notu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I) ~> #BuiltInNotU256 =>
      .ValueSequence (#ValueU256 (((2 ^Int 256) -Int 1) -Int I))
      ...
    </k>

  /**
  * oru256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise or of x and y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInOrU256
        ...
      </k>
      requires I ==K String2Id("oru256")

  /**
  * sars256(x:s256, y:u256) -> z:u256
  *
  * Returns arithmetic right shift of x by y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInSarS256
        ...
      </k>
      requires I ==K String2Id("sars256")

  /**
  * shlu256(x:u256, y:u256) -> z:u256
  *
  * Returns logical left shift of x by y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInShlU256
        ...
      </k>
      requires I ==K String2Id("shlu256")

  /**
  * shru256(x:u256, y:u256) -> z:u256
  *
  * Returns logical right shift of x by y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInShrU256
        ...
      </k>
      requires I ==K String2Id("shru256")

  /**
  * signextendu256(i:u256, x:u256) -> z:u256
  *
  * Returns sign extension from (i*8+7)th bit counting from least significant.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInSignExtendU256
        ...
      </k>
      requires I ==K String2Id("signextendu256")

  /**
  * subu256(x:u256, y:u256) -> z:u256
  *
  * Returns x - y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInSubU256
        ...
      </k>
      requires I ==K String2Id("subu256")

  rule
    <k>
      .ValueSequence (#ValueU256 I1) (#ValueU256 I2) ~> #BuiltInSubU256 =>
      .ValueSequence (#ValueU256 ((I1 -Int I2) modInt (2 ^Int 256)))
      ...
    </k>

  /**
  * xoru256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise xor of x and y.
  */

  rule
      <k>
        I:Identifier ( EL:ExpressionList ) =>
        #EvaluateExpressionsHeat EL ~> #BuiltInXorU256
        ...
      </k>
      requires I ==K String2Id("xoru256")

endmodule

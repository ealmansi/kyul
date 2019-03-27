/* lint:disable */

requires "../../yul-configuration/yul-configuration.k"
requires "../../yul-semantics/yul-semantics.k"
requires "../../yul-syntax/yul-syntax.k"
requires "../../yul-utility/yul-utility.k"
requires "../../yul-value/yul-value.k"

module YUL-BUILT-IN-ARITHMETIC
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SEMANTICS
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
        `FunctionCall2`(#token("addmodu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInAddModU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ListItem(#ValueU256 I3:Int) ~> #BuiltInAddModU256 =>
      ListItem(#ValueU256 ((I1 +Int I2) modInt I3))
      ...
    </k>

  /**
  * addu256(x:u256, y:u256) -> z:u256
  *
  * Returns x + y.
  */

  rule
      <k>
        `FunctionCall2`(#token("addu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInAddU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInAddU256 =>
      ListItem(#ValueU256 ((I1 +Int I2) modInt (2 ^Int 256)))
      ...
    </k>

  /**
  * andu256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise and of x and y.
  */

  rule
      <k>
        `FunctionCall2`(#token("andu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInAndU256
        ...
      </k>

  /**
  * byte(n:u256, x:u256) -> v:u256
  *
  * Returns the nth byte of x, where the most significant byte is the 0th byte.
  */

  rule
      <k>
        `FunctionCall2`(#token("byte", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInByte
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInByte =>
      ListItem(#ValueU256 ((I2 /Int (256 ^Int (31 -Int I1))) modInt 256))
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
        `FunctionCall2`(#token("divs256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInDivS256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueS256 I1:Int) ListItem(#ValueS256 I2:Int) ~> #BuiltInDivS256 =>
      ListItem(#ValueS256 (I1 /Int I2))
      ...
    </k>

  /**
  * divu256(x:u256, y:u256) -> z:u256
  *
  * Returns x / y.
  */

  rule
      <k>
        `FunctionCall2`(#token("divu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInDivU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInDivU256 =>
      ListItem(#ValueU256 (I1 /Int I2))
      ...
    </k>

  /**
  * equ256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x == y, false otherwise.
  */

  rule
      <k>
        `FunctionCall2`(#token("equ256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInEqU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInEqU256 =>
      ListItem(#ValueBool (I1 ==Int I2))
      ...
    </k>

  /**
  * expu256(x:u256, y:u256) -> z:u256
  *
  * Returns x to the power of y.
  */

  rule
      <k>
        `FunctionCall2`(#token("expu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInExpU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInExpU256 =>
      ListItem(#ValueU256 ((I1 ^Int I2) modInt (2 ^Int 256)))
      ...
    </k>

  /**
  * gts256(x:s256, y:s256) -> z:bool
  *
  * Returns true if x > y, false otherwise.
  */

  rule
      <k>
        `FunctionCall2`(#token("gts256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInGtS256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueS256 I1:Int) ListItem(#ValueS256 I2:Int) ~> #BuiltInGtS256 =>
      ListItem(#ValueBool (I1 >Int I2))
      ...
    </k>

  /**
  * gtu256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x > y, false otherwise.
  */

  rule
      <k>
        `FunctionCall2`(#token("gtu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInGtU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInGtU256 =>
      ListItem(#ValueBool (I1 >Int I2))
      ...
    </k>

  /**
  * iszerou256(x:u256) -> z:bool
  *
  * Returns true if x == 0, false otherwise.
  */

  rule
      <k>
        `FunctionCall2`(#token("iszerou256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInIsZeroU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I:Int) ~> #BuiltInIsZeroU256 =>
      ListItem(#ValueBool (I ==Int 0))
      ...
    </k>

  /**
  * lts256(x:s256, y:s256) -> z:bool
  *
  * Returns true if x < y, false otherwise.
  */

  rule
    <k>
      `FunctionCall2`(#token("lts256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInLtS256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueS256 I1:Int) ListItem(#ValueS256 I2:Int) ~> #BuiltInLtS256 =>
      ListItem(#ValueBool (I1 <Int I2))
      ...
    </k>

  /**
  * ltu256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x < y, false otherwise.
  */

  rule
    <k>
      `FunctionCall2`(#token("ltu256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInLtU256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInLtU256 =>
      ListItem(#ValueBool (I1 <Int I2))
      ...
    </k>

  /**
  * mods256(x:s256, y:s256) -> z:s256
  *
  * Returns x % y.
  */

  rule
      <k>
        `FunctionCall2`(#token("mods256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInModS256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueS256 I1:Int) ListItem(#ValueS256 I2:Int) ~> #BuiltInModS256 =>
      ListItem(#ValueS256 (I1 %Int I2))
      ...
    </k>

  /**
  * modu256(x:u256, y:u256) -> z:u256
  *
  * Returns x % y.
  */

  rule
      <k>
        `FunctionCall2`(#token("modu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInModU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInModU256 =>
      ListItem(#ValueU256 (I1 modInt I2))
      ...
    </k>

  /**
  * mulmodu256(x:u256, y:u256, m:u256) -> z:u256
  *
  * Returns (x * y) % m, calculated with arbitrary precision arithmetic.
  */

  rule
      <k>
        `FunctionCall2`(#token("mulmodu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInMulModU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ListItem(#ValueU256 I3:Int) ~> #BuiltInMulModU256 =>
      ListItem(#ValueU256 ((I1 *Int I2) modInt I3))
      ...
    </k>

  /**
  * mulu256(x:u256, y:u256) -> z:u256
  *
  * Returns x * y.
  */

  rule
      <k>
        `FunctionCall2`(#token("mulu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInMulU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInMulU256 =>
      ListItem(#ValueU256 ((I1 *Int I2) modInt (2 ^Int 256)))
      ...
    </k>

  /**
  * notu256(x:u256) -> z:u256
  *
  * Returns ~x, where every bit of x is negated.
  */

  rule
      <k>
        `FunctionCall2`(#token("notu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInNotU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I:Int) ~> #BuiltInNotU256 =>
      ListItem(#ValueU256 (((2 ^Int 256) -Int 1) -Int I))
      ...
    </k>

  /**
  * oru256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise or of x and y.
  */

  rule
      <k>
        `FunctionCall2`(#token("oru256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInOrU256
        ...
      </k>

  /**
  * sars256(x:s256, y:u256) -> z:u256
  *
  * Returns arithmetic right shift of x by y.
  */

  rule
      <k>
        `FunctionCall2`(#token("sars256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInSarS256
        ...
      </k>

  /**
  * shlu256(x:u256, y:u256) -> z:u256
  *
  * Returns logical left shift of x by y.
  */

  rule
      <k>
        `FunctionCall2`(#token("shlu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInShlU256
        ...
      </k>

  /**
  * shru256(x:u256, y:u256) -> z:u256
  *
  * Returns logical right shift of x by y.
  */

  rule
      <k>
        `FunctionCall2`(#token("shru256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInShrU256
        ...
      </k>

  /**
  * signextendu256(i:u256, x:u256) -> z:u256
  *
  * Returns sign extension from (i*8+7)th bit counting from least significant.
  */

  rule
      <k>
        `FunctionCall2`(#token("signextendu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInSignExtendU256
        ...
      </k>

  /**
  * subu256(x:u256, y:u256) -> z:u256
  *
  * Returns x - y.
  */

  rule
      <k>
        `FunctionCall2`(#token("subu256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInSubU256
        ...
      </k>

  rule
    <k>
      ListItem(#ValueU256 I1:Int) ListItem(#ValueU256 I2:Int) ~> #BuiltInSubU256 =>
      ListItem(#ValueU256 ((I1 -Int I2) modInt (2 ^Int 256)))
      ...
    </k>

  /**
  * xoru256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise xor of x and y.
  */

  rule
      <k>
        `FunctionCall2`(#token("xoru256", "Id"), EL:ExpressionList) =>
        #FunctionArguments toBuiltInList(EL) ~> #BuiltInXorU256
        ...
      </k>

endmodule

require "../../yul-configuration/yul-configuration.k"
require "../../yul-execution/yul-execution.k"
require "../../yul-syntax/yul-syntax.k"
require "../../yul-value/yul-value.k"

module YUL-BUILT-IN-ARITHMETIC
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-EXECUTION
  imports YUL-SYNTAX
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
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInAddModU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("addmodu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) (#ValueU256 I3) .ValueSequence ~> #BuiltInAddModU256 =>
      (#ValueU256 ((I1 +Int I2) modInt I3)) .ValueSequence
      ...
    </k>

  /**
  * addu256(x:u256, y:u256) -> z:u256
  *
  * Returns x + y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInAddU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("addu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInAddU256 =>
      (#ValueU256 ((I1 +Int I2) modInt (2 ^Int 256))) .ValueSequence
      ...
    </k>

  /**
  * andu256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise and of x and y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInAndU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("andu256"))

  /**
  * byte(n:u256, x:u256) -> v:u256
  *
  * Returns the nth byte of x, where the most significant byte is the 0th byte.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInByte
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("byte"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInByte =>
      (#ValueU256 ((I2 /Int (256 ^Int (31 -Int I1))) modInt 256)) .ValueSequence
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
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInDivS256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("divs256"))

  rule
    <k>
      (#ValueS256 I1) (#ValueS256 I2) .ValueSequence ~> #BuiltInDivS256 =>
      (#ValueS256 (I1 /Int I2)) .ValueSequence
      ...
    </k>

  /**
  * divu256(x:u256, y:u256) -> z:u256
  *
  * Returns x / y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInDivU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("divu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInDivU256 =>
      (#ValueU256 (I1 /Int I2)) .ValueSequence
      ...
    </k>

  /**
  * equ256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x == y, false otherwise.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInEqU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("equ256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInEqU256 =>
      (#ValueBool (I1 ==Int I2)) .ValueSequence
      ...
    </k>

  /**
  * expu256(x:u256, y:u256) -> z:u256
  *
  * Returns x to the power of y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInExpU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("expu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInExpU256 =>
      (#ValueU256 ((I1 ^Int I2) modInt (2 ^Int 256))) .ValueSequence
      ...
    </k>

  /**
  * gts256(x:s256, y:s256) -> z:bool
  *
  * Returns true if x > y, false otherwise.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInGtS256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("gts256"))

  rule
    <k>
      (#ValueS256 I1) (#ValueS256 I2) .ValueSequence ~> #BuiltInGtS256 =>
      (#ValueBool (I1 >Int I2)) .ValueSequence
      ...
    </k>

  /**
  * gtu256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x > y, false otherwise.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInGtU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("gtu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInGtU256 =>
      (#ValueBool (I1 >Int I2)) .ValueSequence
      ...
    </k>

  /**
  * iszerou256(x:u256) -> z:bool
  *
  * Returns true if x == 0, false otherwise.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInIsZeroU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("iszerou256"))

  rule
    <k>
      (#ValueU256 I) .ValueSequence ~> #BuiltInIsZeroU256 =>
      (#ValueBool (I ==Int 0)) .ValueSequence
      ...
    </k>

  /**
  * lts256(x:s256, y:s256) -> z:bool
  *
  * Returns true if x < y, false otherwise.
  */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInLtS256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("lts256"))

  rule
    <k>
      (#ValueS256 I1) (#ValueS256 I2) .ValueSequence ~> #BuiltInLtS256 =>
      (#ValueBool (I1 <Int I2)) .ValueSequence
      ...
    </k>

  /**
  * ltu256(x:u256, y:u256) -> z:bool
  *
  * Returns true if x < y, false otherwise.
  */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInLtU256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("ltu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInLtU256 =>
      (#ValueBool (I1 <Int I2)) .ValueSequence
      ...
    </k>

  /**
  * mods256(x:s256, y:s256) -> z:s256
  *
  * Returns x % y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInModS256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("mods256"))

  rule
    <k>
      (#ValueS256 I1) (#ValueS256 I2) .ValueSequence ~> #BuiltInModS256 =>
      (#ValueS256 (I1 %Int I2)) .ValueSequence
      ...
    </k>

  /**
  * modu256(x:u256, y:u256) -> z:u256
  *
  * Returns x % y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInModU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("modu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInModU256 =>
      (#ValueU256 (I1 modInt I2)) .ValueSequence
      ...
    </k>

  /**
  * mulmodu256(x:u256, y:u256, m:u256) -> z:u256
  *
  * Returns (x * y) % m, calculated with arbitrary precision arithmetic.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInMulModU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("mulmodu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) (#ValueU256 I3) .ValueSequence ~> #BuiltInMulModU256 =>
      (#ValueU256 ((I1 *Int I2) modInt I3)) .ValueSequence
      ...
    </k>

  /**
  * mulu256(x:u256, y:u256) -> z:u256
  *
  * Returns x * y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInMulU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("mulu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInMulU256 =>
      (#ValueU256 ((I1 *Int I2) modInt (2 ^Int 256))) .ValueSequence
      ...
    </k>

  /**
  * notu256(x:u256) -> z:u256
  *
  * Returns ~x, where every bit of x is negated.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInNotU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("notu256"))

  rule
    <k>
      (#ValueU256 I) .ValueSequence ~> #BuiltInNotU256 =>
      (#ValueU256 (((2 ^Int 256) -Int 1) -Int I)) .ValueSequence
      ...
    </k>

  /**
  * oru256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise or of x and y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInOrU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("oru256"))

  /**
  * sars256(x:s256, y:u256) -> z:u256
  *
  * Returns arithmetic right shift of x by y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInSarS256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("sars256"))

  /**
  * shlu256(x:u256, y:u256) -> z:u256
  *
  * Returns logical left shift of x by y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInShlU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("shlu256"))

  /**
  * shru256(x:u256, y:u256) -> z:u256
  *
  * Returns logical right shift of x by y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInShrU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("shru256"))

  /**
  * signextendu256(i:u256, x:u256) -> z:u256
  *
  * Returns sign extension from (i*8+7)th bit counting from least significant.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInSignExtendU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("signextendu256"))

  /**
  * subu256(x:u256, y:u256) -> z:u256
  *
  * Returns x - y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInSubU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("subu256"))

  rule
    <k>
      (#ValueU256 I1) (#ValueU256 I2) .ValueSequence ~> #BuiltInSubU256 =>
      (#ValueU256 ((I1 -Int I2) modInt (2 ^Int 256))) .ValueSequence
      ...
    </k>

  /**
  * xoru256(x:u256, y:u256) -> z:u256
  *
  * Returns bitwise xor of x and y.
  */

  rule
      <k>
        #Execute AstFunctionCall(I, EL) =>
        #ExecuteFunctionArguments EL ~> #BuiltInXorU256
        ...
      </k>
      requires I ==K AstIdentifier(String2Id("xoru256"))

endmodule

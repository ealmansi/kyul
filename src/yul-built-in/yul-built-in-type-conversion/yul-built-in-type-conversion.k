require "../../yul-configuration/yul-configuration.k"
require "../../yul-execution/yul-execution.k"
require "../../yul-syntax/yul-syntax.k"
require "../../yul-value/yul-value.k"

module YUL-BUILT-IN-TYPE-CONVERSION
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-EXECUTION
  imports YUL-SYNTAX
  imports YUL-VALUE

  syntax KItem ::=
    "#BuiltInBoolToS256" |
    "#BuiltInBoolToU256" |
    "#BuiltInBoolToU32" |
    "#BuiltInBoolToU64" |
    "#BuiltInS256ToBool" |
    "#BuiltInS256ToU256" |
    "#BuiltInS256ToU32" |
    "#BuiltInS256ToU64" |
    "#BuiltInU256ToBool" |
    "#BuiltInU256ToS256" |
    "#BuiltInU256ToU32" |
    "#BuiltInU256ToU64" |
    "#BuiltInU32ToBool" |
    "#BuiltInU32ToS256" |
    "#BuiltInU32ToU256" |
    "#BuiltInU32ToU64" |
    "#BuiltInU64ToBool" |
    "#BuiltInU64ToS256" |
    "#BuiltInU64ToU256" |
    "#BuiltInU64ToU32"

  /**
   * booltos256(x:bool) -> y:s256
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInBoolToS256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("booltos256"))

  rule
    <k>
      (#ValueBool B) .ValueSequence ~> #BuiltInBoolToS256 =>
      (
        #if B
        #then
          (#ValueS256 1) .ValueSequence
        #else
          (#ValueS256 0) .ValueSequence
        #fi
      )
      ...
    </k>

  /**
   * booltou256(x:bool) -> y:u256
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInBoolToU256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("booltou256"))

  rule
    <k>
      (#ValueBool B) .ValueSequence ~> #BuiltInBoolToU256 =>
      (
        #if B
        #then
          (#ValueU256 1) .ValueSequence
        #else
          (#ValueU256 0) .ValueSequence
        #fi
      )
      ...
    </k>

  /**
   * booltou32(x:bool) -> y:u32
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInBoolToU32
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("booltou32"))

  rule
    <k>
      (#ValueBool B) .ValueSequence ~> #BuiltInBoolToU32 =>
      (
        #if B
        #then
          (#ValueU32 1) .ValueSequence
        #else
          (#ValueU32 0) .ValueSequence
        #fi
      )
      ...
    </k>

  /**
   * booltou64(x:bool) -> y:u64
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInBoolToU64
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("booltou64"))

  rule
    <k>
      (#ValueBool B) .ValueSequence ~> #BuiltInBoolToU64 =>
      (
        #if B
        #then
          (#ValueU64 1) .ValueSequence
        #else
          (#ValueU64 0) .ValueSequence
        #fi
      )
      ...
    </k>

  /**
   * s256tobool(x:s256) -> y:bool
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInS256ToBool
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("s256tobool"))

  rule
    <k>
      (#ValueS256 I) .ValueSequence ~> #BuiltInS256ToBool =>
      (#ValueBool (I =/=Int 0)) .ValueSequence
      ...
    </k>

  /**
   * s256tou256(x:s256) -> y:u256
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInS256ToU256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("s256tou256"))

  rule
    <k>
      (#ValueS256 I) .ValueSequence ~> #BuiltInS256ToU256 =>
      (#ValueU256 (I modInt (2 ^Int 256))) .ValueSequence
      ...
    </k>

  /**
   * s256tou32(x:s256) -> y:u32
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInS256ToU32
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("s256tou32"))

  rule
    <k>
      (#ValueS256 I) .ValueSequence ~> #BuiltInS256ToU32 =>
      (#ValueU32 (I modInt (2 ^Int 32))) .ValueSequence
      ...
    </k>

  /**
   * s256tou64(x:s256) -> y:u64
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInS256ToU64
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("s256tou64"))

  rule
    <k>
      (#ValueS256 I) .ValueSequence ~> #BuiltInS256ToU64 =>
      (#ValueU64 (I modInt (2 ^Int 64))) .ValueSequence
      ...
    </k>

  /**
   * u256tobool(x:u256) -> y:bool
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU256ToBool
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u256tobool"))

  rule
    <k>
      (#ValueU256 I) .ValueSequence ~> #BuiltInU256ToBool =>
      (#ValueBool (I =/=Int 0)) .ValueSequence
      ...
    </k>

  /**
   * u256tos256(x:u256) -> y:s256
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU256ToS256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u256tos256"))

  rule
    <k>
      (#ValueU256 I) .ValueSequence ~> #BuiltInU256ToS256 =>
      #if I <Int (2 ^Int 255)
      #then
        (#ValueS256 I) .ValueSequence
      #else
        (#ValueS256 (I -Int (2 ^Int 256))) .ValueSequence
      #fi
      ...
    </k>

  /**
   * u256tou32(x:u256) -> y:u32
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU256ToU32
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u256tou32"))

  rule
    <k>
      (#ValueU256 I) .ValueSequence ~> #BuiltInU256ToU32 =>
      (#ValueU32 (I modInt (2 ^Int 32))) .ValueSequence
      ...
    </k>

  /**
   * u256tou64(x:u256) -> y:u64
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU256ToU64
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u256tou64"))

  rule
    <k>
      (#ValueU256 I) .ValueSequence ~> #BuiltInU256ToU64 =>
      (#ValueU64 (I modInt (2 ^Int 64))) .ValueSequence
      ...
    </k>

  /**
   * u32tobool(x:u32) -> y:bool
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU32ToBool
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u32tobool"))

  rule
    <k>
      (#ValueU32 I) .ValueSequence ~> #BuiltInU32ToBool =>
      (#ValueBool (I =/=Int 0)) .ValueSequence
      ...
    </k>

  /**
   * u32tos256(x:u32) -> y:s256
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU32ToS256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u32tos256"))

  rule
    <k>
      (#ValueU32 I) .ValueSequence ~> #BuiltInU32ToS256 =>
      (#ValueS256 I) .ValueSequence
      ...
    </k>

  /**
   * u32tou256(x:u32) -> y:u256
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU32ToU256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u32tou256"))

  rule
    <k>
      (#ValueU32 I) .ValueSequence ~> #BuiltInU32ToU256 =>
      (#ValueU256 I) .ValueSequence
      ...
    </k>

  /**
   * u32tou64(x:u32) -> y:u64
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU32ToU64
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u32tou64"))

  rule
    <k>
      (#ValueU32 I) .ValueSequence ~> #BuiltInU32ToU64 =>
      (#ValueU64 I) .ValueSequence
      ...
    </k>

  /**
   * u64tobool(x:u64) -> y:bool
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU64ToBool
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u64tobool"))

  rule
    <k>
      (#ValueU64 I) .ValueSequence ~> #BuiltInU64ToBool =>
      (#ValueBool (I =/=Int 0)) .ValueSequence
      ...
    </k>

  /**
   * u64tos256(x:u64) -> y:s256
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU64ToS256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u64tos256"))

  rule
    <k>
      (#ValueU64 I) .ValueSequence ~> #BuiltInU64ToS256 =>
      (#ValueS256 I) .ValueSequence
      ...
    </k>

  /**
   * u64tou256(x:u64) -> y:u256
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU64ToU256
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u64tou256"))

  rule
    <k>
      (#ValueU64 I) .ValueSequence ~> #BuiltInU64ToU256 =>
      (#ValueU256 I) .ValueSequence
      ...
    </k>

  /**
   * u64tou32(x:u64) -> y:u32
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #ExecuteFunctionArguments EL ~> #BuiltInU64ToU32
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("u64tou32"))

  rule
    <k>
      (#ValueU64 I) .ValueSequence ~> #BuiltInU64ToU32 =>
      (#ValueU32 (I modInt (2 ^Int 32))) .ValueSequence
      ...
    </k>

endmodule

require "../../yul-configuration/yul-configuration.k"
require "../../yul-syntax/yul-syntax.k"
require "../../yul-utility/yul-utility.k"
require "../../yul-value/yul-value.k"

module YUL-BUILT-IN-TYPE-CONVERSION
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
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
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInBoolToS256
      ...
    </k>
    requires I ==K String2Id("booltos256")

  rule
    <k>
      .ValueSequence (#ValueBool B:Bool) ~> #BuiltInBoolToS256 =>
      (
        #if B
        #then
          .ValueSequence (#ValueS256 1)
        #else
          .ValueSequence (#ValueS256 0)
        #fi
      )
      ...
    </k>

  /**
   * booltou256(x:bool) -> y:u256
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInBoolToU256
      ...
    </k>
    requires I ==K String2Id("booltou256")

  rule
    <k>
      .ValueSequence (#ValueBool B:Bool) ~> #BuiltInBoolToU256 =>
      (
        #if B
        #then
          .ValueSequence (#ValueU256 1)
        #else
          .ValueSequence (#ValueU256 0)
        #fi
      )
      ...
    </k>

  /**
   * booltou32(x:bool) -> y:u32
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInBoolToU32
      ...
    </k>
    requires I ==K String2Id("booltou32")

  rule
    <k>
      .ValueSequence (#ValueBool B:Bool) ~> #BuiltInBoolToU32 =>
      (
        #if B
        #then
          .ValueSequence (#ValueU32 1)
        #else
          .ValueSequence (#ValueU32 0)
        #fi
      )
      ...
    </k>

  /**
   * booltou64(x:bool) -> y:u64
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInBoolToU64
      ...
    </k>
    requires I ==K String2Id("booltou64")

  rule
    <k>
      .ValueSequence (#ValueBool B:Bool) ~> #BuiltInBoolToU64 =>
      (
        #if B
        #then
          .ValueSequence (#ValueU64 1)
        #else
          .ValueSequence (#ValueU64 0)
        #fi
      )
      ...
    </k>

  /**
   * s256tobool(x:s256) -> y:bool
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInS256ToBool
      ...
    </k>
    requires I ==K String2Id("s256tobool")

  rule
    <k>
      .ValueSequence (#ValueS256 I:Int) ~> #BuiltInS256ToBool =>
      (
        #if I ==Int 0
        #then
          .ValueSequence (#ValueBool false)
        #else
          .ValueSequence (#ValueBool true)
        #fi
      )
      ...
    </k>

  /**
   * s256tou256(x:s256) -> y:u256
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInS256ToU256
      ...
    </k>
    requires I ==K String2Id("s256tou256")

  rule
    <k>
      .ValueSequence (#ValueS256 I:Int) ~> #BuiltInS256ToU256 =>
      .ValueSequence (#ValueU256 (I modInt (2 ^Int 256)))
      ...
    </k>

  /**
   * s256tou32(x:s256) -> y:u32
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInS256ToU32
      ...
    </k>
    requires I ==K String2Id("s256tou32")

  rule
    <k>
      .ValueSequence (#ValueS256 I:Int) ~> #BuiltInS256ToU32 =>
      .ValueSequence (#ValueU32 (I modInt (2 ^Int 32)))
      ...
    </k>

  /**
   * s256tou64(x:s256) -> y:u64
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInS256ToU64
      ...
    </k>
    requires I ==K String2Id("s256tou64")

  rule
    <k>
      .ValueSequence (#ValueS256 I:Int) ~> #BuiltInS256ToU64 =>
      .ValueSequence (#ValueU64 (I modInt (2 ^Int 64)))
      ...
    </k>

  /**
   * u256tobool(x:u256) -> y:bool
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU256ToBool
      ...
    </k>
    requires I ==K String2Id("u256tobool")

  rule
    <k>
      .ValueSequence (#ValueU256 I:Int) ~> #BuiltInU256ToBool =>
      (
        #if I ==Int 0
        #then
          .ValueSequence (#ValueBool false)
        #else
          .ValueSequence (#ValueBool true)
        #fi
      )
      ...
    </k>

  /**
   * u256tos256(x:u256) -> y:s256
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU256ToS256
      ...
    </k>
    requires I ==K String2Id("u256tos256")

  rule
    <k>
      .ValueSequence (#ValueU256 I:Int) ~> #BuiltInU256ToS256 =>
      #if I <Int (2 ^Int 255)
      #then
        .ValueSequence (#ValueS256 I)
      #else
        .ValueSequence (#ValueS256 (I -Int (2 ^Int 256)))
      #fi
      ...
    </k>

  /**
   * u256tou32(x:u256) -> y:u32
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU256ToU32
      ...
    </k>
    requires I ==K String2Id("u256tou32")

  rule
    <k>
      .ValueSequence (#ValueU256 I:Int) ~> #BuiltInU256ToU32 =>
      .ValueSequence (#ValueU32 (I modInt (2 ^Int 32)))
      ...
    </k>

  /**
   * u256tou64(x:u256) -> y:u64
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU256ToU64
      ...
    </k>
    requires I ==K String2Id("u256tou64")

  rule
    <k>
      .ValueSequence (#ValueU256 I:Int) ~> #BuiltInU256ToU64 =>
      .ValueSequence (#ValueU64 (I modInt (2 ^Int 64)))
      ...
    </k>

  /**
   * u32tobool(x:u32) -> y:bool
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU32ToBool
      ...
    </k>
    requires I ==K String2Id("u32tobool")

  rule
    <k>
      .ValueSequence (#ValueU32 I:Int) ~> #BuiltInU32ToBool =>
      (
        #if I ==Int 0
        #then
          .ValueSequence (#ValueBool false)
        #else
          .ValueSequence (#ValueBool true)
        #fi
      )
      ...
    </k>

  /**
   * u32tos256(x:u32) -> y:s256
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU32ToS256
      ...
    </k>
    requires I ==K String2Id("u32tos256")

  rule
    <k>
      .ValueSequence (#ValueU32 I:Int) ~> #BuiltInU32ToS256 =>
      .ValueSequence (#ValueS256 I)
      ...
    </k>

  /**
   * u32tou256(x:u32) -> y:u256
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU32ToU256
      ...
    </k>
    requires I ==K String2Id("u32tou256")

  rule
    <k>
      .ValueSequence (#ValueU32 I:Int) ~> #BuiltInU32ToU256 =>
      .ValueSequence (#ValueU256 I)
      ...
    </k>

  /**
   * u32tou64(x:u32) -> y:u64
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU32ToU64
      ...
    </k>
    requires I ==K String2Id("u32tou64")

  rule
    <k>
      .ValueSequence (#ValueU32 I:Int) ~> #BuiltInU32ToU64 =>
      .ValueSequence (#ValueU64 I)
      ...
    </k>

  /**
   * u64tobool(x:u64) -> y:bool
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU64ToBool
      ...
    </k>
    requires I ==K String2Id("u64tobool")

  rule
    <k>
      .ValueSequence (#ValueU64 I:Int) ~> #BuiltInU64ToBool =>
      (
        #if I ==Int 0
        #then
          .ValueSequence (#ValueBool false)
        #else
          .ValueSequence (#ValueBool true)
        #fi
      )
      ...
    </k>

  /**
   * u64tos256(x:u64) -> y:s256
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU64ToS256
      ...
    </k>
    requires I ==K String2Id("u64tos256")

  rule
    <k>
      .ValueSequence (#ValueU64 I:Int) ~> #BuiltInU64ToS256 =>
      .ValueSequence (#ValueS256 I)
      ...
    </k>

  /**
   * u64tou256(x:u64) -> y:u256
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU64ToU256
      ...
    </k>
    requires I ==K String2Id("u64tou256")

  rule
    <k>
      .ValueSequence (#ValueU64 I:Int) ~> #BuiltInU64ToU256 =>
      .ValueSequence (#ValueU256 I)
      ...
    </k>

  /**
   * u64tou32(x:u64) -> y:u32
   */
  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #EvaluateExpressionsHeat EL ~> #BuiltInU64ToU32
      ...
    </k>
    requires I ==K String2Id("u64tou32")

  rule
    <k>
      .ValueSequence (#ValueU64 I:Int) ~> #BuiltInU64ToU32 =>
      .ValueSequence (#ValueU32 (I modInt (2 ^Int 32)))
      ...
    </k>

endmodule

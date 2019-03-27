requires "../../yul-configuration/yul-configuration.k"
requires "../../yul-semantics/yul-semantics.k"
requires "../../yul-syntax/yul-syntax.k"
requires "../../yul-utility/yul-utility.k"
requires "../../yul-value/yul-value.k"

module YUL-BUILT-IN-TYPE-CONVERSION
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SEMANTICS
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
      `FunctionCall2`(#token("booltos256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInBoolToS256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool false) ~> #BuiltInBoolToS256 =>
      ListItem(#ValueS256 0)
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool true) ~> #BuiltInBoolToS256 =>
      ListItem(#ValueS256 1)
      ...
    </k>

  /**
   * booltou256(x:bool) -> y:u256
   */

  rule
    <k>
      `FunctionCall2`(#token("booltou256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInBoolToU256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool false) ~> #BuiltInBoolToU256 =>
      ListItem(#ValueU256 0)
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool true) ~> #BuiltInBoolToU256 =>
      ListItem(#ValueU256 1)
      ...
    </k>

  /**
   * booltou32(x:bool) -> y:u32
   */

  rule
    <k>
      `FunctionCall2`(#token("booltou32", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInBoolToU32
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool false) ~> #BuiltInBoolToU32 =>
      ListItem(#ValueU32 0)
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool true) ~> #BuiltInBoolToU32 =>
      ListItem(#ValueU32 1)
      ...
    </k>

  /**
   * booltou64(x:bool) -> y:u64
   */

  rule
    <k>
      `FunctionCall2`(#token("booltou64", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInBoolToU64
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool false) ~> #BuiltInBoolToU64 =>
      ListItem(#ValueU64 0)
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool true) ~> #BuiltInBoolToU64 =>
      ListItem(#ValueU64 1)
      ...
    </k>

  /**
   * s256tobool(x:s256) -> y:bool
   */

  rule
    <k>
      `FunctionCall2`(#token("s256tobool", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInS256ToBool
      ...
    </k>

  rule
    <k>
      ListItem(#ValueS256 I:Int) ~> #BuiltInS256ToBool =>
      ListItem(#ValueBool (I =/=Int 0))
      ...
    </k>

  /**
   * s256tou256(x:s256) -> y:u256
   */

  rule
    <k>
      `FunctionCall2`(#token("s256tou256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInS256ToU256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueS256 I:Int) ~> #BuiltInS256ToU256 =>
      ListItem(#ValueU256 (I modInt (2 ^Int 256)))
      ...
    </k>

  /**
   * s256tou32(x:s256) -> y:u32
   */

  rule
    <k>
      `FunctionCall2`(#token("s256tou32", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInS256ToU32
      ...
    </k>

  rule
    <k>
      ListItem(#ValueS256 I:Int) ~> #BuiltInS256ToU32 =>
      ListItem(#ValueU32 (I modInt (2 ^Int 32)))
      ...
    </k>

  /**
   * s256tou64(x:s256) -> y:u64
   */

  rule
    <k>
      `FunctionCall2`(#token("s256tou64", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInS256ToU64
      ...
    </k>

  rule
    <k>
      ListItem(#ValueS256 I:Int) ~> #BuiltInS256ToU64 =>
      ListItem(#ValueU64 (I modInt (2 ^Int 64)))
      ...
    </k>

  /**
   * u256tobool(x:u256) -> y:bool
   */

  rule
    <k>
      `FunctionCall2`(#token("u256tobool", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU256ToBool
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU256 I:Int) ~> #BuiltInU256ToBool =>
      ListItem(#ValueBool (I =/=Int 0))
      ...
    </k>

  /**
   * u256tos256(x:u256) -> y:s256
   */

  rule
    <k>
      `FunctionCall2`(#token("u256tos256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU256ToS256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU256 I:Int) ~> #BuiltInU256ToS256 =>
      #if I <Int (2 ^Int 255)
      #then
        ListItem(#ValueS256 I)
      #else
        ListItem(#ValueS256 (I -Int (2 ^Int 256)))
      #fi
      ...
    </k>

  /**
   * u256tou32(x:u256) -> y:u32
   */

  rule
    <k>
      `FunctionCall2`(#token("u256tou32", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU256ToU32
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU256 I:Int) ~> #BuiltInU256ToU32 =>
      ListItem(#ValueU32 (I modInt (2 ^Int 32)))
      ...
    </k>

  /**
   * u256tou64(x:u256) -> y:u64
   */

  rule
    <k>
      `FunctionCall2`(#token("u256tou64", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU256ToU64
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU256 I:Int) ~> #BuiltInU256ToU64 =>
      ListItem(#ValueU64 (I modInt (2 ^Int 64)))
      ...
    </k>

  /**
   * u32tobool(x:u32) -> y:bool
   */

  rule
    <k>
      `FunctionCall2`(#token("u32tobool", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU32ToBool
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU32 I:Int) ~> #BuiltInU32ToBool =>
      ListItem(#ValueBool (I =/=Int 0))
      ...
    </k>

  /**
   * u32tos256(x:u32) -> y:s256
   */

  rule
    <k>
      `FunctionCall2`(#token("u32tos256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU32ToS256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU32 I:Int) ~> #BuiltInU32ToS256 =>
      ListItem(#ValueS256 I)
      ...
    </k>

  /**
   * u32tou256(x:u32) -> y:u256
   */

  rule
    <k>
      `FunctionCall2`(#token("u32tou256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU32ToU256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU32 I:Int) ~> #BuiltInU32ToU256 =>
      ListItem(#ValueU256 I)
      ...
    </k>

  /**
   * u32tou64(x:u32) -> y:u64
   */

  rule
    <k>
      `FunctionCall2`(#token("u32tou64", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU32ToU64
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU32 I:Int) ~> #BuiltInU32ToU64 =>
      ListItem(#ValueU64 I)
      ...
    </k>

  /**
   * u64tobool(x:u64) -> y:bool
   */

  rule
    <k>
      `FunctionCall2`(#token("u64tobool", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU64ToBool
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU64 I:Int) ~> #BuiltInU64ToBool =>
      ListItem(#ValueBool (I =/=Int 0))
      ...
    </k>

  /**
   * u64tos256(x:u64) -> y:s256
   */

  rule
    <k>
      `FunctionCall2`(#token("u64tos256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU64ToS256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU64 I:Int) ~> #BuiltInU64ToS256 =>
      ListItem(#ValueS256 I)
      ...
    </k>

  /**
   * u64tou256(x:u64) -> y:u256
   */

  rule
    <k>
      `FunctionCall2`(#token("u64tou256", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU64ToU256
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU64 I:Int) ~> #BuiltInU64ToU256 =>
      ListItem(#ValueU256 I)
      ...
    </k>

  /**
   * u64tou32(x:u64) -> y:u32
   */

  rule
    <k>
      `FunctionCall2`(#token("u64tou32", "Id"), EL:ExpressionList) =>
      #FunctionArguments toBuiltInList(EL) ~> #BuiltInU64ToU32
      ...
    </k>

  rule
    <k>
      ListItem(#ValueU64 I:Int) ~> #BuiltInU64ToU32 =>
      ListItem(#ValueU32 (I modInt (2 ^Int 32)))
      ...
    </k>

endmodule

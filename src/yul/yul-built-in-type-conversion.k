requires "./yul-configuration.k"
requires "./yul-evaluation.k"
requires "./yul-syntax.k"
requires "./yul-utility.k"
requires "./yul-value.k"

module YUL-BUILT-IN-TYPE-CONVERSION
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-EVALUATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  /**
   * booltos256(x:bool) -> y:s256
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(booltos256, ValueTuple(1, ListItem(ValueBool(false)))) =>
    makeValueTuple(ValueS256(0))

  rule
    evaluateExpressionFunctionCallBuiltIn(booltos256, ValueTuple(1, ListItem(ValueBool(true)))) =>
    makeValueTuple(ValueS256(1))

  /**
   * booltou256(x:bool) -> y:u256
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(booltou256, ValueTuple(1, ListItem(ValueBool(false)))) =>
    makeValueTuple(ValueU256(0))

  rule
    evaluateExpressionFunctionCallBuiltIn(booltou256, ValueTuple(1, ListItem(ValueBool(true)))) =>
    makeValueTuple(ValueU256(1))

  /**
   * booltou32(x:bool) -> y:u32
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(booltou32, ValueTuple(1, ListItem(ValueBool(false)))) =>
    makeValueTuple(ValueU32(0))

  rule
    evaluateExpressionFunctionCallBuiltIn(booltou32, ValueTuple(1, ListItem(ValueBool(true)))) =>
    makeValueTuple(ValueU32(1))

  /**
   * booltou64(x:bool) -> y:u64
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(booltou64, ValueTuple(1, ListItem(ValueBool(false)))) =>
    makeValueTuple(ValueU64(0))

  rule
    evaluateExpressionFunctionCallBuiltIn(booltou64, ValueTuple(1, ListItem(ValueBool(true)))) =>
    makeValueTuple(ValueU64(1))

  /**
   * s256tobool(x:s256) -> y:bool
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(s256tobool, ValueTuple(1, ListItem(ValueS256(I:Int)))) =>
    makeValueTuple(ValueBool(I =/=Int 0))

  /**
   * s256tou256(x:s256) -> y:u256
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(s256tou256, ValueTuple(1, ListItem(ValueS256(I:Int)))) =>
    makeValueTuple(ValueU256(I modInt (2 ^Int 256)))

  /**
   * s256tou32(x:s256) -> y:u32
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(s256tou32, ValueTuple(1, ListItem(ValueS256(I:Int)))) =>
    makeValueTuple(ValueU32(I modInt (2 ^Int 32)))

  /**
   * s256tou64(x:s256) -> y:u64
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(s256tou64, ValueTuple(1, ListItem(ValueS256(I:Int)))) =>
    makeValueTuple(ValueU64(I modInt (2 ^Int 64)))

  /**
   * u256tobool(x:u256) -> y:bool
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u256tobool, ValueTuple(1, ListItem(ValueU256(I:Int)))) =>
    makeValueTuple(ValueBool(I =/=Int 0))

  /**
   * u256tos256(x:u256) -> y:s256
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u256tos256, ValueTuple(1, ListItem(ValueU256(I:Int)))) =>
    makeValueTuple(ValueS256(I))
    requires I <Int (2 ^Int 255) // >

  rule
    evaluateExpressionFunctionCallBuiltIn(u256tos256, ValueTuple(1, ListItem(ValueU256(I:Int)))) =>
    makeValueTuple(ValueS256(I -Int (2 ^Int 256)))
    requires I >=Int (2 ^Int 255)

  /**
   * u256tou32(x:u256) -> y:u32
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u256tou32, ValueTuple(1, ListItem(ValueU256(I:Int)))) =>
    makeValueTuple(ValueU32(I modInt (2 ^Int 32)))

  /**
   * u256tou64(x:u256) -> y:u64
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u256tou64, ValueTuple(1, ListItem(ValueU256(I:Int)))) =>
    makeValueTuple(ValueU64(I modInt (2 ^Int 64)))

  /**
   * u32tobool(x:u32) -> y:bool
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u32tobool, ValueTuple(1, ListItem(ValueU32(I:Int)))) =>
    makeValueTuple(ValueBool(I =/=Int 0))

  /**
   * u32tos256(x:u32) -> y:s256
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u32tos256, ValueTuple(1, ListItem(ValueU32(I:Int)))) =>
    makeValueTuple(ValueS256(I))

  /**
   * u32tou256(x:u32) -> y:u256
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u32tou256, ValueTuple(1, ListItem(ValueU32(I:Int)))) =>
    makeValueTuple(ValueU256(I))

  /**
   * u32tou64(x:u32) -> y:u64
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u32tou64, ValueTuple(1, ListItem(ValueU32(I:Int)))) =>
    makeValueTuple(ValueU64(I))

  /**
   * u64tobool(x:u64) -> y:bool
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u64tobool, ValueTuple(1, ListItem(ValueU64(I:Int)))) =>
    makeValueTuple(ValueBool(I =/=Int 0))

  /**
   * u64tos256(x:u64) -> y:s256
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u64tos256, ValueTuple(1, ListItem(ValueU64(I:Int)))) =>
    makeValueTuple(ValueS256(I))

  /**
   * u64tou256(x:u64) -> y:u256
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u64tou256, ValueTuple(1, ListItem(ValueU64(I:Int)))) =>
    makeValueTuple(ValueU256(I))

  /**
   * u64tou32(x:u64) -> y:u32
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(u64tou32, ValueTuple(1, ListItem(ValueU64(I:Int)))) =>
    makeValueTuple(ValueU32(I modInt (2 ^Int 32)))

endmodule

requires "./yul-configuration.k"
requires "./yul-syntax.k"

module YUL-VALUE
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX

  syntax Value ::=
    ValueBool |
    ValueU8 |
    ValueU32 |
    ValueU64 |
    ValueU128 |
    ValueU256 |
    ValueS8 |
    ValueS32 |
    ValueS64 |
    ValueS128 |
    ValueS256 |
    ValueTuple

  syntax ValueBool ::=
    ValueBool(Bool)

  syntax ValueU8 ::=
    ValueU8(Int)

  syntax ValueU32 ::=
    ValueU32(Int)

  syntax ValueU64 ::=
    ValueU64(Int)

  syntax ValueU128 ::=
    ValueU128(Int)

  syntax ValueU256 ::=
    ValueU256(Int)

  syntax ValueS8 ::=
    ValueS8(Int)

  syntax ValueS32 ::=
    ValueS32(Int)

  syntax ValueS64 ::=
    ValueS64(Int)

  syntax ValueS128 ::=
    ValueS128(Int)

  syntax ValueS256 ::=
    ValueS256(Int)

  /**
   * ValueTuple
   */

  syntax ValueTuple ::=
    ValueTuple(Int, valueList:List)

  /**
   * makeValueTuple
   */

  syntax ValueTuple ::=
    makeValueTuple() [function] |
    makeValueTuple(Value) [function] |
    makeValueTuple(Value, Value) [function] |
    makeValueTuple(Value, Value, Value) [function]

  rule
    makeValueTuple() =>
    ValueTuple(0, .List)

  rule
    makeValueTuple(V1:Value) =>
    ValueTuple(1, ListItem(V1))

  rule
    makeValueTuple(V1:Value, V2:Value) =>
    ValueTuple(2, ListItem(V1) ListItem(V2))

  rule
    makeValueTuple(V1:Value, V2:Value, V3:Value) =>
    ValueTuple(3, ListItem(V1) ListItem(V2) ListItem(V3))

  /**
   * mergeValueTuples
   */

  syntax ValueTuple ::=
    mergeValueTuples(ValueTuple, ValueTuple) [function]

  rule
    mergeValueTuples(ValueTuple(I1:Int, VL1:List), ValueTuple(I2:Int, VL2:List)) =>
    ValueTuple(I1 +Int I2, VL1 VL2)

  /**
   * getDefaultValue
   */

  syntax Value ::=
    getDefaultValue(TypeName) [function]

  rule
    getDefaultValue(bool) =>
    ValueBool(false)

  rule
    getDefaultValue(u8) =>
    ValueU8(0)

  rule
    getDefaultValue(u32) =>
    ValueU32(0)

  rule
    getDefaultValue(u64) =>
    ValueU64(0)

  rule
    getDefaultValue(u128) =>
    ValueU128(0)

  rule
    getDefaultValue(u256) =>
    ValueU256(0)

  rule
    getDefaultValue(s8) =>
    ValueS8(0)

  rule
    getDefaultValue(s32) =>
    ValueS32(0)

  rule
    getDefaultValue(s64) =>
    ValueS64(0)

  rule
    getDefaultValue(s128) =>
    ValueS128(0)

  rule
    getDefaultValue(s256) =>
    ValueS256(0)

endmodule

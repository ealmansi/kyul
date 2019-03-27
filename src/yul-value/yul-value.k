requires "../yul-syntax/yul-syntax.k"
requires "../yul-configuration/yul-configuration.k"

module YUL-VALUE
  imports DOMAINS
  imports YUL-SYNTAX
  imports YUL-CONFIGURATION

  syntax Value ::=
    ValueBool(Bool) |
    ValueU8(Int) |
    ValueU32(Int) |
    ValueU64(Int) |
    ValueU128(Int) |
    ValueU256(Int) |
    ValueS8(Int) |
    ValueS32(Int) |
    ValueS64(Int) |
    ValueS128(Int) |
    ValueS256(Int) |
    ValueTuple

  /**
   * ValueTuple
   */

  syntax ValueTuple ::=
    ValueTuple(Int, List)

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

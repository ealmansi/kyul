require "../yul-syntax/yul-syntax.k"
require "../yul-configuration/yul-configuration.k"

module YUL-VALUE
  imports DOMAINS
  imports YUL-SYNTAX
  imports YUL-CONFIGURATION

  syntax Value ::=
    "#ValueBool" Bool |
    "#ValueU8" Int |
    "#ValueU32" Int |
    "#ValueU64" Int |
    "#ValueU128" Int |
    "#ValueU256" Int |
    "#ValueS8" Int |
    "#ValueS32" Int |
    "#ValueS64" Int |
    "#ValueS128" Int |
    "#ValueS256" Int

  syntax ValueSequence ::=
    ".ValueSequence" |
    ValueSequence Value

  syntax KItem ::=
    "#DefaultValue" TypeName |
    ValueSequence

  rule
    <k>
      #DefaultValue bool =>
      #ValueBool false
      ...
    </k>

  rule
    <k>
      #DefaultValue u8 =>
      #ValueU8 0
      ...
    </k>

  rule
    <k>
      #DefaultValue u32 =>
      #ValueU32 0
      ...
    </k>

  rule
    <k>
      #DefaultValue u64 =>
      #ValueU64 0
      ...
    </k>

  rule
    <k>
      #DefaultValue u128 =>
      #ValueU128 0
      ...
    </k>

  rule
    <k>
      #DefaultValue u256 =>
      #ValueU256 0
      ...
    </k>

  rule
    <k>
      #DefaultValue s8 =>
      #ValueS8 0
      ...
    </k>

  rule
    <k>
      #DefaultValue s32 =>
      #ValueS32 0
      ...
    </k>

  rule
    <k>
      #DefaultValue s64 =>
      #ValueS64 0
      ...
    </k>

  rule
    <k>
      #DefaultValue s128 =>
      #ValueS128 0
      ...
    </k>

  rule
    <k>
      #DefaultValue s256 =>
      #ValueS256 0
      ...
    </k>

endmodule

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

  syntax KItem ::=
    "#DefaultValue" TypeName

  rule
    <k>
      #DefaultValue bool =>
      ListItem(#ValueBool false)
      ...
    </k>

  rule
    <k>
      #DefaultValue u8 =>
      ListItem(#ValueU8 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue u32 =>
      ListItem(#ValueU32 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue u64 =>
      ListItem(#ValueU64 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue u128 =>
      ListItem(#ValueU128 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue u256 =>
      ListItem(#ValueU256 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue s8 =>
      ListItem(#ValueS8 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue s32 =>
      ListItem(#ValueS32 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue s64 =>
      ListItem(#ValueS64 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue s128 =>
      ListItem(#ValueS128 0)
      ...
    </k>

  rule
    <k>
      #DefaultValue s256 =>
      ListItem(#ValueS256 0)
      ...
    </k>

endmodule

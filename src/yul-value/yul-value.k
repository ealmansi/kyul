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
    Value ValueSequence

  syntax KItem ::=
    "#DefaultValue" AstTypeName |
    ValueSequence

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( bool ) )) =>
      #ValueBool false
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( u8 ) )) =>
      #ValueU8 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( u32 ) )) =>
      #ValueU32 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( u64 ) )) =>
      #ValueU64 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( u128 ) )) =>
      #ValueU128 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( u256 ) )) =>
      #ValueU256 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( s8 ) )) =>
      #ValueS8 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( s32 ) )) =>
      #ValueS32 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( s64 ) )) =>
      #ValueS64 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( s128 ) )) =>
      #ValueS128 0
      ...
    </k>

  rule
    <k>
      #DefaultValue (AstTypeName ( AstTypeNameBuiltIn ( s256 ) )) =>
      #ValueS256 0
      ...
    </k>

endmodule

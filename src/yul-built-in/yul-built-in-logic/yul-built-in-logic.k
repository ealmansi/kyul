require "../../yul-configuration/yul-configuration.k"
require "../../yul-syntax/yul-syntax.k"
require "../../yul-utility/yul-utility.k"
require "../../yul-value/yul-value.k"

module YUL-BUILT-IN-LOGIC
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  syntax KItem ::=
    "#BuiltInAnd" ExpressionList |
    "#BuiltInAndCool1" Expression |
    "#BuiltInAndCool2" |
    "#BuiltInNot" ExpressionList |
    "#BuiltInNotCool" |
    "#BuiltInOr" ExpressionList |
    "#BuiltInOrCool1" Expression |
    "#BuiltInOrCool2" |
    "#BuiltInXor" ExpressionList |
    "#BuiltInXorCool1" Expression |
    "#BuiltInXorCool2"

  /**
   * and(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #BuiltInAnd EL
      ...
    </k>
    requires I ==K String2Id("and")

  rule
    <k>
      #BuiltInAnd (E1 , E2):ExpressionList =>
      E1 ~> #BuiltInAndCool1 E2
      ...
    </k>

  rule
    <k>
      .ValueSequence (#ValueBool true) ~> #BuiltInAndCool1 E:Expression =>
      E ~> #BuiltInAndCool2
      ...
    </k>

  rule
    <k>
      .ValueSequence (#ValueBool B) ~> #BuiltInAndCool2 =>
      .ValueSequence (#ValueBool B)
      ...
    </k>

  rule
    <k>
      .ValueSequence (#ValueBool false) ~> #BuiltInAndCool1 E:Expression =>
      .ValueSequence (#ValueBool false)
      ...
    </k>

  /**
   * not(x:bool) -> z:bool
   */

  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #BuiltInNot EL
      ...
    </k>
    requires I ==K String2Id("not")

  rule
    <k>
      #BuiltInNot E:Expression =>
      E ~> #BuiltInNotCool
      ...
    </k>

  rule
    <k>
      .ValueSequence (#ValueBool B) ~> #BuiltInNotCool =>
      .ValueSequence (#ValueBool (notBool B))
      ...
    </k>

  /**
   * or(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #BuiltInOr EL
      ...
    </k>
    requires I ==K String2Id("or")

  rule
    <k>
      #BuiltInOr (E1 , E2):ExpressionList =>
      E1 ~> #BuiltInOrCool1 E2
      ...
    </k>

  rule
    <k>
      .ValueSequence (#ValueBool true) ~> #BuiltInOrCool1 E:Expression =>
      .ValueSequence (#ValueBool true)
      ...
    </k>

  rule
    <k>
      .ValueSequence (#ValueBool false) ~> #BuiltInOrCool1 E:Expression =>
      E ~> #BuiltInOrCool2
      ...
    </k>

  rule
    <k>
      .ValueSequence (#ValueBool B) ~> #BuiltInOrCool2 =>
      .ValueSequence (#ValueBool B)
      ...
    </k>

  /**
   * xor(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #BuiltInXor EL
      ...
    </k>
    requires I ==K String2Id("xor")

  rule
    <k>
      #BuiltInXor (E1 , E2):ExpressionList =>
      E1 ~> #BuiltInXorCool1 E2
      ...
    </k>

  rule
    <k>
      VS:ValueSequence ~> #BuiltInXorCool1 E:Expression =>
      E ~> VS ~> #BuiltInXorCool2
      ...
    </k>

  rule
    <k>
      .ValueSequence (#ValueBool B1) ~> .ValueSequence (#ValueBool B2) ~> #BuiltInXorCool2 =>
      .ValueSequence (#ValueBool (B1 xorBool B2))
      ...
    </k>

endmodule

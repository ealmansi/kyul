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
    "#BuiltInAnd" AstExpressionList |
    "#BuiltInAndCool1" AstExpression |
    "#BuiltInAndCool2" |
    "#BuiltInNot" AstExpressionList |
    "#BuiltInNotCool" |
    "#BuiltInOr" AstExpressionList |
    "#BuiltInOrCool1" AstExpression |
    "#BuiltInOrCool2" |
    "#BuiltInXor" AstExpressionList |
    "#BuiltInXorCool1" AstExpression |
    "#BuiltInXorCool2"

  /**
   * and(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #BuiltInAnd EL
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("and"))

  rule
    <k>
      #BuiltInAnd (ListItem(E1) ListItem(E2) .List) =>
      #Execute E1 ~> #BuiltInAndCool1 E2
      ...
    </k>

  rule
    <k>
      (#ValueBool true) .ValueSequence ~> #BuiltInAndCool1 E =>
      #Execute E ~> #BuiltInAndCool2
      ...
    </k>

  rule
    <k>
      (#ValueBool B) .ValueSequence ~> #BuiltInAndCool2 =>
      (#ValueBool B) .ValueSequence
      ...
    </k>

  rule
    <k>
      (#ValueBool false) .ValueSequence ~> #BuiltInAndCool1 E =>
      (#ValueBool false) .ValueSequence
      ...
    </k>

  /**
   * not(x:bool) -> z:bool
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #BuiltInNot EL
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("not"))

  rule
    <k>
      #BuiltInNot (ListItem(E) .List) =>
      #Execute E ~> #BuiltInNotCool
      ...
    </k>

  rule
    <k>
      (#ValueBool B) .ValueSequence ~> #BuiltInNotCool =>
      (#ValueBool (notBool B)) .ValueSequence
      ...
    </k>

  /**
   * or(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #BuiltInOr EL
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("or"))

  rule
    <k>
      #BuiltInOr (ListItem(E1) ListItem(E2) .List) =>
      #Execute E1 ~> #BuiltInOrCool1 E2
      ...
    </k>

  rule
    <k>
      (#ValueBool true) .ValueSequence ~> #BuiltInOrCool1 E =>
      (#ValueBool true) .ValueSequence
      ...
    </k>

  rule
    <k>
      (#ValueBool false) .ValueSequence ~> #BuiltInOrCool1 E =>
      #Execute E ~> #BuiltInOrCool2
      ...
    </k>

  rule
    <k>
      (#ValueBool B) .ValueSequence ~> #BuiltInOrCool2 =>
      (#ValueBool B) .ValueSequence
      ...
    </k>

  /**
   * xor(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      #Execute AstFunctionCall(I, EL) =>
      #BuiltInXor EL
      ...
    </k>
    requires I ==K AstIdentifier(String2Id("xor"))

  rule
    <k>
      #BuiltInXor (ListItem(E1) ListItem(E2) .List) =>
      #Execute E1 ~> #BuiltInXorCool1 E2
      ...
    </k>

  rule
    <k>
      VS:ValueSequence ~> #BuiltInXorCool1 E =>
      #Execute E ~> VS ~> #BuiltInXorCool2
      ...
    </k>

  rule
    <k>
      (#ValueBool B1) .ValueSequence ~> (#ValueBool B2) .ValueSequence ~> #BuiltInXorCool2 =>
      (#ValueBool (B1 xorBool B2)) .ValueSequence
      ...
    </k>

endmodule

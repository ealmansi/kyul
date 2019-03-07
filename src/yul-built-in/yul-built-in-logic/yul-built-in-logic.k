require "../../yul-configuration/yul-configuration.k"
require "../../yul-semantics/yul-semantics.k"
require "../../yul-syntax/yul-syntax.k"
require "../../yul-utility/yul-utility.k"
require "../../yul-value/yul-value.k"

module YUL-BUILT-IN-LOGIC
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SEMANTICS
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  syntax KItem ::=
    "#BuiltInAnd" List |
    "#BuiltInAndCool1" Expression |
    "#BuiltInAndCool2" |
    "#BuiltInNot" List |
    "#BuiltInNotCool" |
    "#BuiltInOr" List |
    "#BuiltInOrCool1" Expression |
    "#BuiltInOrCool2" |
    "#BuiltInXor" List |
    "#BuiltInXorCool1" Expression |
    "#BuiltInXorCool2"

  /**
   * and(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      `FunctionCall2`(#token("and", "Id"), EL:ExpressionList) =>
      #BuiltInAnd toBuiltInList(EL)
      ...
    </k>

  rule
    <k>
      #BuiltInAnd (ListItem(E1) ListItem(E2) .List) =>
      E1 ~> #BuiltInAndCool1 E2
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool true) ~> #BuiltInAndCool1 E =>
      E ~> #BuiltInAndCool2
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool B) ~> #BuiltInAndCool2 =>
      ListItem(#ValueBool B)
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool false) ~> #BuiltInAndCool1 E =>
      ListItem(#ValueBool false)
      ...
    </k>

  /**
   * not(x:bool) -> z:bool
   */

  rule
    <k>
      `FunctionCall2`(#token("not", "Id"), EL:ExpressionList) =>
      #BuiltInNot toBuiltInList(EL)
      ...
    </k>

  rule
    <k>
      #BuiltInNot (ListItem(E) .List) =>
      E ~> #BuiltInNotCool
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool B) ~> #BuiltInNotCool =>
      ListItem(#ValueBool (notBool B))
      ...
    </k>

  /**
   * or(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      `FunctionCall2`(#token("or", "Id"), EL:ExpressionList) =>
      #BuiltInOr toBuiltInList(EL)
      ...
    </k>

  rule
    <k>
      #BuiltInOr (ListItem(E1) ListItem(E2) .List) =>
      E1 ~> #BuiltInOrCool1 E2
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool true) ~> #BuiltInOrCool1 E =>
      ListItem(#ValueBool true)
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool false) ~> #BuiltInOrCool1 E =>
      E ~> #BuiltInOrCool2
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool B) ~> #BuiltInOrCool2 =>
      ListItem(#ValueBool B)
      ...
    </k>

  /**
   * xor(x:bool, y:bool) -> z:bool
   */

  rule
    <k>
      `FunctionCall2`(#token("xor", "Id"), EL:ExpressionList) =>
      #BuiltInXor toBuiltInList(EL)
      ...
    </k>

  rule
    <k>
      #BuiltInXor (ListItem(E1) ListItem(E2) .List) =>
      E1 ~> #BuiltInXorCool1 E2
      ...
    </k>

  rule
    <k>
      VL:List ~> #BuiltInXorCool1 E =>
      E ~> VL ~> #BuiltInXorCool2
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool B1) ~> ListItem(#ValueBool B2) ~> #BuiltInXorCool2 =>
      ListItem(#ValueBool (B1 xorBool B2))
      ...
    </k>

endmodule

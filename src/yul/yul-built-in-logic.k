requires "./yul-configuration.k"
requires "./yul-evaluation.k"
requires "./yul-syntax.k"
requires "./yul-utility.k"
requires "./yul-value.k"

module YUL-BUILT-IN-LOGIC
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-EVALUATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  /**
   * and(x:bool, y:bool) -> z:bool
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      and,
      ValueTuple(2, ListItem(ValueBool(B1:Bool)) ListItem(ValueBool(B2:Bool)))
    ) =>
    makeValueTuple(ValueBool(B1 andBool B2))

  /**
   * not(x:bool) -> z:bool
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(not, ValueTuple(1, ListItem(ValueBool(B:Bool)))) =>
    makeValueTuple(ValueBool(notBool B))

  /**
   * or(x:bool, y:bool) -> z:bool
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      or,
      ValueTuple(2, ListItem(ValueBool(B1:Bool)) ListItem(ValueBool(B2:Bool)))
    ) =>
    makeValueTuple(ValueBool(B1 orBool B2))

  /**
   * xor(x:bool, y:bool) -> z:bool
   */

  rule
    evaluateExpressionFunctionCallBuiltIn(
      xor,
      ValueTuple(2, ListItem(ValueBool(B1:Bool)) ListItem(ValueBool(B2:Bool)))
    ) =>
    makeValueTuple(ValueBool(B1 xorBool B2))

endmodule

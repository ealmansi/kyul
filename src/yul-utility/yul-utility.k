require "../yul-ast/yul-ast.k"
require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"
require "../yul-value/yul-value.k"

module YUL-UTILITY
  imports DOMAINS
  imports YUL-AST
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-VALUE

  syntax KItem ::=
    "#ExecuteFunctionArguments" AstExpressionList |
    "#ExecuteFunctionArgumentsRecursive" AstExpressionList ValueSequence |
    "#ExecuteFunctionArgumentsRecursiveCool" AstExpressionList ValueSequence |
    "#IsFunctionDefinition" AstStatement

  /**
   * ExecuteFunctionArguments
   */

  rule
    <k>
      #ExecuteFunctionArguments EL =>
      #ExecuteFunctionArgumentsRecursive reverseList(EL) .ValueSequence
      ...
    </k>

  rule
    <k>
      #ExecuteFunctionArgumentsRecursive .List VS =>
      VS
      ...
    </k>

  rule
    <k>
      #ExecuteFunctionArgumentsRecursive (ListItem(E) EL) VS =>
      #Execute E ~> #ExecuteFunctionArgumentsRecursiveCool EL VS
      ...
    </k>

  rule
    <k>
      V .ValueSequence ~> #ExecuteFunctionArgumentsRecursiveCool EL VS =>
      #ExecuteFunctionArgumentsRecursive EL (V VS)
      ...
    </k>

  /**
   * reverseList
   */

  syntax List ::=
    reverseList(List) [function]

  rule reverseList(.List) =>
    .List

  rule reverseList(ListItem(H) L) =>
    reverseList(L) ListItem(H)

  /**
   * reverseValueSequence
   */

  syntax ValueSequence ::=
    reverseValueSequence(ValueSequence) [function]

  rule reverseValueSequence(.ValueSequence) =>
    .ValueSequence

  rule reverseValueSequence(V VS) =>
    appendValueToSequence(reverseValueSequence(VS), V)

  /**
   * appendValueToSequence
   */

  syntax ValueSequence ::=
    appendValueToSequence(ValueSequence, Value) [function]

  rule appendValueToSequence(.ValueSequence, V) =>
    V .ValueSequence

  rule appendValueToSequence(V1 VS, V2) =>
    V1 appendValueToSequence(VS, V2)

  /**
   * IsFunctionDefinition
   */

  rule
    <k>
      #IsFunctionDefinition AstStatement(A:AstAssignment) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(B:AstBlock) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(B:AstBreak) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(C:AstContinue) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(D:AstDebug) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(E:AstExpression) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(F:AstFor) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(FD:AstFunctionDefinition) =>
      true
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(I:AstIf) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(S:AstSwitch) =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition AstStatement(VD:AstVariableDeclaration) =>
      false
      ...
    </k>

endmodule

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

  syntax KItem ::=
    "#IsFunctionDefinition" AstStatement

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

endmodule

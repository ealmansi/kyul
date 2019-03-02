require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"
require "../yul-value/yul-value.k"

module YUL-UTILITY
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-VALUE

  syntax KItem ::=
    "#EvaluateExpressionsCool" ExpressionList |
    "#EvaluateExpressionsHeat" ExpressionList |
    "#EvaluateExpressionsMerge" Value |
    "#IsFunctionDefinition" Statement

  /**
   * EvaluateExpressions
   */

  rule
    <k>
      #EvaluateExpressionsHeat E:Expression =>
      E
      ...
    </k>

  rule
    <k>
      #EvaluateExpressionsHeat (EL , E):ExpressionList =>
      E ~> #EvaluateExpressionsCool EL
      ...
    </k>

  rule
    <k>
      .ValueSequence V:Value ~> #EvaluateExpressionsCool EL:ExpressionList =>
      #EvaluateExpressionsHeat EL ~> #EvaluateExpressionsMerge V
      ...
    </k>

  rule
    <k>
      VS:ValueSequence ~> #EvaluateExpressionsMerge V:Value =>
      VS V
      ...
    </k>

  /**
   * IsFunctionDefinition
   */

  rule
    <k>
      #IsFunctionDefinition A:Assignment =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition B:Block =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition B:Break =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition C:Continue =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition D:Debug =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition E:Expression =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition F:For =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition FD:FunctionDefinition =>
      true
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition I:If =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition S:Switch =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition VD:VariableDeclaration =>
      false
      ...
    </k>

endmodule

require "../../src/yul/yul.k"

module SPEC
  imports DOMAINS
  imports YUL

  rule
    <T>
      <k>
        evaluateProgram(
          AstBlock ( ListItem ( AstVariableDeclaration2 ( ListItem ( AstTypedIdentifier ( #token("b", "Id") , u256 ) ) , AstTypedLiteral ( B:Int , u256 ) ) )
          ListItem ( AstVariableDeclaration2 ( ListItem ( AstTypedIdentifier ( #token("e", "Id") , u256 ) ) , AstTypedLiteral ( 2 , u256 ) ) )
          ListItem ( AstVariableDeclaration2 ( ListItem ( AstTypedIdentifier ( #token("p", "Id") , u256 ) ) , #token("b", "Id") ) )
          ListItem ( AstVariableDeclaration2 ( ListItem ( AstTypedIdentifier ( #token("r", "Id") , u256 ) ) , AstTypedLiteral ( 1 , u256 ) ) )
          ListItem ( AstFor ( AstBlock ( .List ) , AstFunctionCall ( ltu256 , ListItem ( AstTypedLiteral ( 0 , u256 ) )
          ListItem ( #token("e", "Id") ) ) , AstBlock ( .List ) , AstBlock ( ListItem ( AstIf ( AstFunctionCall ( equ256 , ListItem ( AstFunctionCall ( modu256 , ListItem ( #token("e", "Id") )
          ListItem ( AstTypedLiteral ( 2 , u256 ) ) ) )
          ListItem ( AstTypedLiteral ( 1 , u256 ) ) ) , AstBlock ( ListItem ( AstAssignment ( ListItem ( #token("r", "Id") ) , AstFunctionCall ( mulu256 , ListItem ( #token("r", "Id") )
          ListItem ( #token("p", "Id") ) ) ) ) ) ) )
          ListItem ( AstAssignment ( ListItem ( #token("e", "Id") ) , AstFunctionCall ( divu256 , ListItem ( #token("e", "Id") )
          ListItem ( AstTypedLiteral ( 2 , u256 ) ) ) ) )
          ListItem ( AstAssignment ( ListItem ( #token("p", "Id") ) , AstFunctionCall ( mulu256 , ListItem ( #token("p", "Id") )
          ListItem ( #token("p", "Id") ) ) ) ) ) ) )
          ListItem ( AstDebug ( #token("r", "Id") ) ) )
        )
        =>
        .
      </k>
      <cTypeCheck>
        <cTypeCheckVariableEnvironmentStack> .List => .List </cTypeCheckVariableEnvironmentStack>
        <cTypeCheckFunctionEnvironmentStack> .List => .List </cTypeCheckFunctionEnvironmentStack>
      </cTypeCheck>
      <cEvaluation>
        <cEvaluationVariableEnvironmentStack> .List => .List </cEvaluationVariableEnvironmentStack>
        <cEvaluationFunctionEnvironmentStack> .List => .List </cEvaluationFunctionEnvironmentStack>
        <cEvaluationMode> EvaluationModeRegular() => EvaluationModeRegular() </cEvaluationMode>
      </cEvaluation>
      <cDebug>
        .List =>
        ListItem ( ListItem ( #token("r", "Id") )
        ListItem ( ValueTuple ( 1 , ListItem ( ValueU256 ( B *Int B ) ) ) ) )
      </cDebug>
    </T>
    requires 0 <=Int B andBool B <Int (2 ^Int 128) // >

endmodule

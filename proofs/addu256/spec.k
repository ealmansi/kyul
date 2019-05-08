require "../../src/yul/yul.k"

module SPEC
  imports DOMAINS
  imports YUL

  rule
    <T>
      <k>
        evaluateProgram(
          toAstProgram(
            `Block2`(
              `StatementSequence`(
                `StatementSequence`(
                  `VariableDeclaration2`(
                    `TypedIdentifier`(
                      #token(
                        "x",
                        "Id"
                      ),
                      #token(
                        "u256",
                        "TypeNameBuiltIn"
                      )
                    ),
                    `TypedLiteral`(
                      X:Int,
                      #token(
                        "u256",
                        "TypeNameBuiltIn"
                      )
                    )
                  ),
                  `VariableDeclaration2`(
                    `TypedIdentifier`(
                      #token(
                        "y",
                        "Id"
                      ),
                      #token(
                        "u256",
                        "TypeNameBuiltIn"
                      )
                    ),
                    `FunctionCall2`(
                      #token(
                        "addu256",
                        "IdentifierBuiltInFunctionArithmetic"
                      ),
                      `ExpressionList`(
                        #token(
                          "x",
                          "Id"
                        ),
                        #token(
                          "x",
                          "Id"
                        )
                      )
                    )
                  )
                ),
                `Debug`(
                  #token(
                    "y",
                    "Id"
                  )
                )
              )
            )
          )
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
        ListItem ( ListItem ( #token("y", "Id") )
        ListItem ( ValueTuple ( 1 , ListItem ( ValueU256 ( X +Int X ) ) ) ) )
      </cDebug>
    </T>
    requires (0 <=Int X) andBool (X <Int (2 ^Int 255)) // >

endmodule

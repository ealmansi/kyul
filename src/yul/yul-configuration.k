requires "./yul-syntax.k"

module YUL-CONFIGURATION
  imports DOMAINS
  imports YUL-SYNTAX

  syntax EvaluationMode ::=
    EvaluationModeBreak() |
    EvaluationModeContinue() |
    EvaluationModeRegular()

  configuration
    <T>
      <k> $PGM:Program </k>
      <cTypeCheck>
        <cTypeCheckVariableEnvironmentStack> .List </cTypeCheckVariableEnvironmentStack>
        <cTypeCheckFunctionEnvironmentStack> .List </cTypeCheckFunctionEnvironmentStack>
      </cTypeCheck>
      <cEvaluation>
        <cEvaluationVariableEnvironmentStack> .List </cEvaluationVariableEnvironmentStack>
        <cEvaluationFunctionEnvironmentStack> .List </cEvaluationFunctionEnvironmentStack>
        <cEvaluationMode> EvaluationModeRegular() </cEvaluationMode>
      </cEvaluation>
      // <cStdout stream="stdout"> .List </cStdout>
      <cDebug> .List </cDebug>
    </T>

endmodule

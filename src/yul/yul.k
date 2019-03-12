requires "./yul-ast.k"
requires "./yul-built-in.k"
requires "./yul-configuration.k"
requires "./yul-evaluation.k"
requires "./yul-syntax.k"
requires "./yul-type-check.k"

module YUL
  imports DOMAINS
  imports YUL-AST
  imports YUL-BUILT-IN
  imports YUL-CONFIGURATION
  imports YUL-EVALUATION
  imports YUL-SYNTAX
  imports YUL-TYPE-CHECK

  rule
    P:Program =>
    (
      typecheckProgram(toAstProgram(P)) ~>
      evaluateProgram(toAstProgram(P))
    )

endmodule

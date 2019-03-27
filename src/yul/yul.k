requires "../yul-ast/yul-ast.k"
requires "../yul-configuration/yul-configuration.k"
requires "../yul-semantics/yul-semantics.k"
requires "../yul-syntax/yul-syntax.k"
requires "../yul-type-check/yul-type-check.k"

module YUL
  imports DOMAINS
  imports YUL-AST
  imports YUL-CONFIGURATION
  imports YUL-SEMANTICS
  imports YUL-SYNTAX
  imports YUL-TYPE-CHECK

  rule
    P:Program =>
    (
      typecheckProgram(toAstProgram(P)) ~>
      evaluateProgram(toAstProgram(P))
    )

endmodule

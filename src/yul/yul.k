requires "../yul-ast/yul-ast.k"
requires "../yul-configuration/yul-configuration.k"
requires "../yul-syntax/yul-syntax.k"
requires "../yul-type-check/yul-type-check.k"

module YUL
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-AST
  imports YUL-TYPE-CHECK

  rule
    P:Program =>
    typecheckProgram(toAstProgram(P))

endmodule

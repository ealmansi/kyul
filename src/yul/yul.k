// require "../yul-built-in/yul-built-in.k"
require "../yul-configuration/yul-configuration.k"
// require "../yul-semantics/yul-semantics.k"
require "../yul-syntax/yul-syntax.k"
require "../yul-ast/yul-ast.k"
require "../yul-type-check/yul-type-check.k"

module YUL
  imports DOMAINS
  // imports YUL-BUILT-IN
  imports YUL-CONFIGURATION
  // imports YUL-SEMANTICS
  imports YUL-SYNTAX
  imports YUL-AST
  imports YUL-TYPE-CHECK

  rule P:Program => typecheckProgram(toAstProgram(P), getEmptyTypeCheckEnvironment())

endmodule

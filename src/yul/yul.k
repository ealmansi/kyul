require "../yul-ast/yul-ast.k"
require "../yul-built-in/yul-built-in.k"
require "../yul-configuration/yul-configuration.k"
require "../yul-execution/yul-execution.k"
require "../yul-syntax/yul-syntax.k"

module YUL
  imports DOMAINS
  imports YUL-AST
  imports YUL-BUILT-IN
  imports YUL-CONFIGURATION
  imports YUL-EXECUTION
  imports YUL-SYNTAX

  rule
    <k>
      P:Program =>
      #Execute toAstProgram(P)
    </k>

endmodule

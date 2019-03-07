require "../../src/yul/yul.k"

module SPEC
  imports DOMAINS
  imports YUL

  rule
    <T>
      <k>
        `Block2`(`StatementSequence`(`StatementSequence`(`VariableDeclaration2`(`TypedIdentifier`(#token("x","Id"),#token("u256","TypeNameBuiltIn")),`TypedLiteral`(X:Int,#token("u256","TypeNameBuiltIn"))),`VariableDeclaration2`(`TypedIdentifier`(#token("y","Id"),#token("u256","TypeNameBuiltIn")),`FunctionCall2`(#token("addu256","Id"),`ExpressionList`(#token("x","Id"),#token("x","Id"))))),`Debug`(#token("y","Id"))))
        =>
        .
      </k>
      <cSymbolTableStack>
        <cSymbolTableStackSize> 0 => 0 </cSymbolTableStackSize>
      </cSymbolTableStack>
      <cEnvironmentStack>
        <cEnvironmentStackSize> 0 => 0 </cEnvironmentStackSize>
      </cEnvironmentStack>
      <cEnvironmentStackCopies> .List => .List </cEnvironmentStackCopies>
      <cDebug>
        .List =>
        ListItem ( #ValueU256 (X +Int X) )
      </cDebug>
    </T>
    requires (0 <=Int X) andBool (X <Int (2 ^Int 255)) // >

endmodule

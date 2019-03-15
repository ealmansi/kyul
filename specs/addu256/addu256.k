require "../../src/yul/yul.k"

module SPEC
  imports DOMAINS
  imports YUL

  rule
    <T>
      <k>
        #AstBlock ListItem (
          #AstVariableDeclaration2 ListItem (
            #AstTypedIdentifier #token(
              "x",
              "Id"
            ) #token(
              "u256",
              "TypeNameBuiltIn"
            ) 
          ) #AstTypedLiteral 3 #token(
            "u256",
            "TypeNameBuiltIn"
          ) 
        ) ListItem (
          #AstVariableDeclaration2 ListItem (
            #AstTypedIdentifier #token(
              "y",
              "Id"
            ) #token(
              "u256",
              "TypeNameBuiltIn"
            ) 
          ) #AstFunctionCall #token(
              "addu256",
              "Id"
            ) ListItem (
            #token(
              "x",
              "Id"
            ) 
          ) ListItem (
            #token(
              "x",
              "Id"
            ) 
          ) 
        ) ListItem (
          #AstDebug #token(
            "y",
            "Id"
          ) 
        )
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
      <cStdout> .List </cStdout>
      <cDebug>
        .List =>
        ListItem ( #ValueU256 (X +Int X) )
      </cDebug>
    </T>
    requires (0 <=Int X) andBool (X <Int (2 ^Int 255)) // >

endmodule

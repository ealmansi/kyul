require "../yul-syntax/yul-syntax.k"

module YUL-CONFIGURATION
  imports DOMAINS
  imports YUL-SYNTAX

  syntax KItem ::=
    "#EnvironmentPop" |
    "#EnvironmentPush" |
    "#EnvironmentReplace" |
    "#EnvironmentRestore" |
    "#SymbolTablePop" |
    "#SymbolTablePush"

  configuration
    <T>
      <k> $PGM:Program </k>
      <cRules> .Set </cRules>
      <cStdout stream="stdout"> .List </cStdout>
      <cDebug> .List </cDebug>
      <cSymbolTableStack>
        <cSymbolTableStackSize> 0 </cSymbolTableStackSize>
        <cSymbolTable multiplicity="*">
          <cSymbolTableIndex> -1 </cSymbolTableIndex>
          <cFunction multiplicity="*">
            <cFunctionName> .K </cFunctionName>
            <cFunctionArity> -1 </cFunctionArity>
            <cFunctionParameters multiplicity="*">
              <cFunctionParameterIndex> -1 </cFunctionParameterIndex>
              <cFunctionParameterName> .K </cFunctionParameterName>
              <cFunctionParameterType> .K </cFunctionParameterType>
            </cFunctionParameters>
            <cFunctionBody> .K </cFunctionBody>
            <cFunctionReturnArity> -1 </cFunctionReturnArity>
            <cFunctionReturnParameters multiplicity="*">
              <cFunctionReturnParameterIndex> -1 </cFunctionReturnParameterIndex>
              <cFunctionReturnParameterName> .K </cFunctionReturnParameterName>
              <cFunctionReturnParameterType> .K </cFunctionReturnParameterType>
            </cFunctionReturnParameters>
          </cFunction>
        </cSymbolTable>
      </cSymbolTableStack>
      <cEnvironmentStack>
        <cEnvironmentStackSize> 0 </cEnvironmentStackSize>
        <cEnvironment multiplicity="*">
          <cEnvironmentIndex> -1 </cEnvironmentIndex>
          <cVariable multiplicity="*">
            <cVariableName> .K </cVariableName>
            <cVariableType> .K </cVariableType>
            <cVariableValue> .K </cVariableValue>
          </cVariable>
        </cEnvironment>
      </cEnvironmentStack>
      <cEnvironmentStackCopies> .List </cEnvironmentStackCopies>
    </T>

  rule
    <k>
      #EnvironmentPop =>
      .
      ...
    </k>
    <cEnvironmentStack>
      <cEnvironmentStackSize> ESS => ESS -Int 1 </cEnvironmentStackSize>
      (
        (
          <cEnvironment>
            <cEnvironmentIndex> ESS -Int 1 </cEnvironmentIndex>
            ...
          </cEnvironment>
        ) =>
        .Bag
      )
      ...
    </cEnvironmentStack>

  rule
    <k>
      #EnvironmentPush =>
      .
      ...
    </k>
    <cEnvironmentStack>
      <cEnvironmentStackSize> ESS => ESS +Int 1 </cEnvironmentStackSize>
      (
        .Bag =>
        (
          <cEnvironment>
            <cEnvironmentIndex> ESS </cEnvironmentIndex>
            ...
          </cEnvironment>
        )
      )
      ...
    </cEnvironmentStack>

  rule
    <k>
      #EnvironmentReplace =>
      .
      ...
    </k>
    <cEnvironmentStack>
      ES =>
      <cEnvironmentStackSize> 0 </cEnvironmentStackSize>
    </cEnvironmentStack>
    <cEnvironmentStackCopies>
      .List =>
      ListItem(<cEnvironmentStack> ES </cEnvironmentStack>)
      ...
    </cEnvironmentStackCopies>

  rule
    <k>
      #EnvironmentRestore =>
      .
      ...
    </k>
    <cEnvironmentStack>
      _ =>
      ES
    </cEnvironmentStack>
    <cEnvironmentStackCopies>
      ListItem(<cEnvironmentStack> ES </cEnvironmentStack>) =>
      .List
      ...
    </cEnvironmentStackCopies>

  rule
    <k>
      #SymbolTablePop =>
      .
      ...
    </k>
    <cSymbolTableStack>
      <cSymbolTableStackSize> STSS => STSS -Int 1 </cSymbolTableStackSize>
      (
        (
          <cSymbolTable>
            <cSymbolTableIndex> STSS -Int 1 </cSymbolTableIndex>
            ...
          </cSymbolTable>
        ) =>
        .Bag
      )
      ...
    </cSymbolTableStack>

  rule
    <k>
      #SymbolTablePush =>
      .
      ...
    </k>
    <cSymbolTableStack>
      <cSymbolTableStackSize> STSS => STSS +Int 1 </cSymbolTableStackSize>
      (
        .Bag =>
        (
          <cSymbolTable>
            <cSymbolTableIndex> STSS </cSymbolTableIndex>
            ...
          </cSymbolTable>
        )
      )
      ...
    </cSymbolTableStack>

endmodule

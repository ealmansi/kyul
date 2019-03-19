require "../yul-syntax/yul-syntax.k"

module YUL-CONFIGURATION
  imports DOMAINS
  imports YUL-SYNTAX

  syntax KItem ::=
    clearVariableTypeTableStack() |
    popVariableTypeTable() |
    pushVariableTypeTable() |
    restoreVariableTypeTableStack(List)

  rule
    <k>
      clearVariableTypeTableStack() =>
      .
      ...
    </k>
    <cVariableTypeTableStack>
      _:List =>
      .List
    </cVariableTypeTableStack>
  
  rule
    <k>
      popVariableTypeTable() =>
      .
      ...
    </k>
    <cVariableTypeTableStack>
      ListItem(_:Map) VTTS:List =>
      VTTS
    </cVariableTypeTableStack>
  
  rule
    <k>
      pushVariableTypeTable() =>
      .
      ...
    </k>
    <cVariableTypeTableStack>
      VTTS:List =>
      ListItem(.Map) VTTS
    </cVariableTypeTableStack>

  rule
    <k>
      restoreVariableTypeTableStack(VTTS:List) =>
      .
      ...
    </k>
    <cVariableTypeTableStack>
      _:List =>
      VTTS
    </cVariableTypeTableStack>

  syntax KItem ::=
      popFunctionTypeTable() |
      pushFunctionTypeTable()

  configuration
    <T>
      <k> $PGM:Program </k>
      <cTypeCheck>
        <cVariableTypeTableStack> .List </cVariableTypeTableStack>
        <cFunctionTypeTableStack> .List </cFunctionTypeTableStack>
      </cTypeCheck>
      // <cSignature>
      //   .Map
      // </cSignature>
      // <cContext>
      //   .Map
      // </cContext>
      // <cSymbolTableStack>
      //   <cSymbolTableStackSize> 0 </cSymbolTableStackSize>
      //   <cSymbolTable multiplicity="*">
      //     <cSymbolTableIndex> -1 </cSymbolTableIndex>
      //     <cFunction multiplicity="*">
      //       <cFunctionName> .K </cFunctionName>
      //       <cFunctionArity> -1 </cFunctionArity>
      //       <cFunctionParameters multiplicity="*">
      //         <cFunctionParameterIndex> -1 </cFunctionParameterIndex>
      //         <cFunctionParameterName> .K </cFunctionParameterName>
      //         <cFunctionParameterType> .K </cFunctionParameterType>
      //       </cFunctionParameters>
      //       <cFunctionBody> .K </cFunctionBody>
      //       <cFunctionReturnArity> -1 </cFunctionReturnArity>
      //       <cFunctionReturnParameters multiplicity="*">
      //         <cFunctionReturnParameterIndex> -1 </cFunctionReturnParameterIndex>
      //         <cFunctionReturnParameterName> .K </cFunctionReturnParameterName>
      //         <cFunctionReturnParameterType> .K </cFunctionReturnParameterType>
      //       </cFunctionReturnParameters>
      //     </cFunction>
      //   </cSymbolTable>
      // </cSymbolTableStack>
      // <cEnvironmentStack>
      //   <cEnvironmentStackSize> 0 </cEnvironmentStackSize>
      //   <cEnvironment multiplicity="*">
      //     <cEnvironmentIndex> -1 </cEnvironmentIndex>
      //     <cVariable multiplicity="*">
      //       <cVariableName> .K </cVariableName>
      //       <cVariableType> .K </cVariableType>
      //       <cVariableValue> .K </cVariableValue>
      //     </cVariable>
      //   </cEnvironment>
      // </cEnvironmentStack>
      // <cEnvironmentStackCopies> .List </cEnvironmentStackCopies>
      <cStdout stream="stdout"> .List </cStdout>
      <cDebug> .List </cDebug>
    </T>

endmodule

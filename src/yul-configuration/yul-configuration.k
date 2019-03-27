requires "../yul-syntax/yul-syntax.k"

module YUL-CONFIGURATION
  imports DOMAINS
  imports YUL-SYNTAX

  configuration
    <T>
      <k> $PGM:Program </k>
      <cTypeCheck>
        <cTypeCheckVariableEnvironmentStack> .List </cTypeCheckVariableEnvironmentStack>
        <cTypeCheckFunctionEnvironmentStack> .List </cTypeCheckFunctionEnvironmentStack>
      </cTypeCheck>
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
      // <cStdout stream="stdout"> .List </cStdout>
      // <cDebug> .List </cDebug>
    </T>

endmodule

require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"
// require "../yul-utility/yul-utility.k"
// require "../yul-value/yul-value.k"
require "../yul-ast/yul-ast.k"

module YUL-TYPE-CHECK
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-AST
  // imports YUL-UTILITY
  // imports YUL-VALUE

  syntax Bool ::= isAstFunctionDefinition(AstStatement)

  syntax KItem ::=
    checkTypeProgram(AstProgram) |
    checkTypeBlock(AstBlock) |
    checkTypeStatementSequence(List) |
    checkTypeStatementSequenceFirstPass(List) |
    checkTypeStatementSequenceSecondPass(List) |
    checkTypeStatement(AstStatement) |
    updateEnvironmentFunctionDefinition(AstStatement)

  syntax Identifier ::=
    getNameFunctionDefinition(AstFunctionDefinition) [function]
  
  syntax Type ::=
    getTypeFunctionDefinition(AstFunctionDefinition) [function]
  
  syntax TypeTuple ::=
    getTypeTupleTypedIdentifierList(List) [function] |
    mergeTypeTuples(TypeTuple, TypeTuple) [function]

  rule
    <k>
      checkTypeProgram(B:AstBlock) =>
      checkTypeBlock(B)
      ...
    </k>

  rule
    <k>
      checkTypeBlock(`AstBlock`(SS:List)) =>
      checkTypeStatementSequence(SS)
      ...
    </k>

  rule
    <k>
      checkTypeStatementSequence(SS:List) =>
      (
        checkTypeStatementSequenceFirstPass(SS) ~>
        checkTypeStatementSequenceSecondPass(SS)
      )
      ...
    </k>

  rule
    <k>
      checkTypeStatementSequenceFirstPass(.List) =>
      .
      ...
    </k>

  rule
    <k>
      checkTypeStatementSequenceFirstPass(ListItem(FD:AstFunctionDefinition) SS:List) =>
      (
        updateEnvironmentFunctionDefinition(FD) ~>
        checkTypeStatementSequenceFirstPass(SS)
      )
      ...
    </k>

  rule
    <k>
      updateEnvironmentFunctionDefinition(FD:AstFunctionDefinition) =>
      .
      ...
    </k>
    <cSignature>
      ...
      .Map => (
        getNameFunctionDefinition(FD) |-> getTypeFunctionDefinition(FD)
      )
    </cSignature>

  rule
    <k>
      checkTypeStatementSequenceFirstPass(ListItem(S:AstStatement) SS:List) =>
      checkTypeStatementSequenceFirstPass(SS)
      ...
    </k>
    requires notBool(isAstFunctionDefinition(S))

  rule
    <k>
      checkTypeStatementSequenceSecondPass(.List) =>
      .
      ...
    </k>

  rule
    <k>
      checkTypeStatementSequenceSecondPass(ListItem(S:AstStatement) SS:List) =>
      (
        checkTypeStatement(S) ~>
        checkTypeStatementSequenceSecondPass(SS)
      )
      ...
    </k>

  rule
    <k>
      checkTypeStatement(FD:AstFunctionDefinition) =>
      .
      ...
    </k>

  syntax KItem ::=
    checkNotDefinedTypedIdentifierList(List) |
    updateEnvironmentTypedIdentifierList(List)

  rule
    <k>
      checkTypeStatement(`AstVariableDeclaration1`(TIL:List)) =>
      updateEnvironmentTypedIdentifierList(TIL)
      ...
    </k>

  rule
    <k>
      updateEnvironmentTypedIdentifierList(.List) =>
      .
      ...
    </k>

  rule
    <k>
      updateEnvironmentTypedIdentifierList(ListItem(TI:AstTypedIdentifier) TIL:List) =>
      updateEnvironmentTypedIdentifier(TI) ~> updateEnvironmentTypedIdentifierList(TIL)
      ...
    </k>

  syntax KItem ::=
    "#TypeCheckError" String

  rule
    <k>
      checkNotDefinedTypedIdentifierList(.List) =>
      .
      ...
    </k>

  rule
    <k>
      checkNotDefinedTypedIdentifierList(ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List) =>
      #TypeCheckError "Identifier is already defined."
      ...
    </k>
    <cContext>
      ...
      I |-> T:Type
      ...
    </cContext>

  rule
    <k>
      checkNotDefinedTypedIdentifierList(ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List) =>
      .
      ...
    </k>
    <cContext>
      C:Map
    </cContext>
    requires notBool(I in keys(C))

  // rule
  //   <k>
  //     updateEnvironment(`AstVariableDeclaration1`(.List)) =>
  //     .
  //     ...
  //   </k>

  // rule
  //   <k>
  //     updateEnvironment(ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List) =>
  //     .
  //     ...
  //   </k>
  //   <cContext>
  //     ...
  //     .Map => (
  //       I |-> TN
  //     )
  //   </cContext>

  // rule
  //   <k>
  //     updateEnvironment(S:AstStatement) =>
  //     .
  //     ...
  //   </k>
  //   requires notBool (
  //     isAstFunctionDefinition(S) orBool
  //     isAstVariableDeclaration(S)
  //   )

  syntax Type ::=
    TypeFunction |
    TypeName |
    TypeTuple

  syntax TypeFunction ::=
    "#TypeFunction" TypeTuple TypeTuple

  syntax TypeTuple ::=
    "#TypeTuple" Int List

  rule
    getNameFunctionDefinition(`AstFunctionDefinition`(
      I:Identifier, TIL1:List, TIL2:List, B:AstBlock
    )) =>
    I

  rule
    getTypeFunctionDefinition(`AstFunctionDefinition`(
      I:Identifier, TIL1:List, TIL2:List, B:AstBlock
    )) =>
    #TypeFunction getTypeTupleTypedIdentifierList(TIL1) getTypeTupleTypedIdentifierList(TIL2)

  rule
    getTypeTupleTypedIdentifierList(.List) =>
    #TypeTuple 0 .List
  
  rule
    getTypeTupleTypedIdentifierList(ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List) =>
    mergeTypeTuples(#TypeTuple 1 ListItem(TN), getTypeTupleTypedIdentifierList(TIL))

  rule
    mergeTypeTuples(#TypeTuple I1:Int L1:List, #TypeTuple I2:Int L2:List) =>
    #TypeTuple (I1 +Int I2) (L1 L2)

  // rule
  //   <k>
  //     checkTypeStatementSequence2(.List) =>
  //     .
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeStatementSequence2(ListItem(S:AstStatement) SS:List) =>
  //     checkTypeStatement(S)
  //     checkTypeStatementSequence2(SS)
  //     ...
  //   </k>

  // syntax KItem ::=
  //   "#TypeCheck" Program |
  //   "#TypeCheck" Assignment |
  //   "#TypeCheck" Block |
  //   "#TypeCheck" Case |
  //   "#TypeCheck" CaseSequence |
  //   "#TypeCheck" Code |
  //   "#TypeCheck" Data |
  //   "#TypeCheck" Debug |
  //   "#TypeCheck" Default |
  //   "#TypeCheck" ExpressionList |
  //   "#TypeCheck" For |
  //   "#TypeCheck" FunctionCall |
  //   "#TypeCheck" FunctionDefinition |
  //   "#TypeCheck" IdentifierList |
  //   "#TypeCheck" If |
  //   "#TypeCheck" Object |
  //   "#TypeCheck" ObjectOrDataSequence |
  //   "#TypeCheck" StatementSequence |
  //   "#TypeCheck" Switch |
  //   "#TypeCheck" TypedIdentifier |
  //   "#TypeCheck" TypedIdentifierList |
  //   "#TypeCheck" TypedLiteral |
  //   "#TypeCheck" VariableDeclaration |
  //   TypeCheckResult

  // syntax Type ::=
  //   TypeName |
  //   TypeTuple |
  //   TypeFunction
  
  // syntax TypeTuple ::=
  //   "#TypeTuple" Int List |
  //   getTypedIdentifierListType(TypedIdentifierList) [function] |
  //   extendTuple(TypeTuple, TypeTuple) [function]

  // syntax TypeFunction ::=
  //   "#TypeFunction" TypeTuple TypeTuple |
  //   getFunctionType(FunctionDefinition) [function]

  // rule
  //   getFunctionType(`FunctionDefinition1`(
  //     I:Identifier,
  //     B:Block
  //   )) =>
  //   #TypeFunction (#TypeTuple 0 .List) (#TypeTuple 0 .List)

  // rule
  //   getFunctionType(`FunctionDefinition2`(
  //     I:Identifier,
  //     TIL:TypedIdentifierList,
  //     B:Block
  //   )) =>
  //   #TypeFunction getTypedIdentifierListType(TIL) (#TypeTuple 0 .List)

  // rule
  //   getFunctionType(`FunctionDefinition3`(
  //     I:Identifier,
  //     TIL:TypedIdentifierList,
  //     B:Block
  //   )) =>
  //   #TypeFunction (#TypeTuple 0 .List) getTypedIdentifierListType(TIL)

  // rule
  //   getFunctionType(`FunctionDefinition4`(
  //     I:Identifier,
  //     TIL1:TypedIdentifierList,
  //     TIL2:TypedIdentifierList,
  //     B:Block
  //   )) =>
  //   #TypeFunction getTypedIdentifierListType(TIL1) getTypedIdentifierListType(TIL2)
  
  // rule
  //   getTypedIdentifierListType(`TypedIdentifier`(
  //     I:Identifier,
  //     TN:TypeName
  //   )) =>
  //   #TypeTuple 1 ListItem(TypeName)
  
  // rule
  //   getTypedIdentifierListType(`TypedIdentifierList`(
  //     TIL:TypedIdentifierList,
  //     TI:TypedIdentifier
  //   )) =>
  //   extendTuple(getTypedIdentifierListType(TIL), getTypedIdentifierListType(TI))

  // rule
  //   extendTuple(#TypeTuple I1:Int L1:List, #TypeTuple I2:Int L2:List) =>
  //   #TypeTuple (I1 + I2) (L1 L2)

  // syntax TypeCheckResult ::=
  //   "#TypeCheckError" String |
  //   "#TypeCheckSuccess" Type

  rule
    <k>
      #TypeCheckError S:String ~> _:K =>
      .
    </k>
    <cStdout> ... .List => ListItem(S) </cStdout>

  // rule
  //   <k>
  //     P:Program =>
  //     #TypeCheck P
  //   </k>

  // /**
  //  * Assignment.
  //  */
  
  // syntax KItem ::=
  //   "#TypeCheckAssignment1" Expression |
  //   "#TypeCheckAssignment2" Type

  // rule
  //   <k>
  //     #TypeCheck `Assignment`(
  //       IL:IdentifierList,
  //       E:Expression
  //     ) =>
  //     #TypeCheck IL ~> #TypeCheckAssignment1 E
  //     ...
  //   </k>

  // rule
  //   <k>
  //     (#TypeCheckSuccess T:Type):TypeCheckResult ~> #TypeCheckAssignment1 E:Expression =>
  //     #TypeCheck E ~> #TypeCheckAssignment2 T
  //     ...
  //   </k>

  // rule
  //   <k>
  //     (#TypeCheckSuccess T1:Type):TypeCheckResult ~> #TypeCheckAssignment2 T2:Type =>
  //     #TypeCheckSuccess (#TypeTuple 0 .List)
  //     ...
  //   </k>
  //   requires T1 ==K T2

  // rule
  //   <k>
  //     (#TypeCheckSuccess T1:Type):TypeCheckResult ~> #TypeCheckAssignment2 T2:Type =>
  //     #TypeCheckError "Invalid assignment."
  //     ...
  //   </k>
  //   requires T1 =/=K T2

  // /**
  //  * Block.
  //  */
  
  // rule
  //   <k>
  //     #TypeCheck `Block1`(
  //       .KList
  //     ) =>
  //     #TypeCheckSuccess (#TypeTuple 0 .List)
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Block2`(
  //       SS:StatementSequence
  //     ) =>
  //     #TypeCheckStatementSequence toBuiltInList(SS)
  //     ...
  //   </k>
  
  // rule
  //   <k>
  //     #TypeCheckStatementSequence SS:List =>
  //     (
  //       #TypeCheckStatementSequenceFirstPass1 SS ~>
  //       #TypeCheckStatementSequenceSecondPass SS
  //     )
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheckStatementSequenceFirstPass1 .List =>
  //     .
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheckStatementSequenceFirstPass1 (ListItem(S:Statement) SS:List) =>
  //     #IsFunctionDefinition S ~> #TypeCheckStatementSequenceFirstPass2 S SS
  //     ...
  //   </k>

  // rule
  //   <k>
  //     true ~> #TypeCheckStatementSequenceFirstPass2 S:Statement SS:List =>
  //     (
  //       #TypeCheckDefineFunction1 S ~>
  //       #TypeCheckStatementSequenceFirstPass1 SS
  //     )
  //     ...
  //   </k>

  // rule
  //   <k>
  //     false ~> #TypeCheckStatementSequenceFirstPass2 S:Statement SS:List =>
  //     #TypeCheckStatementSequenceFirstPass1 SS
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheckDefineFunction1 `FunctionDefinition1`(
  //       I:Identifier,
  //       B:Block
  //     ) =>
  //     #TypeCheckDefineFunction2 I .List .List
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheckDefineFunction1 `FunctionDefinition2`(
  //       I:Identifier,
  //       TIL:TypedIdentifierList,
  //       B:Block
  //     ) =>
  //     #TypeCheckDefineFunction2 I toBuiltInList(TIL) .List
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheckDefineFunction1 `FunctionDefinition3`(
  //       I:Identifier,
  //       TIL:TypedIdentifierList,
  //       B:Block
  //     ) =>
  //     #TypeCheckDefineFunction2 I .List toBuiltInList(TIL)
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheckDefineFunction1 `FunctionDefinition4`(
  //       I:Identifier,
  //       TIL1:TypedIdentifierList,
  //       TIL2:TypedIdentifierList,
  //       B:Block
  //     ) =>
  //     #TypeCheckDefineFunction2 I toBuiltInList(TIL1) toBuiltInList(TIL2)
  //     ...
  //   </k>
  
  // rule
  //   <k>
  //     #TypeCheckDefineFunction2 I:Identifier TIL1:List TIL2:List =>
  //     (
  //       #TypeCheckDefineFunctionName I ~>
  //       #TypeCheckDefineFunctionParameters I TIL1 ~>
  //       #TypeCheckDefineFunctionReturnParameters I TIL2
  //     )
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheckDefineFunctionName I:Identifier =>
  //     ...
  //   </k>
  //   <cSymbolTableStack>
  //     <cSymbolTableStackSize> STSS:Int </cSymbolTableStackSize>
  //     <cSymbolTable>
  //       <cSymbolTableIndex> STSS -Int 1 </cSymbolTableIndex>
  //       (
  //         .Bag =>
  //         <cFunction>
  //           <cFunctionName> I </cFunctionName>
  //           <cFunctionArity> 0 </cFunctionArity>
  //           <cFunctionReturnArity> 0 </cFunctionReturnArity>
  //         </cFunction>
  //       )
  //       ...
  //     </cSymbolTable>
  //     ...
  //   </cSymbolTableStack>

  // rule
  //   <k>
  //     #TypeCheckDefineFunctionParameters I:Identifier .List =>
  //     .
  //     ...
  //   </k>

  // rule
  //   <k>
  //     #TypeCheckDefineFunctionParameters I1:Identifier (ListItem(`TypedIdentifier`(I2:Identifier, TN:TypeName)) TIL:List) =>
  //     #TypeCheckDefineFunctionParameters I1 TIL
  //     ...
  //   </k>
  //   <cSymbolTableStack>
  //     <cSymbolTableStackSize> STSS:Int </cSymbolTableStackSize>
  //     <cSymbolTable>
  //       <cSymbolTableIndex> STSS -Int 1 </cSymbolTableIndex>
  //       <cFunction>
  //         <cFunctionName> I1 </cFunctionName>
  //         <cFunctionArity> FA:Int => FA +Int 1 </cFunctionArity>
  //         (
  //           .Bag =>
  //           <cFunctionParameters>
  //             <cFunctionParameterIndex> FA </cFunctionParameterIndex>
  //             <cFunctionParameterType> TN </cFunctionParameterType>
  //           </cFunctionParameters>
  //         )
  //         ...
  //       </cFunction>
  //       ...
  //     </cSymbolTable>
  //     ...
  //   </cSymbolTableStack>

  // rule
  //   <k>
  //     #TypeCheckDefineFunctionReturnParameters I:Identifier TIL:List =>
  //     ...
  //   </k>

  // // rule
  // //   <k>
  // //     #TypeCheck `Case`(
  // //       TL: TypedLiteral,
  // //       B:Block
  // //     ) =>
  // //     // check t(switch exp) = t(TL)
  // //     .
  // //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Data1`(
  //       LS:LiteralString,
  //       LH:LiteralHex
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Data2`(
  //       LS1:LiteralString,
  //       LS2:LiteralString
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Debug`(
  //       I:Identifier
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `For`(
  //       B1:Block,
  //       E:Expression,
  //       B2:Block,
  //       B3:Block
  //     ) =>
  //     // check t(E) = bool
  //     // typecheck B1, B2, B3 (mmm)
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `FunctionCall1`(
  //       I:Identifier
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `FunctionCall2`(
  //       I:Identifier,
  //       EL:ExpressionList
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `FunctionDefinition1`(
  //       I:Identifier,
  //       B:Block
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `FunctionDefinition2`(
  //       I:Identifier,
  //       TIL:TypedIdentifierList,
  //       B:Block
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `FunctionDefinition3`(
  //       I:Identifier,
  //       TIL:TypedIdentifierList,
  //       B:Block
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `FunctionDefinition4`(
  //       I:Identifier,
  //       TIL1:TypedIdentifierList,
  //       TIL2:TypedIdentifierList,
  //       B:Block
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `If`(
  //       E:Expression,
  //       B:Block
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Object1`(
  //       LS:LiteralString,
  //       C:Code
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Object2`(
  //       LS:LiteralString,
  //       C:Code,
  //       OODS:ObjectOrDataSequence
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `ObjectOrDataSequence`(
  //       OODS:ObjectOrDataSequence,
  //       OOD:ObjectOrData
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Switch1`(
  //       E:Expression,
  //       CS:CaseSequence
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Switch2`(
  //       E:Expression,
  //       CS:CaseSequence,
  //       D:Default
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `Switch3`(
  //       E:Expression,
  //       D:Default
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `VariableDeclaration1`(
  //       TIL:TypedIdentifierList
  //     ) =>
  //     .
  //   </k>

  // rule
  //   <k>
  //     #TypeCheck `VariableDeclaration2`(
  //       TIL:TypedIdentifierList,
  //       E:Expression
  //     ) =>
  //     .
  //   </k>

endmodule

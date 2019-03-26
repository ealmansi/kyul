require "../yul-ast/yul-ast.k"
require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"

module YUL-TYPE-CHECK
  imports DOMAINS
  imports YUL-SYNTAX
  imports YUL-CONFIGURATION
  imports YUL-AST

  syntax Hole ::= "HOLE"

  /**
   *
   * Typechecking.
   *
   */

  /**
   * Type
   */

  syntax Type ::=
    TypeFunction |
    TypeName |
    TypeTuple

  syntax TypeFunction ::=
    TypeFunction(TypeTuple, TypeTuple)

  syntax TypeTuple ::=
    TypeTuple(Int, List)

  /**
   * TypeCheckEnvironment
   */

  syntax TypeCheckVariableAccess ::=
    "TypeCheckVariableAccessNone" |
    "TypeCheckVariableAccessReadWrite"

  syntax TypeCheckVariableAttributes ::=
    TypeCheckVariableAttributes(Type, TypeCheckVariableAccess)

  syntax TypeCheckFunctionAttributes ::=
    TypeCheckFunctionAttributes(Type)

  syntax TypeCheckError ::=
    TypeCheckErrorFunctionAlreadyDefined()

  rule
    E:TypeCheckError ~> KI:KItem =>
    E

//   /**
//    * typecheckAssignment
//    */

//   syntax KItem ::=
//     typecheckAssignment(AstAssignment) |
//     typecheckAssignmentIdentifierListResult(
//       TypeInferenceResult,
//       AstExpression,
//       TypeCheckEnvironment
//     ) [function]

//   rule
//     typecheckAssignment(AstAssignment(IL:List, E:AstExpression)) =>
//     inferTypeIdentifierList(IL) ~> typecheckAssignment(AstAssignment(HOLE, E))

//   rule
//     T:Type ~> typecheckAssignment(AstAssignment(HOLE, E:AstExpression)) =>
//     typecheckExpression(E, T)

  /**
   * typecheckBlock
   */

  syntax KItem ::=
    typecheckBlock(AstBlock)

  rule
    typecheckBlock(AstBlock(SS:List)) =>
    (
      beginTypeCheckScope() ~>
      typecheckStatementSequence(SS) ~>
      endTypeCheckScope()
    )

//   /**
//    * typecheckCode
//    */

//   syntax KItem ::=
//     typecheckCode(AstCode)

//   rule
//     typecheckCode(AstCode(B:AstBlock)) =>
//     typecheckBlock(B)

//   /**
//    * typecheckDebug
//    */

//   syntax KItem ::=
//     typecheckDebug(AstDebug) |
//     typecheckDebugExpressionResult(TypeInferenceResult)

//   rule
//     typecheckDebug(AstDebug(I:Identifier)) =>
//     inferTypeExpression(I) ~> typecheckDebug(AstDebug(HOLE))

//   rule
//     T:Type ~> typecheckDebug(AstDebug(HOLE)) =>
//     .

//   /**
//    * typecheckExpression
//    */

//   syntax KItem ::=
//     typecheckExpression(AstExpression, Type) |
//     typecheckExpressionInferResult(TypeInferenceResult, Type)

//   rule
//     typecheckExpression(E:AstExpression, T:Type) =>
//     inferTypeExpression(E) ~> typecheckExpression(HOLE, T)

//   rule
//     T1:Type ~> typecheckExpression(HOLE, T2:Type) =>
//     TypeCheckError("Expression has wrong type.")
//     requires T1 =/=K T2

//   rule
//     T1:Type ~> typecheckExpression(HOLE, T2:Type) =>
//     .
//     requires T1 ==K T2

//   /**
//    * typecheckFor
//    */

//   syntax KItem ::=
//     typecheckFor(AstFor)

//   rule
//     typecheckFor(
//       AstFor(AstBlock(SS1:List), E:AstExpression, AstBlock(SS2:List), AstBlock(SS3:List))
//     ) =>
//     (
//       typecheckBlock(AstBlock(SS1 ListItem(AstIf(E, AstBlock(.List))))) ~>
//       typecheckBlock(AstBlock(SS1 SS2)) ~>
//       typecheckBlock(AstBlock(SS1 SS3))
//     )

//   /**
//    * typecheckFunctionArguments
//    */

//   syntax KItem ::=
//     typecheckFunctionArguments(List, TypeTuple) |

//   rule
//     typecheckFunctionArguments(EL:List, TypeTuple(I:Int, _:List), ) =>
//     TypeCheckError("Function called with wrong number of arguments.")
//     requires size(EL) =/=Int I

//   rule
//     typecheckFunctionArguments(.List, TypeTuple(0, .List)) =>
//     .

//   rule
//     typecheckFunctionArguments(
//       ListItem(E:AstExpression) EL:List,
//       TypeTuple(I:Int, ListItem(T:Type) TL:List)
//     ) =>
//     (
//       typecheckExpression(E, TypeTuple(1, ListItem(T))) ~>
//       typecheckFunctionArguments(EL, TypeTuple(I -Int 1, TL))
//     )

  /**
   * typecheckFunctionDefinition
   */

  syntax KItem ::=
    typecheckFunctionDefinition(AstFunctionDefinition)

  rule
    <k>
      typecheckFunctionDefinition(
        AstFunctionDefinition(_:Identifier, TIL1:List, TIL2:List, AstBlock(SS:List))
      ) =>
      (
        restrictVariableAccessInTypeCheckScope() ~>
        // typecheckBlock(
        //   AstBlock(
        //     ListItem(AstVariableDeclaration1(TIL1))
        //     ListItem(AstVariableDeclaration1(TIL2))
        //     SS
        //   )
        // ) ~>
        restoreTypeCheckEnvironment(VES, FES)
      )
      ...
    </k>
    <cTypeCheckVariableEnvironmentStack>
      VES:List
    </cTypeCheckVariableEnvironmentStack>
    <cTypeCheckFunctionEnvironmentStack>
      FES:List
    </cTypeCheckFunctionEnvironmentStack>

//   /**
//    * typecheckIf
//    */

//   syntax KItem ::=
//     typecheckIf(AstIf)

//   rule
//     typecheckIf(AstIf(E:AstExpression, B:AstBlock)) =>
//     (
//       typecheckExpression(E, TypeTuple(1, ListItem(bool))) ~>
//       typecheckBlock(B)
//     )

//   /**
//    * typecheckObject
//    */

//   syntax KItem ::=
//     typecheckObject(AstObject)

//   rule
//     typecheckObject(AstObject(_:LiteralString, C:AstCode, OODS:List)) =>
//     (
//       typecheckCode(C) ~>
//       typecheckObjectOrDataSequence(OODS)
//     )

//   /**
//    * typecheckObjectOrData
//    */

//   syntax KItem ::=
//     typecheckObjectOrData(AstObjectOrData)

//   rule
//     typecheckObjectOrData(D:AstData) =>
//     .

//   rule
//     typecheckObjectOrData(O:AstObject) =>
//     typecheckObject(O)

//   /**
//    * typecheckObjectOrDataSequence
//    */

//   syntax KItem ::=
//     typecheckObjectOrDataSequence(List)
  
//   rule
//     typecheckObjectOrDataSequence(.List) =>
//     .

//   rule
//     typecheckObjectOrDataSequence(ListItem(OOD:AstObjectOrData) OODS:List) =>
//     (
//       typecheckObjectOrData(OOD) ~>
//       typecheckObjectOrDataSequence(OODS)
//     )

  /**
   * typecheckProgram
   */

  syntax KItem ::=
    typecheckProgram(AstProgram)

  rule
    typecheckProgram(B:AstBlock) =>
    (
      beginTypeCheckScope() ~>
      // setBuiltInFunctions() ~>
      typecheckBlock(B) ~>
      endTypeCheckScope()
    )

  // rule
  //   typecheckProgram(O:AstObject) =>
  //   (
  //     beginTypeCheckScope() ~>
  //     // setBuiltInFunctions() ~>
  //     typecheckObject(O) ~>
  //     endTypeCheckScope()
  //   )

  /**
   * typecheckStatement
   */

  syntax KItem ::=
    typecheckStatement(AstStatement)

  // rule
  //   typecheckStatement(A:AstAssignment) =>
  //   typecheckAssignment(A)

  rule
    typecheckStatement(B:AstBlock) =>
    typecheckBlock(B)

  // rule
  //   typecheckStatement(B:Break) =>
  //   .

  // rule
  //   typecheckStatement(C:Continue) =>
  //   .

  // rule
  //   typecheckStatement(D:AstDebug) =>
  //   typecheckDebug(D)

  // rule
  //   typecheckStatement(F:AstFor) =>
  //   typecheckFor(F)

  // rule
  //   typecheckStatement(E:AstExpression) =>
  //   typecheckExpression(E, makeTypeTuple())

  rule
    typecheckStatement(FD:AstFunctionDefinition) =>
    typecheckFunctionDefinition(FD)

  // rule
  //   typecheckStatement(I:AstIf) =>
  //   typecheckIf(I)

  // rule
  //   typecheckStatement(S:AstSwitch) =>
  //   typecheckSwitch(S)

  // rule
  //   typecheckStatement(VD:AstVariableDeclaration) =>
  //   typecheckVariableDeclaration(VD)

  /**
   * typecheckStatementSequence
   */
  syntax KItem ::=
    typecheckStatementSequence(List) |
    typecheckStatementSequenceFirstPass(List) |
    typecheckStatementSequenceSecondPass(List)

  rule
    typecheckStatementSequence(SS:List) =>
    (
      typecheckStatementSequenceFirstPass(SS) ~>
      typecheckStatementSequenceSecondPass(SS)
    )

  rule
    typecheckStatementSequenceFirstPass(.List) =>
    .

  rule
    typecheckStatementSequenceFirstPass(ListItem(S:AstStatement) SS:List) =>
    typecheckStatementSequenceFirstPass(SS)
    requires notBool(isAstFunctionDefinition(S))

  rule
    typecheckStatementSequenceFirstPass(ListItem(FD:AstFunctionDefinition) SS:List) =>
    (
      checkFunctionNotInTypeCheckScope(getFunctionDefinitionName(FD)) ~>
      setFunctionInTypeCheckScope(
        getFunctionDefinitionName(FD),
        TypeCheckFunctionAttributes(getFunctionDefinitionType(FD))
      ) ~>
      typecheckStatementSequenceFirstPass(SS)
    )

  rule
    typecheckStatementSequenceSecondPass(.List) =>
    .

  rule
    typecheckStatementSequenceSecondPass(ListItem(S:AstStatement) SS:List) =>
    (
      typecheckStatement(S) ~>
      typecheckStatementSequenceSecondPass(SS)
    )

  /**
   * checkFunctionNotInTypeCheckScope
   */

  syntax KItem ::=
    checkFunctionNotInTypeCheckScope(Identifier) |
    checkFunctionNotInTypeCheckScope(Hole)

  rule
    checkFunctionNotInTypeCheckScope(I:Identifier) =>
    lookupFunctionInTypeCheckScope(I) ~> checkFunctionNotInTypeCheckScope(HOLE)

  rule
    .Nothing ~> checkFunctionNotInTypeCheckScope(HOLE) =>
    .

  rule
    Just(_:TypeCheckFunctionAttributes) ~> checkFunctionNotInTypeCheckScope(HOLE) =>
    TypeCheckErrorFunctionAlreadyDefined()

//   /**
//    * typecheckSwitch
//    */

//   syntax KItem ::=
//     typecheckCaseSequence(List, Type) |
//     typecheckSwitch(AstSwitch)

//   rule
//     typecheckSwitch(AstSwitch1(E:AstExpression, CS:List)) =>
//     typecheckSwitch(AstSwitch2(E, CS, AstDefault(AstBlock(.List))))

//   rule
//     typecheckSwitch(AstSwitch2(E:AstExpression, CS:List, D:AstDefault)) =>
//     (
//       inferTypeExpression(E) ~> typecheckSwitch(AstSwitch2(HOLE, CS, D))
//     )

//   rule
//     T:Type ~> typecheckSwitch(AstSwitch2(HOLE, CS:List, D:AstDefault) =>
//     (
//       typecheckCaseSequence(CS, T) ~>
//       typecheckBlock(B)
//     )

//   rule
//     typecheckCaseSequence(.List, _:Type) =>
//     .

//   rule
//     typecheckCaseSequence(ListItem(AstCase(TL:AstTypedLiteral, B:AstBlock)) CS:List, T:Type) =>
//     (
//       typecheckExpression(TL, T) ~>
//       typecheckBlock(B) ~>
//       typecheckCaseSequence(CS, T)
//     )

//   /**
//    * typecheckVariableDeclaration
//    */

//   syntax KItem ::=
//     typecheckVariableDeclaration(AstVariableDeclaration) |
//     typecheckVariableDeclarationSinglePass(List)

//   rule
//     typecheckVariableDeclaration(AstVariableDeclaration1(TIL:List)) =>
//     typecheckVariableDeclarationSinglePass(TIL)

//   rule
//     typecheckVariableDeclaration(AstVariableDeclaration2(TIL:List, E:AstExpression)) =>
//     (
//       typecheckExpression(E, getTypedIdentifierListTypeTuple(TIL)) ~>
//       typecheckVariableDeclarationSinglePass(TIL)
//     )

//   rule
//     typecheckVariableDeclarationSinglePass(.List) =>
//     .

//   rule
//     typecheckVariableDeclarationSinglePass(
//       ListItem(AstTypedIdentifier(I:Identifier, TN:TypeName)) TIL:List
//     ) =>
//     TypeCheckError("Variable is already defined.")
//     requires lookupVariable(I) =/=K .Nothing

//   rule
//     typecheckVariableDeclarationSinglePass(
//       ListItem(AstTypedIdentifier(I:Identifier, TN:TypeName)) TIL:List
//     ) =>
//     (
//       setVariable(I, TypeCheckVariableAttributes(TN, TypeCheckVariableAccessReadWrite) ~>
//       typecheckVariableDeclarationSinglePass(TIL)
//     )
//     requires lookupVariable(I) ==K .Nothing

//   /**
//    *
//    * Type inference.
//    *
//    */

//   /**
//    * TypeInferenceResult
//    */

//   syntax TypeInferenceResult ::=
//     TypeInferenceResultError(String) |
//     TypeInferenceResultSuccess(Type)

//   /**
//    * inferTypeExpression
//    */

//   syntax KItem ::=
//     inferTypeExpression(AstExpression) |
//     inferTypeExpressionFunctionArgumentsResult(TypeCheckResult, TypeTuple) |
//     inferTypeExpressionFunctionLookupResult(Maybe, List) |
//     inferTypeExpressionVariableLookupResult(Maybe)

//   rule
//     inferTypeExpression(I:Identifier) =>
//     inferTypeExpressionVariableLookupResult(lookupVariable(I))

//   rule
//     inferTypeExpressionVariableLookupResult(.Nothing) =>
//     TypeCheckError("Variable is undefined.")

//   rule
//     inferTypeExpressionVariableLookupResult(Just(TypeCheckVariableAttributes(_:Type, TypeCheckVariableAccessNone))) =>
//     TypeCheckError("Variable is not accesible.")

//   rule
//     inferTypeExpressionVariableLookupResult(
//       Just(TypeCheckVariableAttributes(T:Type, TypeCheckVariableAccessReadWrite))
//     ) =>
//     TypeTuple(1, ListItem(T))

//   rule
//     inferTypeExpression(AstTypedLiteral(_:Literal, TN:TypeName)) =>
//     TypeTuple(1, ListItem(TN))

//   rule
//     inferTypeExpression(AstFunctionCall(I:Identifier, EL:List)) =>
//     inferTypeExpressionFunctionLookupResult(lookupFunction(I), EL)

//   rule
//     inferTypeExpressionFunctionLookupResult(.Nothing, EL:List) =>
//     TypeCheckError("Function is undefined.")

//   rule
//     inferTypeExpressionFunctionLookupResult(
//       Just(TypeCheckFunctionAttributes(TypeFunction(TT1:TypeTuple, TT2:TypeTuple))),
//       EL:List
//     ) =>
//     inferTypeExpressionFunctionArgumentsResult(typecheckFunctionArguments(EL, TT1), TT2)

//   rule
//     inferTypeExpressionFunctionArgumentsResult(TypeCheckError(S:String), _:TypeTuple) =>
//     TypeCheckError(S)

//   rule
//     inferTypeExpressionFunctionArgumentsResult(
//       TypeCheckResultSuccess(),
//       TT:TypeTuple
//     ) =>
//     TT

//   /**
//    * inferTypeIdentifierList
//    */

//   syntax TypeInferenceResult ::=
//     inferTypeIdentifierList(List)

//   rule
//     inferTypeIdentifierList(.List, ) =>
//     makeTypeTuple()

//   rule
//     inferTypeIdentifierList(ListItem(I:Identifier) IL:List) =>
//     inferTypeExpression(I) ~> inferTypeIdentifierList(HOLE, IL)

//   rule
//     T:TypeTuple ~> inferTypeIdentifierList(HOLE, IL:List) =>
//     inferTypeIdentifierList(IL) ~> inferTypeIdentifierList(T, HOLE)

//   rule
//     T1:TypeTuple ~> inferTypeIdentifierList(T2:TypeTuple, HOLE) =>
//     mergeTypeTuples(T2, T1)

//   /**
//    *
//    * Environment utility.
//    *
//    */

  /**
   * setVariableInTypeCheckScope
   */

  syntax KItem ::=
    setVariableInTypeCheckScope(Identifier, TypeCheckVariableAttributes)

  rule
    <k>
      setVariableInTypeCheckScope(I:Identifier, VA:TypeCheckVariableAttributes) =>
      .
      ...
    </k>
    <cTypeCheckVariableEnvironmentStack>
      ListItem(VE:Map) VES:List =>
      ListItem(updateMap(VE, I |-> VA)) VES:List
    </cTypeCheckVariableEnvironmentStack>

  /**
   * setFunctionInTypeCheckScope
   */

  syntax KItem ::=
    setFunctionInTypeCheckScope(Identifier, TypeCheckFunctionAttributes)

  rule
    <k>
      setFunctionInTypeCheckScope(I:Identifier, FA:TypeCheckFunctionAttributes) =>
      .
      ...
    </k>
    <cTypeCheckFunctionEnvironmentStack>
      ListItem(FE:Map) FES:List =>
      ListItem(updateMap(FE, I |-> FA)) FES:List
    </cTypeCheckFunctionEnvironmentStack>

//   /**
//    * setBuiltInFunctions
//    */

//   syntax TypeCheckEnvironment ::=
//     setBuiltInFunctions() |
//     setBuiltInFunctions2(List)

//   rule
//     setBuiltInFunctions() =>
//     setBuiltInFunctions2(
//       makeBuiltInFunctionDescription(
//         and, makeTypeTuple(bool, bool), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         not, makeTypeTuple(bool), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         or, makeTypeTuple(bool, bool), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         xor, makeTypeTuple(bool, bool), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         addmodu256, makeTypeTuple(u256, u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         addu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         andu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         byte, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         divs256, makeTypeTuple(s256, s256), makeTypeTuple(s256)
//       )
//       makeBuiltInFunctionDescription(
//         divu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         equ256, makeTypeTuple(u256, u256), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         expu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         gts256, makeTypeTuple(s256, s256), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         gtu256, makeTypeTuple(u256, u256), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         iszerou256, makeTypeTuple(u256), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         lts256, makeTypeTuple(s256, s256), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         ltu256, makeTypeTuple(u256, u256), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         mods256, makeTypeTuple(s256, s256), makeTypeTuple(s256)
//       )
//       makeBuiltInFunctionDescription(
//         modu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         mulmodu256, makeTypeTuple(u256, u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         mulu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         notu256, makeTypeTuple(u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         oru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         sars256, makeTypeTuple(s256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         shlu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         shru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         signextendu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         subu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         xoru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         mload, makeTypeTuple(u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         msize, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         mstore, makeTypeTuple(u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         mstore8, makeTypeTuple(u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         sload, makeTypeTuple(u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         sstore, makeTypeTuple(u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         abort, makeTypeTuple(), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         call, makeTypeTuple(u256, u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         callcode, makeTypeTuple(u256, u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         create, makeTypeTuple(u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         create2, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         delegatecall, makeTypeTuple(u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         log0, makeTypeTuple(u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         log1, makeTypeTuple(u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         log2, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         log3, makeTypeTuple(u256, u256, u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         log4, makeTypeTuple(u256, u256, u256, u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         return, makeTypeTuple(u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         revert, makeTypeTuple(u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         selfdestruct, makeTypeTuple(u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         balance, makeTypeTuple(u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         blockcoinbase, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         blockdifficulty, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         blockgaslimit, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         blockhash, makeTypeTuple(u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         blocknumber, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         blocktimestamp, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         calldatacopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         calldataload, makeTypeTuple(u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         calldatasize, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         caller, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         callvalue, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         codecopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         codesize, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         extcodecopy, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         extcodehash, makeTypeTuple(u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         extcodesize, makeTypeTuple(u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         gasleft, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         this, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         txgasprice, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         txorigin, makeTypeTuple(), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         combineu64tou256, makeTypeTuple(u64, u64, u64, u64), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         datacopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         discard, makeTypeTuple(bool), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         discardu256, makeTypeTuple(u256), makeTypeTuple()
//       )
//       makeBuiltInFunctionDescription(
//         keccak256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         splitu256tou64, makeTypeTuple(u256), makeTypeTuple(u64, u64, u64, u64)
//       )
//       makeBuiltInFunctionDescription(
//         booltos256, makeTypeTuple(bool), makeTypeTuple(s256)
//       )
//       makeBuiltInFunctionDescription(
//         booltou256, makeTypeTuple(bool), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         booltou32, makeTypeTuple(bool), makeTypeTuple(u32)
//       )
//       makeBuiltInFunctionDescription(
//         booltou64, makeTypeTuple(bool), makeTypeTuple(u64)
//       )
//       makeBuiltInFunctionDescription(
//         s256tobool, makeTypeTuple(s256), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         s256tou256, makeTypeTuple(s256), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         s256tou32, makeTypeTuple(s256), makeTypeTuple(u32)
//       )
//       makeBuiltInFunctionDescription(
//         s256tou64, makeTypeTuple(s256), makeTypeTuple(u64)
//       )
//       makeBuiltInFunctionDescription(
//         u256tobool, makeTypeTuple(u256), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         u256tos256, makeTypeTuple(u256), makeTypeTuple(s256)
//       )
//       makeBuiltInFunctionDescription(
//         u256tou32, makeTypeTuple(u256), makeTypeTuple(u32)
//       )
//       makeBuiltInFunctionDescription(
//         u256tou64, makeTypeTuple(u256), makeTypeTuple(u64)
//       )
//       makeBuiltInFunctionDescription(
//         u32tobool, makeTypeTuple(u32), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         u32tos256, makeTypeTuple(u32), makeTypeTuple(s256)
//       )
//       makeBuiltInFunctionDescription(
//         u32tou256, makeTypeTuple(u32), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         u32tou64, makeTypeTuple(u32), makeTypeTuple(u64)
//       )
//       makeBuiltInFunctionDescription(
//         u64tobool, makeTypeTuple(u64), makeTypeTuple(bool)
//       )
//       makeBuiltInFunctionDescription(
//         u64tos256, makeTypeTuple(u64), makeTypeTuple(s256)
//       )
//       makeBuiltInFunctionDescription(
//         u64tou256, makeTypeTuple(u64), makeTypeTuple(u256)
//       )
//       makeBuiltInFunctionDescription(
//         u64tou32, makeTypeTuple(u64), makeTypeTuple(u32)
//       )
//     )

//   rule
//     setBuiltInFunctions2(.List) =>
//     .

//   rule
//     setBuiltInFunctions2(
//       ListItem(
//         BuiltInFunctionDescription(IBIF:IdentifierBuiltInFunction, T1:TypeTuple, T2:TypeTuple)
//       ) L:List
//     ) =>
//     setBuiltInFunctions2(L, setFunctionInTypeCheckScope(IBIF, TypeCheckFunctionAttributes(TypeFunction(T1, T2))))

//   /**
//    * makeBuiltInFunctionDescription
//    */

//   syntax BuiltInFunctionDescription ::=
//     BuiltInFunctionDescription(IdentifierBuiltInFunction, TypeTuple, TypeTuple)

//   syntax List ::=
//     makeBuiltInFunctionDescription(IdentifierBuiltInFunction, TypeTuple, TypeTuple)

//   rule
//     makeBuiltInFunctionDescription(IBIF:IdentifierBuiltInFunction, T1:TypeTuple, T2:TypeTuple) =>
//     ListItem(BuiltInFunctionDescription(IBIF, T1, T2))

  /**
   * lookupVariableInTypeCheckScope
   */

  syntax KItem ::=
    lookupVariableInTypeCheckScope(Identifier)

  rule
    <k>
      lookupVariableInTypeCheckScope(I:Identifier) =>
      lookupVariableInTypeCheckScopeAux(I, VES)
      ...
    </k>
    <cTypeCheckVariableEnvironmentStack>
      VES:List
    </cTypeCheckVariableEnvironmentStack>

  syntax Maybe ::=
    lookupVariableInTypeCheckScopeAux(Identifier, variableEnvironmentStack:List) [function]

  rule
    lookupVariableInTypeCheckScopeAux(I:Identifier, .List) =>
    .Nothing

  rule
    lookupVariableInTypeCheckScopeAux(I:Identifier, ListItem(VE:Map) VES:List) =>
    lookupVariableInTypeCheckScopeAux(I, VES)
    requires notBool(I in keys(VE))

  rule
    lookupVariableInTypeCheckScopeAux(I:Identifier, ListItem(VE:Map) VES:List) =>
    Just(VE[I])
    requires I in keys(VE)

  /**
   * lookupFunctionInTypeCheckScope
   */

  syntax KItem ::=
    lookupFunctionInTypeCheckScope(Identifier)

  rule
    <k>
      lookupFunctionInTypeCheckScope(I:Identifier) =>
      lookupFunctionInTypeCheckScopeAux(I, FES)
      ...
    </k>
    <cTypeCheckFunctionEnvironmentStack>
      FES:List
    </cTypeCheckFunctionEnvironmentStack>

  syntax Maybe ::=
    lookupFunctionInTypeCheckScopeAux(Identifier, functionEnvironmentStack:List) [function]

  rule
    lookupFunctionInTypeCheckScopeAux(I:Identifier, .List) =>
    .Nothing

  rule
    lookupFunctionInTypeCheckScopeAux(I:Identifier, ListItem(FE:Map) FES:List) =>
    lookupFunctionInTypeCheckScopeAux(I, FES)
    requires notBool(I in keys(FE))

  rule
    lookupFunctionInTypeCheckScopeAux(I:Identifier, ListItem(FE:Map) FES:List) =>
    Just(FE[I])
    requires I in keys(FE)

  /**
   * beginTypeCheckScope
   */

  syntax KItem ::=
    beginTypeCheckScope()

  rule
    <k>
      beginTypeCheckScope() =>
      .
      ...
    </k>
    <cTypeCheckVariableEnvironmentStack>
      VES:List =>
      ListItem(.Map) VES
    </cTypeCheckVariableEnvironmentStack>
    <cTypeCheckFunctionEnvironmentStack>
      FES:List =>
      ListItem(.Map) FES
    </cTypeCheckFunctionEnvironmentStack>

  /**
   * endTypeCheckScope
   */

  syntax KItem ::=
    endTypeCheckScope()

  rule
    <k>
      endTypeCheckScope() =>
      .
      ...
    </k>
    <cTypeCheckVariableEnvironmentStack>
      ListItem(_:Map) VES:List =>
      VES
    </cTypeCheckVariableEnvironmentStack>
    <cTypeCheckFunctionEnvironmentStack>
      ListItem(_:Map) FES:List =>
      FES
    </cTypeCheckFunctionEnvironmentStack>

  /**
   * restrictVariableAccessInTypeCheckScope
   */

  syntax KItem ::=
    restrictVariableAccessInTypeCheckScope()

  rule
    <k>
      restrictVariableAccessInTypeCheckScope() =>
      .
      ...
    </k>
    <cTypeCheckVariableEnvironmentStack>
      VES:List =>
      restrictVariableAccessInTypeCheckScopeAux1(VES)
    </cTypeCheckVariableEnvironmentStack>

  syntax List ::=
    restrictVariableAccessInTypeCheckScopeAux1(variableEnvironmentStack:List) [function]

  syntax Map ::=
    restrictVariableAccessInTypeCheckScopeAux2(variableEnvironment:Map, Set) [function] |
    restrictVariableAccessInTypeCheckScopeAux3(
      variableEnvironment:Map,
      Identifier,
      TypeCheckVariableAttributes
    ) [function]

  rule
    restrictVariableAccessInTypeCheckScopeAux1(.List) =>
    .List

  rule
    restrictVariableAccessInTypeCheckScopeAux1(ListItem(VE:Map) VES:List) =>
    (
      ListItem(restrictVariableAccessInTypeCheckScopeAux2(VE, keys(VE)))
      restrictVariableAccessInTypeCheckScopeAux1(VES)
    )

  rule
    restrictVariableAccessInTypeCheckScopeAux2(VE:Map, .Set) =>
    VE

  rule
    restrictVariableAccessInTypeCheckScopeAux2(VE:Map, SetItem(I:Identifier) IS:Set) =>
    restrictVariableAccessInTypeCheckScopeAux2(
      restrictVariableAccessInTypeCheckScopeAux3(VE, I, {VE[I]}:>TypeCheckVariableAttributes),
      IS
    )

  rule
    restrictVariableAccessInTypeCheckScopeAux3(
      VE:Map,
      I:Identifier,
      TypeCheckVariableAttributes(T:Type, _:TypeCheckVariableAccess)
    ) =>
    updateMap(VE, I |-> TypeCheckVariableAttributes(T, TypeCheckVariableAccessNone))

  /**
   * restoreTypeCheckEnvironment
   */

  syntax KItem ::=
    restoreTypeCheckEnvironment(variableEnvironmentStack:List, functionEnvironmentStack:List)

  rule
    <k>
      restoreTypeCheckEnvironment(VES:List, FES:List) =>
      .
      ...
    </k>
    <cTypeCheckVariableEnvironmentStack>
      _:List =>
      VES
    </cTypeCheckVariableEnvironmentStack>
    <cTypeCheckFunctionEnvironmentStack>
      _:List =>
      FES
    </cTypeCheckFunctionEnvironmentStack>

  /**
   *
   * Miscellaneous.
   *
   */

  /**
   * Maybe
   */

  syntax Maybe ::=
    ".Nothing" |
    Just(KItem)

  /**
   * isAstFunctionDefinition [BUILT-IN]
   */

  syntax Bool ::=
    isAstFunctionDefinition(AstStatement)

  /**
   * getFunctionDefinitionName
   */

  syntax Identifier ::=
    getFunctionDefinitionName(AstFunctionDefinition) [function]

  rule
    getFunctionDefinitionName(
      AstFunctionDefinition(I:Identifier, TIL1:List, TIL2:List, B:AstBlock)
    ) =>
    I

  /**
   * getFunctionDefinitionType
   */

  syntax Type ::=
    getFunctionDefinitionType(AstFunctionDefinition) [function]

  rule
    getFunctionDefinitionType(
      AstFunctionDefinition(I:Identifier, TIL1:List, TIL2:List, B:AstBlock)
    ) =>
    TypeFunction(getTypedIdentifierListTypeTuple(TIL1), getTypedIdentifierListTypeTuple(TIL2))

  /**
   * makeTypeTuple
   */

  syntax TypeTuple ::=
    makeTypeTuple() [function] |
    makeTypeTuple(Type) [function] |
    makeTypeTuple(Type, Type) [function] |
    makeTypeTuple(Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type, Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type, Type, Type, Type, Type) [function]

  rule
    makeTypeTuple() =>
    TypeTuple(0, .List)

  rule
    makeTypeTuple(T1:Type) =>
    TypeTuple(1, ListItem(T1))

  rule
    makeTypeTuple(T1:Type, T2:Type) =>
    TypeTuple(2, ListItem(T1) ListItem(T2))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type) =>
    TypeTuple(3, ListItem(T1) ListItem(T2) ListItem(T3))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type, T4:Type) =>
    TypeTuple(4, ListItem(T1) ListItem(T2) ListItem(T3) ListItem(T4))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type, T4:Type, T5:Type) =>
    TypeTuple(5, ListItem(T1) ListItem(T2) ListItem(T3) ListItem(T4) ListItem(T5))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type, T4:Type, T5:Type, T6:Type) =>
    TypeTuple(6, ListItem(T1) ListItem(T2) ListItem(T3) ListItem(T4) ListItem(T5) ListItem(T6))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type, T4:Type, T5:Type, T6:Type, T7:Type) =>
    TypeTuple(
      7,
      ListItem(T1) ListItem(T2) ListItem(T3) ListItem(T4) ListItem(T5) ListItem(T6) ListItem(T7)
    )

  /**
   * mergeTypeTuples
   */

  syntax TypeTuple ::=
    mergeTypeTuples(TypeTuple, TypeTuple) [function]

  rule
    mergeTypeTuples(TypeTuple(I1:Int, L1:List), TypeTuple(I2:Int, L2:List)) =>
    TypeTuple(I1 +Int I2, L1 L2)

  /**
   * getTypedIdentifierListTypeTuple
   */

  syntax TypeTuple ::=
    getTypedIdentifierListTypeTuple(List) [function]

  rule
    getTypedIdentifierListTypeTuple(.List) =>
    makeTypeTuple()

  rule
    getTypedIdentifierListTypeTuple(
      ListItem(AstTypedIdentifier(I:Identifier, TN:TypeName)) TIL:List
    ) =>
    mergeTypeTuples(TypeTuple(1, ListItem(TN)), getTypedIdentifierListTypeTuple(TIL))

endmodule

require "../yul-syntax/yul-syntax.k"
require "../yul-ast/yul-ast.k"

module YUL-TYPE-CHECK
  imports DOMAINS
  imports YUL-SYNTAX
  imports YUL-AST

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

  syntax VariableAccess ::=
    "VariableAccessNone" |
    "VariableAccessReadWrite"

  syntax VariableAttributes ::=
    VariableAttributes(Type, VariableAccess)

  syntax FunctionAttributes ::=
    FunctionAttributes(Type)

  syntax TypeCheckEnvironment ::=
    TypeCheckEnvironment(VariableEnvironmentStack:List, FunctionEnvironmentStack:List)

  /**
   * TypeCheckResult
   */

  syntax TypeCheckResult ::=
    TypeCheckResultError(String) |
    TypeCheckResultSuccess(TypeCheckEnvironment)

  /**
   * typecheckAssignment
   */

  syntax TypeCheckResult ::=
    typecheckAssignment(AstAssignment, TypeCheckEnvironment) [function] |
    typecheckAssignmentIdentifierListResult(
      TypeInferenceResult,
      AstExpression,
      TypeCheckEnvironment
    ) [function]

  rule
    typecheckAssignment(AstAssignment(IL:List, E:AstExpression), TCE:TypeCheckEnvironment) =>
    typecheckAssignmentIdentifierListResult(inferTypeIdentifierList(IL, TCE), E, TCE)

  rule
    typecheckAssignmentIdentifierListResult(
      TypeInferenceResultError(S:String),
      _:AstExpression,
      _:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckAssignmentIdentifierListResult(
      TypeInferenceResultSuccess(T:Type),
      E:AstExpression,
      TCE:TypeCheckEnvironment
    ) =>
    typecheckExpression(E, T, TCE)

  /**
   * typecheckBlock
   */

  syntax TypeCheckResult ::=
    typecheckBlock(AstBlock, TypeCheckEnvironment) [function] |
    typecheckBlockStatementSequenceResult(TypeCheckResult) [function]

  rule
    typecheckBlock(AstBlock(SS:List), TCE:TypeCheckEnvironment) =>
    typecheckBlockStatementSequenceResult(typecheckStatementSequence(SS, pushScope(TCE)))

  rule
    typecheckBlockStatementSequenceResult(TypeCheckResultError(S:String)) =>
    TypeCheckResultError(S)

  rule
    typecheckBlockStatementSequenceResult(TypeCheckResultSuccess(TCE:TypeCheckEnvironment)) =>
    TypeCheckResultSuccess(popScope(TCE))

  /**
   * typecheckCode
   */

  syntax TypeCheckResult ::=
    typecheckCode(AstCode, TypeCheckEnvironment) [function]

  rule
    typecheckCode(AstCode(B:AstBlock), TCE:TypeCheckEnvironment) =>
    typecheckBlock(B, TCE)

  /**
   * typecheckDebug
   */

  syntax TypeCheckResult ::=
    typecheckDebug(AstDebug, TypeCheckEnvironment) [function] |
    typecheckDebugExpressionResult(TypeInferenceResult, TypeCheckEnvironment) [function]

  rule
    typecheckDebug(AstDebug(I:Identifier), TCE) =>
    typecheckDebugExpressionResult(inferTypeExpression(I, TCE), TCE)

  rule
    typecheckDebugExpressionResult(TypeInferenceResultError(S:String), _:TypeCheckEnvironment) =>
    TypeCheckResultError(S)

  rule
    typecheckDebugExpressionResult(TypeInferenceResultSuccess(_:Type), TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  /**
   * typecheckExpression
   */

  syntax TypeCheckResult ::=
    typecheckExpression(AstExpression, Type, TypeCheckEnvironment) [function] |
    typecheckExpressionInferResult(TypeInferenceResult, Type, TypeCheckEnvironment) [function]

  rule
    typecheckExpression(E:AstExpression, T:Type, TCE:TypeCheckEnvironment) =>
    typecheckExpressionInferResult(inferTypeExpression(E, TCE), T, TCE)

  rule
    typecheckExpressionInferResult(TypeInferenceResultError(S), T:Type, TCE:TypeCheckEnvironment) =>
    TypeCheckResultError(S)

  rule
    typecheckExpressionInferResult(
      TypeInferenceResultSuccess(T1:Type),
      T2:Type,
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultError("Expression has wrong type.")
    requires T1 =/=K T2

  rule
    typecheckExpressionInferResult(
      TypeInferenceResultSuccess(T1:Type),
      T2:Type,
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultSuccess(TCE)
    requires T1 ==K T2

  /**
   * typecheckFor
   */

  syntax TypeCheckResult ::=
    typecheckFor(AstFor, TypeCheckEnvironment) [function] |
    typecheckForBlocks(
      AstBlock,
      AstExpression,
      AstBlock,
      AstBlock,
      TypeCheckEnvironment
    ) [function] |
    typecheckForBlocksResults(
      TypeCheckResult,
      TypeCheckResult,
      TypeCheckResult,
      TypeCheckEnvironment
    ) [function]

  rule
    typecheckFor(
      AstFor(B1:AstBlock, E:AstExpression, B2:AstBlock, B3:AstBlock),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckForBlocks(B1, E, B2, B3, TCE)

  rule
    typecheckForBlocks(
      AstBlock(SS1:List),
      E:AstExpression,
      AstBlock(SS2:List),
      AstBlock(SS3:List),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckForBlocksResults(
      typecheckBlock(AstBlock(SS1 ListItem(AstIf(E, AstBlock(.List)))), TCE),
      typecheckBlock(AstBlock(SS1 SS2), TCE),
      typecheckBlock(AstBlock(SS1 SS3), TCE),
      TCE
    )

  rule
    typecheckForBlocksResults(
      TypeCheckResultError(S:String),
      _:TypeCheckResult,
      _:TypeCheckResult,
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckForBlocksResults(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultError(S:String),
      _:TypeCheckResult,
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckForBlocksResults(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultError(S:String),
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckForBlocksResults(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultSuccess(TCE)

  /**
   * typecheckFunctionArguments
   */

  syntax TypeCheckResult ::=
    typecheckFunctionArguments(List, TypeTuple, TypeCheckEnvironment) [function] |
    typecheckFunctionArgumentsExpressionResult(TypeCheckResult, List, TypeTuple) [function]

  rule
    typecheckFunctionArguments(EL:List, TypeTuple(I:Int, _:List), _:TypeCheckEnvironment) =>
    TypeCheckResultError("Function called with wrong number of arguments.")
    requires size(EL) =/=Int I

  rule
    typecheckFunctionArguments(.List, TypeTuple(0, .List), TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckFunctionArguments(
      ListItem(E:AstExpression) EL:List,
      TypeTuple(I:Int, ListItem(T:Type) TL:List),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckFunctionArgumentsExpressionResult(
      typecheckExpression(E, TypeTuple(1, ListItem(T)), TCE),
      EL,
      TypeTuple(I -Int 1, TL)
    )

  rule
    typecheckFunctionArgumentsExpressionResult(
      TypeCheckResultError(S:String),
      _:List,
      _:TypeTuple
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckFunctionArgumentsExpressionResult(
      TypeCheckResultSuccess(TCE:TypeCheckEnvironment),
      EL:List,
      TT:TypeTuple
    ) =>
    typecheckFunctionArguments(EL, TT, TCE)

  /**
   * typecheckFunctionDefinition
   */

  syntax TypeCheckResult ::=
    typecheckFunctionDefinition(AstFunctionDefinition, TypeCheckEnvironment) [function] |
    typecheckFunctionDefinitionResults(TypeCheckResult, TypeCheckEnvironment) [function]

  rule
    typecheckFunctionDefinition(
      AstFunctionDefinition(_:Identifier, TIL1:List, TIL2:List, B:AstBlock),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckFunctionDefinitionResults(
      typecheckBlock(
        AstBlock(
          ListItem(AstVariableDeclaration1(TIL1))
          ListItem(AstVariableDeclaration1(TIL2))
          ListItem(B)
        ),
        pushScopeWithRestrictedVariableAccess(TCE)
      ),
      TCE
    )

  rule
    typecheckFunctionDefinitionResults(TypeCheckResultError(S:String), _:TypeCheckEnvironment) =>
    TypeCheckResultError(S)

  rule
    typecheckFunctionDefinitionResults(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultSuccess(TCE)

  /**
   * typecheckIf
   */

  syntax TypeCheckResult ::=
    typecheckIf(AstIf, TypeCheckEnvironment) [function] |
    typecheckIfExpressionResult(TypeCheckResult, AstBlock) [function]

  rule
    typecheckIf(AstIf(E:AstExpression, B:AstBlock), TCE:TypeCheckEnvironment) =>
    typecheckIfExpressionResult(typecheckExpression(E, TypeTuple(1, ListItem(bool)), TCE), B)

  rule
    typecheckIfExpressionResult(TypeCheckResultError(S:String), B:AstBlock) =>
    TypeCheckResultError(S)

  rule
    typecheckIfExpressionResult(TypeCheckResultSuccess(TCE:TypeCheckEnvironment), B:AstBlock) =>
    typecheckBlock(B, TCE)

  /**
   * typecheckObject
   */

  syntax TypeCheckResult ::=
    typecheckObject(AstObject, TypeCheckEnvironment) [function] |
    typecheckObjectCodeResult(TypeCheckResult, List) [function]

  rule
    typecheckObject(
      AstObject(_:LiteralString, C:AstCode, OODS:List),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckObjectCodeResult(typecheckCode(C, TCE), OODS)

  rule
    typecheckObjectCodeResult(TypeCheckResultError(S:String), _:List) =>
    TypeCheckResultError(S)

  rule
    typecheckObjectCodeResult(TypeCheckResultSuccess(TCE:TypeCheckEnvironment), OODS:List) =>
    typecheckObjectOrDataSequence(OODS, TCE)

  /**
   * typecheckObjectOrData
   */

  syntax TypeCheckResult ::=
    typecheckObjectOrData(AstObjectOrData, TypeCheckEnvironment) [function]

  rule
    typecheckObjectOrData(D:AstData, TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckObjectOrData(O:AstObject, TCE:TypeCheckEnvironment) =>
    typecheckObject(O, TCE)

  /**
   * typecheckObjectOrDataSequence
   */

  syntax TypeCheckResult ::=
    typecheckObjectOrDataSequence(List, TypeCheckEnvironment) [function] |
    typecheckObjectOrDataSequenceObjectOrDataResult(TypeCheckResult, List) [function]
  
  rule
    typecheckObjectOrDataSequence(.List, TCE) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckObjectOrDataSequence(ListItem(OOD:AstObjectOrData) OODS:List, TCE) =>
    typecheckObjectOrDataSequenceObjectOrDataResult(
      typecheckObjectOrData(OOD, TCE),
      OODS
    )

  rule
    typecheckObjectOrDataSequenceObjectOrDataResult(TypeCheckResultError(S:String), _:List) =>
    TypeCheckResultError(S)

  rule
    typecheckObjectOrDataSequenceObjectOrDataResult(
      TypeCheckResultSuccess(TCE:TypeCheckEnvironment),
      OODS:List
    ) =>
    typecheckObjectOrDataSequence(OODS, TCE)

  /**
   * typecheckProgram
   */

  syntax TypeCheckResult ::=
    typecheckProgram(AstProgram, TypeCheckEnvironment) [function] |
    typecheckProgramResult(TypeCheckResult) [function]

  rule
    typecheckProgram(B:AstBlock, TCE:TypeCheckEnvironment) =>
    typecheckProgramResult(typecheckBlock(B, setBuiltInFunctions(pushScope(TCE))))

  rule
    typecheckProgram(O:AstObject, TCE:TypeCheckEnvironment) =>
    typecheckProgramResult(typecheckObject(O, setBuiltInFunctions(pushScope(TCE))))

  rule
    typecheckProgramResult(TypeCheckResultError(S:String)) =>
    TypeCheckResultError(S)

  rule
    typecheckProgramResult(TypeCheckResultSuccess(TCE:TypeCheckEnvironment)) =>
    TypeCheckResultSuccess(popScope(TCE))

  /**
   * typecheckStatement
   */
  syntax TypeCheckResult ::=
    typecheckStatement(AstStatement, TypeCheckEnvironment) [function]

  rule
    typecheckStatement(A:AstAssignment, TCE:TypeCheckEnvironment) =>
    typecheckAssignment(A, TCE)

  rule
    typecheckStatement(B:AstBlock, TCE:TypeCheckEnvironment) =>
    typecheckBlock(B, TCE)

  rule
    typecheckStatement(B:Break, TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckStatement(C:Continue, TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckStatement(D:AstDebug, TCE:TypeCheckEnvironment) =>
    typecheckDebug(D, TCE)

  rule
    typecheckStatement(F:AstFor, TCE:TypeCheckEnvironment) =>
    typecheckFor(F, TCE)

  rule
    typecheckStatement(E:AstExpression, TCE:TypeCheckEnvironment) =>
    typecheckExpression(E, makeTypeTuple(), TCE)

  rule
    typecheckStatement(FD:AstFunctionDefinition, TCE:TypeCheckEnvironment) =>
    typecheckFunctionDefinition(FD, TCE)

  rule
    typecheckStatement(I:AstIf, TCE:TypeCheckEnvironment) =>
    typecheckIf(I, TCE)

  rule
    typecheckStatement(S:AstSwitch, TCE:TypeCheckEnvironment) =>
    typecheckSwitch(S, TCE)

  rule
    typecheckStatement(VD:AstVariableDeclaration, TCE:TypeCheckEnvironment) =>
    typecheckVariableDeclaration(VD, TCE)

  /**
   * typecheckStatementSequence
   */
  syntax TypeCheckResult ::=
    typecheckStatementSequence(List, TypeCheckEnvironment) [function] |
    typecheckStatementSequenceFirstPass(List, TypeCheckEnvironment) [function] |
    typecheckStatementSequenceFirstPassResult(TypeCheckResult, List) [function] |
    typecheckStatementSequenceSecondPass(List, TypeCheckEnvironment) [function] |
    typecheckStatementSequenceSecondPassResult(TypeCheckResult) [function] |
    typecheckStatementSequenceStatementResult(TypeCheckResult, List) [function]

  rule
    typecheckStatementSequence(SS:List, TCE:TypeCheckEnvironment) =>
    typecheckStatementSequenceFirstPassResult(typecheckStatementSequenceFirstPass(SS, TCE), SS)

  rule
    typecheckStatementSequenceFirstPass(.List, TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckStatementSequenceFirstPass(
      ListItem(S:AstStatement) SS:List,
      TCE:TypeCheckEnvironment
    ) =>
    typecheckStatementSequenceFirstPass(SS, TCE)
    requires notBool(isAstFunctionDefinition(S))

  rule
    typecheckStatementSequenceFirstPass(
      ListItem(FD:AstFunctionDefinition) SS:List,
      TCE:TypeCheckEnvironment
    ) =>
    typecheckStatementSequenceFirstPass(
      SS,
      setFunction(
        getFunctionDefinitionName(FD),
        FunctionAttributes(getFunctionDefinitionType(FD)),
        TCE
      )
    )
    requires lookupFunction(getFunctionDefinitionName(FD), TCE) ==K .Nothing

  rule
    typecheckStatementSequenceFirstPass(
      ListItem(FD:AstFunctionDefinition) SS:List,
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultError("Function is already defined.")
    requires lookupFunction(getFunctionDefinitionName(FD), TCE) =/=K .Nothing

  rule
    typecheckStatementSequenceFirstPassResult(TypeCheckResultError(S:String), SS:List) =>
    TypeCheckResultError(S)

  rule
    typecheckStatementSequenceFirstPassResult(
      TypeCheckResultSuccess(TCE:TypeCheckEnvironment),
      SS:List
    ) =>
    typecheckStatementSequenceSecondPassResult(typecheckStatementSequenceSecondPass(SS, TCE))

  rule
    typecheckStatementSequenceSecondPass(.List, TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckStatementSequenceSecondPass(
      ListItem(S:AstStatement) SS:List,
      TCE:TypeCheckEnvironment
    ) =>
    typecheckStatementSequenceStatementResult(typecheckStatement(S, TCE), SS)

  rule
    typecheckStatementSequenceStatementResult(TypeCheckResultError(S:String), SS:List) =>
    TypeCheckResultError(S)

  rule
    typecheckStatementSequenceStatementResult(
      TypeCheckResultSuccess(TCE:TypeCheckEnvironment),
      SS:List
    ) =>
    typecheckStatementSequenceSecondPass(SS, TCE)

  rule
    typecheckStatementSequenceSecondPassResult(TypeCheckResultError(S:String)) =>
    TypeCheckResultError(S)

  rule
    typecheckStatementSequenceSecondPassResult(TypeCheckResultSuccess(TCE:TypeCheckEnvironment)) =>
    TypeCheckResultSuccess(TCE)

  /**
   * typecheckSwitch
   */

  syntax TypeCheckResult ::=
    typecheckCaseSequence(List, Type, TypeCheckEnvironment) [function] |
    typecheckCaseSequenceResults(
      TypeCheckResult,
      TypeCheckResult,
      List,
      Type,
      TypeCheckEnvironment
    ) [function] |
    typecheckSwitch(AstSwitch, TypeCheckEnvironment) [function] |
    typecheckSwitchCaseSequenceResult(
      TypeCheckResult,
      AstDefault,
      TypeCheckEnvironment
    ) [function] |
    typecheckSwitchExpressionResult(
      TypeInferenceResult,
      List,
      AstDefault,
      TypeCheckEnvironment
    ) [function]

  rule
    typecheckSwitch(AstSwitch1(E:AstExpression, CS:List), TCE:TypeCheckEnvironment) =>
    typecheckSwitch(AstSwitch2(E, CS, AstDefault(AstBlock(.List))), TCE)

  rule
    typecheckSwitch(
      AstSwitch2(E:AstExpression, CS:List, D:AstDefault),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckSwitchExpressionResult(inferTypeExpression(E, TCE), CS, D, TCE)

  rule
    typecheckSwitchExpressionResult(
      TypeInferenceResultError(S:String),
      _:List,
      _:AstDefault,
      _:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckSwitchExpressionResult(
      TypeInferenceResultSuccess(T:Type),
      CS:List,
      D:AstDefault,
      TCE:TypeCheckEnvironment
    ) =>
    typecheckSwitchCaseSequenceResult(typecheckCaseSequence(CS, T, TCE), D, TCE)

  rule
    typecheckCaseSequence(.List, _:Type, TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckCaseSequence(
      ListItem(AstCase(TL:AstTypedLiteral, B:AstBlock)) CS:List,
      T:Type,
      TCE:TypeCheckEnvironment
    ) =>
    typecheckCaseSequenceResults(
      typecheckExpression(TL, T, TCE),
      typecheckBlock(B, TCE),
      CS,
      T,
      TCE
    )

  rule
    typecheckCaseSequenceResults(
      TypeCheckResultError(S:String),
      _:TypeCheckResult,
      _:List,
      _:Type,
      _:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckCaseSequenceResults(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultError(S:String),
      _:List,
      _:Type,
      _:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckCaseSequenceResults(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      CS:List,
      T:Type,
      TCE:TypeCheckEnvironment
    ) =>
    typecheckCaseSequence(CS, T, TCE)

  rule
    typecheckSwitchCaseSequenceResult(
      TypeCheckResultError(S:String),
      _:AstDefault,
      _:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckSwitchCaseSequenceResult(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      AstDefault(B:AstBlock),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckBlock(B, TCE)

  /**
   * typecheckVariableDeclaration
   */

  syntax TypeCheckResult ::=
    typecheckVariableDeclaration(AstVariableDeclaration, TypeCheckEnvironment) [function] |
    typecheckVariableDeclarationExpressionResult(TypeCheckResult, List) [function] |
    typecheckVariableDeclarationSinglePass(List, TypeCheckEnvironment) [function]

  rule
    typecheckVariableDeclaration(AstVariableDeclaration1(TIL:List), TCE:TypeCheckEnvironment) =>
    typecheckVariableDeclarationSinglePass(TIL, TCE)

  rule
    typecheckVariableDeclaration(
      AstVariableDeclaration2(TIL:List, E:AstExpression),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckVariableDeclarationExpressionResult(
      typecheckExpression(E, getTypedIdentifierListTypeTuple(TIL), TCE),
      TIL
    )

  rule
    typecheckVariableDeclarationExpressionResult(TypeCheckResultError(S:String), TIL:List) =>
    TypeCheckResultError(S)

  rule
    typecheckVariableDeclarationExpressionResult(
      TypeCheckResultSuccess(TCE:TypeCheckEnvironment),
      TIL:List
    ) =>
    typecheckVariableDeclarationSinglePass(TIL, TCE)

  rule
    typecheckVariableDeclarationSinglePass(.List, TCE:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(TCE)

  rule
    typecheckVariableDeclarationSinglePass(
      ListItem(AstTypedIdentifier(I:Identifier, TN:TypeName)) TIL:List,
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultError("Variable is already defined.")
    requires lookupVariable(I, TCE) =/=K .Nothing

  rule
    typecheckVariableDeclarationSinglePass(
      ListItem(AstTypedIdentifier(I:Identifier, TN:TypeName)) TIL:List,
      TCE:TypeCheckEnvironment
    ) =>
    typecheckVariableDeclarationSinglePass(
      TIL,
      setVariable(I, VariableAttributes(TN, VariableAccessReadWrite), TCE)
    )
    requires lookupVariable(I, TCE) ==K .Nothing

  /**
   *
   * Type inference.
   *
   */

  /**
   * TypeInferenceResult
   */

  syntax TypeInferenceResult ::=
    TypeInferenceResultError(String) |
    TypeInferenceResultSuccess(Type)

  /**
   * inferTypeExpression
   */

  syntax TypeInferenceResult ::=
    inferTypeExpression(AstExpression, TypeCheckEnvironment) [function] |
    inferTypeExpressionFunctionArgumentsResult(TypeCheckResult, TypeTuple) [function] |
    inferTypeExpressionFunctionLookupResult(Maybe, List, TypeCheckEnvironment) [function] |
    inferTypeExpressionVariableLookupResult(Maybe) [function]

  rule
    inferTypeExpression(I:Identifier, TCE:TypeCheckEnvironment) =>
    inferTypeExpressionVariableLookupResult(lookupVariable(I, TCE))

  rule
    inferTypeExpressionVariableLookupResult(.Nothing) =>
    TypeInferenceResultError("Variable is undefined.")

  rule
    inferTypeExpressionVariableLookupResult(Just(VariableAttributes(_:Type, VariableAccessNone))) =>
    TypeInferenceResultError("Variable is not accesible.")

  rule
    inferTypeExpressionVariableLookupResult(
      Just(VariableAttributes(T:Type, VariableAccessReadWrite))
    ) =>
    TypeInferenceResultSuccess(TypeTuple(1, ListItem(T)))

  rule
    inferTypeExpression(AstTypedLiteral(_:Literal, TN:TypeName), TCE:TypeCheckEnvironment) =>
    TypeInferenceResultSuccess(TypeTuple(1, ListItem(TN)))

  rule
    inferTypeExpression(AstFunctionCall(I:Identifier, EL:List), TCE:TypeCheckEnvironment) =>
    inferTypeExpressionFunctionLookupResult(lookupFunction(I, TCE), EL, TCE)

  rule
    inferTypeExpressionFunctionLookupResult(.Nothing, EL:List, TCE:TypeCheckEnvironment) =>
    TypeInferenceResultError("Function is undefined.")

  rule
    inferTypeExpressionFunctionLookupResult(
      Just(FunctionAttributes(TypeFunction(TT1:TypeTuple, TT2:TypeTuple))),
      EL:List,
      TCE:TypeCheckEnvironment
    ) =>
    inferTypeExpressionFunctionArgumentsResult(typecheckFunctionArguments(EL, TT1, TCE), TT2)

  rule
    inferTypeExpressionFunctionArgumentsResult(TypeCheckResultError(S:String), _:TypeTuple) =>
    TypeInferenceResultError(S)

  rule
    inferTypeExpressionFunctionArgumentsResult(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TT:TypeTuple
    ) =>
    TypeInferenceResultSuccess(TT)

  /**
   * inferTypeIdentifierList
   */

  syntax TypeInferenceResult ::=
    inferTypeIdentifierList(List, TypeCheckEnvironment) [function] |
    inferTypeIdentifierListResults(TypeInferenceResult, TypeInferenceResult) [function]

  rule
    inferTypeIdentifierList(.List, _:TypeCheckEnvironment) =>
    TypeInferenceResultSuccess(makeTypeTuple())

  rule
    inferTypeIdentifierList(ListItem(I:Identifier) IL:List, TCE:TypeCheckEnvironment) =>
    inferTypeIdentifierListResults(inferTypeExpression(I, TCE), inferTypeIdentifierList(IL, TCE))

  rule
    inferTypeIdentifierListResults(
      TypeInferenceResultError(S:String),
      _:TypeInferenceResult
    ) =>
    TypeInferenceResultError(S)

  rule
    inferTypeIdentifierListResults(
      TypeInferenceResultSuccess(_:Type),
      TypeInferenceResultError(S:String)
    ) =>
    TypeInferenceResultError(S)

  rule
    inferTypeIdentifierListResults(
      TypeInferenceResultSuccess(T1:TypeTuple),
      TypeInferenceResultSuccess(T2:TypeTuple)
    ) =>
    TypeInferenceResultSuccess(mergeTypeTuples(T1, T2))

  /**
   *
   * Environment utility.
   *
   */

  /**
   * setVariable
   */

  syntax TypeCheckEnvironment ::=
    setVariable(Identifier, VariableAttributes, TypeCheckEnvironment) [function]

  rule
    setVariable(
      I:Identifier,
      VA:VariableAttributes,
      TypeCheckEnvironment(ListItem(VE:Map) VES:List, FES:List)
    ) =>
    TypeCheckEnvironment(ListItem(updateMap(VE, I |-> VA)) VES, FES)

  /**
   * setFunction
   */

  syntax TypeCheckEnvironment ::=
    setFunction(Identifier, FunctionAttributes, TypeCheckEnvironment) [function]

  rule
    setFunction(
      I:Identifier,
      FA:FunctionAttributes,
      TypeCheckEnvironment(VES:List, ListItem(FE:Map) FES:List)
    ) =>
    TypeCheckEnvironment(VES, ListItem(updateMap(FE, I |-> FA)) FES)

  /**
   * setBuiltInFunctions
   */

  syntax TypeCheckEnvironment ::=
    setBuiltInFunctions(TypeCheckEnvironment) [function] |
    setBuiltInFunctions2(List, TypeCheckEnvironment) [function]

  rule
    setBuiltInFunctions(TCE:TypeCheckEnvironment) =>
    setBuiltInFunctions2(
      makeBuiltInFunctionDescription(
        and, makeTypeTuple(bool, bool), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        not, makeTypeTuple(bool), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        or, makeTypeTuple(bool, bool), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        xor, makeTypeTuple(bool, bool), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        addmodu256, makeTypeTuple(u256, u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        addu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        andu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        byte, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        divs256, makeTypeTuple(s256, s256), makeTypeTuple(s256)
      )
      makeBuiltInFunctionDescription(
        divu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        equ256, makeTypeTuple(u256, u256), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        expu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        gts256, makeTypeTuple(s256, s256), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        gtu256, makeTypeTuple(u256, u256), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        iszerou256, makeTypeTuple(u256), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        lts256, makeTypeTuple(s256, s256), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        ltu256, makeTypeTuple(u256, u256), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        mods256, makeTypeTuple(s256, s256), makeTypeTuple(s256)
      )
      makeBuiltInFunctionDescription(
        modu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        mulmodu256, makeTypeTuple(u256, u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        mulu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        notu256, makeTypeTuple(u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        oru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        sars256, makeTypeTuple(s256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        shlu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        shru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        signextendu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        subu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        xoru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        mload, makeTypeTuple(u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        msize, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        mstore, makeTypeTuple(u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        mstore8, makeTypeTuple(u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        sload, makeTypeTuple(u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        sstore, makeTypeTuple(u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        abort, makeTypeTuple(), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        call, makeTypeTuple(u256, u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        callcode, makeTypeTuple(u256, u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        create, makeTypeTuple(u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        create2, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        delegatecall, makeTypeTuple(u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        log0, makeTypeTuple(u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        log1, makeTypeTuple(u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        log2, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        log3, makeTypeTuple(u256, u256, u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        log4, makeTypeTuple(u256, u256, u256, u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        return, makeTypeTuple(u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        revert, makeTypeTuple(u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        selfdestruct, makeTypeTuple(u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        balance, makeTypeTuple(u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        blockcoinbase, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        blockdifficulty, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        blockgaslimit, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        blockhash, makeTypeTuple(u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        blocknumber, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        blocktimestamp, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        calldatacopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        calldataload, makeTypeTuple(u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        calldatasize, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        caller, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        callvalue, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        codecopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        codesize, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        extcodecopy, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        extcodehash, makeTypeTuple(u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        extcodesize, makeTypeTuple(u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        gasleft, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        this, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        txgasprice, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        txorigin, makeTypeTuple(), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        combineu64tou256, makeTypeTuple(u64, u64, u64, u64), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        datacopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        discard, makeTypeTuple(bool), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        discardu256, makeTypeTuple(u256), makeTypeTuple()
      )
      makeBuiltInFunctionDescription(
        keccak256, makeTypeTuple(u256, u256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        splitu256tou64, makeTypeTuple(u256), makeTypeTuple(u64, u64, u64, u64)
      )
      makeBuiltInFunctionDescription(
        booltos256, makeTypeTuple(bool), makeTypeTuple(s256)
      )
      makeBuiltInFunctionDescription(
        booltou256, makeTypeTuple(bool), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        booltou32, makeTypeTuple(bool), makeTypeTuple(u32)
      )
      makeBuiltInFunctionDescription(
        booltou64, makeTypeTuple(bool), makeTypeTuple(u64)
      )
      makeBuiltInFunctionDescription(
        s256tobool, makeTypeTuple(s256), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        s256tou256, makeTypeTuple(s256), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        s256tou32, makeTypeTuple(s256), makeTypeTuple(u32)
      )
      makeBuiltInFunctionDescription(
        s256tou64, makeTypeTuple(s256), makeTypeTuple(u64)
      )
      makeBuiltInFunctionDescription(
        u256tobool, makeTypeTuple(u256), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        u256tos256, makeTypeTuple(u256), makeTypeTuple(s256)
      )
      makeBuiltInFunctionDescription(
        u256tou32, makeTypeTuple(u256), makeTypeTuple(u32)
      )
      makeBuiltInFunctionDescription(
        u256tou64, makeTypeTuple(u256), makeTypeTuple(u64)
      )
      makeBuiltInFunctionDescription(
        u32tobool, makeTypeTuple(u32), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        u32tos256, makeTypeTuple(u32), makeTypeTuple(s256)
      )
      makeBuiltInFunctionDescription(
        u32tou256, makeTypeTuple(u32), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        u32tou64, makeTypeTuple(u32), makeTypeTuple(u64)
      )
      makeBuiltInFunctionDescription(
        u64tobool, makeTypeTuple(u64), makeTypeTuple(bool)
      )
      makeBuiltInFunctionDescription(
        u64tos256, makeTypeTuple(u64), makeTypeTuple(s256)
      )
      makeBuiltInFunctionDescription(
        u64tou256, makeTypeTuple(u64), makeTypeTuple(u256)
      )
      makeBuiltInFunctionDescription(
        u64tou32, makeTypeTuple(u64), makeTypeTuple(u32)
      ),
      TCE
    )

  rule
    setBuiltInFunctions2(.List, TCE:TypeCheckEnvironment) =>
    TCE

  rule
    setBuiltInFunctions2(
      ListItem(
        BuiltInFunctionDescription(IBIF:IdentifierBuiltInFunction, T1:TypeTuple, T2:TypeTuple)
      ) L:List,
      TCE:TypeCheckEnvironment
    ) =>
    setBuiltInFunctions2(L, setFunction(IBIF, FunctionAttributes(TypeFunction(T1, T2)), TCE))

  /**
   * makeBuiltInFunctionDescription
   */

  syntax BuiltInFunctionDescription ::=
    BuiltInFunctionDescription(IdentifierBuiltInFunction, TypeTuple, TypeTuple)

  syntax List ::=
    makeBuiltInFunctionDescription(IdentifierBuiltInFunction, TypeTuple, TypeTuple) [function]

  rule
    makeBuiltInFunctionDescription(IBIF:IdentifierBuiltInFunction, T1:TypeTuple, T2:TypeTuple) =>
    ListItem(BuiltInFunctionDescription(IBIF, T1, T2))

  /**
   * lookupVariable
   */

  syntax Maybe ::=
    lookupVariable(Identifier, TypeCheckEnvironment) [function]

  rule
    lookupVariable(I:Identifier, TypeCheckEnvironment(.List, FES:List)) =>
    .Nothing

  rule
    lookupVariable(I:Identifier, TypeCheckEnvironment(ListItem(VE:Map) VES:List, FES:List)) =>
    lookupVariable(I, TypeCheckEnvironment(VES, FES))
    requires notBool(I in keys(VE))

  rule
    lookupVariable(I:Identifier, TypeCheckEnvironment(ListItem(VE:Map) VES:List, FES:List)) =>
    Just(VE[I])
    requires I in keys(VE)

  /**
   * lookupFunction
   */

  syntax Maybe ::=
    lookupFunction(Identifier, TypeCheckEnvironment) [function]

  rule
    lookupFunction(I:Identifier, TypeCheckEnvironment(VES:List, .List)) =>
    .Nothing

  rule
    lookupFunction(I:Identifier, TypeCheckEnvironment(VES:List, ListItem(FE:Map) FES:List)) =>
    lookupFunction(I, TypeCheckEnvironment(VES, FES))
    requires notBool(I in keys(FE))

  rule
    lookupFunction(I:Identifier, TypeCheckEnvironment(VES:List, ListItem(FE:Map) FES:List)) =>
    Just(FE[I])
    requires I in keys(FE)

  /**
   * popScope
   */

  syntax TypeCheckEnvironment ::=
    popScope(TypeCheckEnvironment) [function]

  rule
    popScope(TypeCheckEnvironment(ListItem(_:Map) VES:List, ListItem(_:Map) FES:List)) =>
    TypeCheckEnvironment(VES, FES)

  /**
   * pushScope
   */

  syntax TypeCheckEnvironment ::=
    pushScope(TypeCheckEnvironment) [function]

  rule
    pushScope(TypeCheckEnvironment(VES:List, FES:List)) =>
    TypeCheckEnvironment(ListItem(.Map) VES, ListItem(.Map) FES)

  /**
   * pushScopeWithRestrictedVariableAccess
   */

  syntax TypeCheckEnvironment ::=
    pushScopeWithRestrictedVariableAccess(TypeCheckEnvironment) [function]

  rule
    pushScopeWithRestrictedVariableAccess(TypeCheckEnvironment(VES:List, FES:List)) =>
    TypeCheckEnvironment(ListItem(.Map) restrictVariableAccess(VES), ListItem(.Map) FES)

  /**
   * restrictVariableAccess
   */

  syntax List ::=
    restrictVariableAccess(VariableEnvironmentStack:List) [function]

  syntax Map ::=
    restrictVariableAccess2(VariableEnvironment:Map, Set) [function] |
    restrictVariableAccess3(VariableEnvironment:Map, Identifier, VariableAttributes) [function]

  rule
    restrictVariableAccess(.List) =>
    .List

  rule
    restrictVariableAccess(ListItem(VE:Map) VES:List) =>
    ListItem(restrictVariableAccess2(VE, keys(VE))) restrictVariableAccess(VES)

  rule
    restrictVariableAccess2(VE:Map, .Set) =>
    VE

  rule
    restrictVariableAccess2(VE:Map, SetItem(I:Identifier) IS:Set) =>
    restrictVariableAccess2(restrictVariableAccess3(VE, I, { VE[I] }:>VariableAttributes), IS)

  rule
    restrictVariableAccess3(VE:Map, I:Identifier, VariableAttributes(T:Type, _:VariableAccess)) =>
    updateMap(VE, I |-> VariableAttributes(T, VariableAccessNone))

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

  /**
   * mergeTypeTuples
   */

  syntax TypeTuple ::=
    mergeTypeTuples(TypeTuple, TypeTuple) [function]

  rule
    mergeTypeTuples(TypeTuple(I1:Int, L1:List), TypeTuple(I2:Int, L2:List)) =>
    TypeTuple(I1 +Int I2, L1 L2)

  /**
   * getEmptyTypeCheckEnvironment
   */

  syntax TypeCheckEnvironment ::=
    getEmptyTypeCheckEnvironment() [function]

  rule
    getEmptyTypeCheckEnvironment() =>
    TypeCheckEnvironment(.List, .List)

endmodule

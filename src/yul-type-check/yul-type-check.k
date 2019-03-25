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
    typecheckAssignment(`AstAssignment`(IL:List, E:AstExpression), TCE:TypeCheckEnvironment) =>
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
    typecheckBlock(`AstBlock`(SS:List), TCE:TypeCheckEnvironment) =>
    typecheckBlockStatementSequenceResult(typecheckStatementSequence(SS, pushScope(TCE)))

  rule
    typecheckBlockStatementSequenceResult(TypeCheckResultError(S:String)) =>
    TypeCheckResultError(S)

  rule
    typecheckBlockStatementSequenceResult(TypeCheckResultSuccess(TCE:TypeCheckEnvironment)) =>
    TypeCheckResultSuccess(popScope(TCE))

  /**
   * typecheckDebug
   */

  syntax TypeCheckResult ::=
    typecheckDebug(AstDebug, TypeCheckEnvironment) [function] |
    typecheckDebugExpressionResult(TypeInferenceResult, TypeCheckEnvironment) [function]

  rule
    typecheckDebug(`AstDebug`(I:Identifier), TCE) =>
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
      `AstFor`(B1:AstBlock, E:AstExpression, B2:AstBlock, B3:AstBlock),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckForBlocks(B1, E, B2, B3, TCE)

  rule
    typecheckForBlocks(
      `AstBlock`(SS1:List),
      E:AstExpression,
      `AstBlock`(SS2:List),
      `AstBlock`(SS3:List),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckForBlocksResults(
      typecheckBlock(`AstBlock`(SS1 ListItem(`AstIf`(E, `AstBlock`(.List)))), TCE),
      typecheckBlock(`AstBlock`(SS1 SS2), TCE),
      typecheckBlock(`AstBlock`(SS1 SS3), TCE),
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
      `AstFunctionDefinition`(_:Identifier, TIL1:List, TIL2:List, B:AstBlock),
      TCE:TypeCheckEnvironment
    ) =>
    typecheckFunctionDefinitionResults(
      typecheckBlock(
        `AstBlock`(
          ListItem(`AstVariableDeclaration1`(TIL1))
          ListItem(`AstVariableDeclaration1`(TIL2))
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
    typecheckIf(`AstIf`(E:AstExpression, B:AstBlock), TCE:TypeCheckEnvironment) =>
    typecheckIfExpressionResult(
      typecheckExpression(E, TypeTuple(1, ListItem(#token("bool", "TypeNameBuiltIn"))), TCE),
      B
    )

  rule
    typecheckIfExpressionResult(TypeCheckResultError(S:String), B:AstBlock) =>
    TypeCheckResultError(S)

  rule
    typecheckIfExpressionResult(TypeCheckResultSuccess(TCE:TypeCheckEnvironment), B:AstBlock) =>
    typecheckBlock(B, TCE)

  /**
   * typecheckProgram
   */

  syntax TypeCheckResult ::=
    typecheckProgram(AstProgram, TypeCheckEnvironment) [function]

  rule
    typecheckProgram(B:AstBlock, TCE:TypeCheckEnvironment) =>
    typecheckBlock(B, TCE)

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
    typecheckExpression(E, getEmptyTypeTuple(), TCE)

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
    typecheckSwitch(`AstSwitch1`(E:AstExpression, CS:List), TCE:TypeCheckEnvironment) =>
    typecheckSwitch(`AstSwitch2`(E, CS, `AstDefault`(`AstBlock`(.List))), TCE)

  rule
    typecheckSwitch(
      `AstSwitch2`(E:AstExpression, CS:List, D:AstDefault),
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
      ListItem(`AstCase`(TL:AstTypedLiteral, B:AstBlock)) CS:List,
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
      `AstDefault`(B:AstBlock),
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
    typecheckVariableDeclaration(`AstVariableDeclaration1`(TIL:List), TCE:TypeCheckEnvironment) =>
    typecheckVariableDeclarationSinglePass(TIL, TCE)

  rule
    typecheckVariableDeclaration(
      `AstVariableDeclaration2`(TIL:List, E:AstExpression),
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
      ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List,
      TCE:TypeCheckEnvironment
    ) =>
    TypeCheckResultError("Variable is already defined.")
    requires lookupVariable(I, TCE) =/=K .Nothing

  rule
    typecheckVariableDeclarationSinglePass(
      ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List,
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
    inferTypeExpression(`AstTypedLiteral`(_:Literal, TN:TypeName), TCE:TypeCheckEnvironment) =>
    TypeInferenceResultSuccess(TypeTuple(1, ListItem(TN)))

  rule
    inferTypeExpression(`AstFunctionCall`(I:Identifier, EL:List), TCE:TypeCheckEnvironment) =>
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
    TypeInferenceResultSuccess(getEmptyTypeTuple())

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
      `AstFunctionDefinition`(I:Identifier, TIL1:List, TIL2:List, B:AstBlock)
    ) =>
    I

  /**
   * getFunctionDefinitionType
   */

  syntax Type ::=
    getFunctionDefinitionType(AstFunctionDefinition) [function]

  rule
    getFunctionDefinitionType(
      `AstFunctionDefinition`(I:Identifier, TIL1:List, TIL2:List, B:AstBlock)
    ) =>
    TypeFunction(getTypedIdentifierListTypeTuple(TIL1), getTypedIdentifierListTypeTuple(TIL2))

  /**
   * getEmptyTypeTuple
   */

  syntax TypeTuple ::=
    getEmptyTypeTuple() [function]

  rule
    getEmptyTypeTuple() =>
    TypeTuple(0, .List)

  /**
   * getTypedIdentifierListTypeTuple
   */

  syntax TypeTuple ::=
    getTypedIdentifierListTypeTuple(List) [function]

  rule
    getTypedIdentifierListTypeTuple(.List) =>
    getEmptyTypeTuple()

  rule
    getTypedIdentifierListTypeTuple(
      ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List
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

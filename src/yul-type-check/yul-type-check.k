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

  syntax Bool ::=
    isAstFunctionDefinition(AstStatement)

  syntax Type ::=
    ".Type" |
    TypeFunction |
    TypeName |
    TypeTuple

  syntax TypeFunction ::=
    TypeFunction(TypeTuple, TypeTuple)

  syntax TypeTuple ::=
    TypeTuple(Int, List)

  /**
   * getEmptyTypeTuple
   */

  syntax TypeTuple ::=
    getEmptyTypeTuple() [function]

  rule
    getEmptyTypeTuple() =>
    TypeTuple(0, .List)

  /**
   * getFunctionDefinitionName
   */

  syntax Identifier ::=
    getFunctionDefinitionName(AstFunctionDefinition) [function]

  rule
    getFunctionDefinitionName(`AstFunctionDefinition`(
      I:Identifier, TIL1:List, TIL2:List, B:AstBlock
    )) =>
    I

  /**
   * getFunctionDefinitionType
   */

  syntax Type ::=
    getFunctionDefinitionType(AstFunctionDefinition) [function]

  rule
    getFunctionDefinitionType(`AstFunctionDefinition`(
      I:Identifier, TIL1:List, TIL2:List, B:AstBlock
    )) =>
    TypeFunction(getTypedIdentifierListTypeTuple(TIL1), getTypedIdentifierListTypeTuple(TIL2))

  /**
   * getTypedIdentifierListTypeTuple
   */

  syntax TypeTuple ::=
    getTypedIdentifierListTypeTuple(List) [function] |
    mergeTypeTuples(TypeTuple, TypeTuple) [function]

  rule
    getTypedIdentifierListTypeTuple(.List) =>
    getEmptyTypeTuple()
  
  rule
    getTypedIdentifierListTypeTuple(
      ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List
    ) =>
    mergeTypeTuples(TypeTuple(1, ListItem(TN)), getTypedIdentifierListTypeTuple(TIL))

  rule
    mergeTypeTuples(TypeTuple(I1:Int, L1:List), TypeTuple(I2:Int, L2:List)) =>
    TypeTuple(I1 +Int I2, L1 L2)

  /**
   * TypeCheckEnvironment
   */

  syntax TypeCheckEnvironment ::=
    TypeCheckEnvironment(List, List)

  syntax TypeCheckEnvironment ::=
    getEmptyTypeCheckEnvironment() [function]

  rule getEmptyTypeCheckEnvironment()
    => TypeCheckEnvironment(.List, .List)

  /**
   * TypeCheckResult
   */

  syntax TypeCheckResult ::=
    TypeCheckResultError(String) |
    TypeCheckResultSuccess(TypeCheckEnvironment)

  /**
   * typecheckProgram
   */

  syntax TypeCheckResult ::=
    typecheckProgram(AstProgram, TypeCheckEnvironment) [function]

  rule
    typecheckProgram(B:AstBlock, E:TypeCheckEnvironment) =>
    typecheckBlock(B, E)

  /**
   * typecheckBlock
   */

  syntax TypeCheckResult ::=
    typecheckBlock(AstBlock, TypeCheckEnvironment) [function] |
    typecheckBlockStatementSequenceResult(TypeCheckResult) [function]

  rule
    typecheckBlock(`AstBlock`(SS:List), E:TypeCheckEnvironment) =>
    typecheckBlockStatementSequenceResult(typecheckStatementSequence(SS, pushScope(E)))

  rule
    typecheckBlockStatementSequenceResult(TypeCheckResultError(S:String)) =>
    TypeCheckResultError(S)

  rule
    typecheckBlockStatementSequenceResult(TypeCheckResultSuccess(E:TypeCheckEnvironment)) =>
    TypeCheckResultSuccess(popScope(E))

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
    typecheckStatementSequence(SS:List, E:TypeCheckEnvironment) =>
    typecheckStatementSequenceFirstPassResult(typecheckStatementSequenceFirstPass(SS, E), SS)

  rule
    typecheckStatementSequenceFirstPass(.List, E:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(E)

  rule
    typecheckStatementSequenceFirstPass(
      ListItem(S:AstStatement) SS:List,
      E:TypeCheckEnvironment
    ) =>
    typecheckStatementSequenceFirstPass(SS, E)
    requires notBool(isAstFunctionDefinition(S))

  rule
    typecheckStatementSequenceFirstPass(
      ListItem(FD:AstFunctionDefinition) SS:List,
      E:TypeCheckEnvironment
    ) =>
    typecheckStatementSequenceFirstPass(
      SS,
      declareFunction(getFunctionDefinitionName(FD), getFunctionDefinitionType(FD), E)
    )
    requires lookupFunction(getFunctionDefinitionName(FD), E) ==K .List

  rule
    typecheckStatementSequenceFirstPass(
      ListItem(FD:AstFunctionDefinition) SS:List,
      E:TypeCheckEnvironment
    ) =>
    TypeCheckResultError("Function is already defined.")
    requires lookupFunction(getFunctionDefinitionName(FD), E) =/=K .List

  rule
    typecheckStatementSequenceFirstPassResult(TypeCheckResultError(S:String), SS:List) =>
    TypeCheckResultError(S)

  rule
    typecheckStatementSequenceFirstPassResult(
      TypeCheckResultSuccess(E:TypeCheckEnvironment),
      SS:List
    ) =>
    typecheckStatementSequenceSecondPassResult(typecheckStatementSequenceSecondPass(SS, E))

  rule
    typecheckStatementSequenceSecondPass(.List, E:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(E)

  rule
    typecheckStatementSequenceSecondPass(
      ListItem(S:AstStatement) SS:List,
      E:TypeCheckEnvironment
    ) =>
    typecheckStatementSequenceStatementResult(typecheckStatement(S, E), SS)

  rule
    typecheckStatementSequenceStatementResult(TypeCheckResultError(S:String), SS:List) =>
    TypeCheckResultError(S)

  rule
    typecheckStatementSequenceStatementResult(
      TypeCheckResultSuccess(E:TypeCheckEnvironment),
      SS:List
    ) =>
    typecheckStatementSequenceSecondPass(SS, E)

  rule
    typecheckStatementSequenceSecondPassResult(TypeCheckResultError(S:String)) =>
    TypeCheckResultError(S)

  rule
    typecheckStatementSequenceSecondPassResult(TypeCheckResultSuccess(E:TypeCheckEnvironment)) =>
    TypeCheckResultSuccess(E)

  /**
   * typecheckStatement
   */
  syntax TypeCheckResult ::=
    typecheckStatement(AstStatement, TypeCheckEnvironment) [function]

  rule
    typecheckStatement(VD:AstVariableDeclaration, E:TypeCheckEnvironment) =>
    typecheckVariableDeclaration(VD, E)

  rule
    typecheckStatement(FD:AstFunctionDefinition, E:TypeCheckEnvironment) =>
    typecheckFunctionDefinition(FD, E)

  /**
   * typecheckVariableDeclaration
   */

  syntax TypeCheckResult ::=
    typecheckVariableDeclaration(AstVariableDeclaration, TypeCheckEnvironment) [function] |
    typecheckVariableDeclarationExpressionResult(TypeCheckResult, List) [function] |
    typecheckVariableDeclarationSinglePass(List, TypeCheckEnvironment) [function] |
    typecheckVariableDeclarationSinglePassResult(TypeCheckResult) [function]

  rule
    typecheckVariableDeclaration(`AstVariableDeclaration1`(TIL:List), E:TypeCheckEnvironment) =>
    typecheckVariableDeclarationSinglePassResult(typecheckVariableDeclarationSinglePass(TIL, E))

  rule
    typecheckVariableDeclaration(
      `AstVariableDeclaration2`(TIL:List, Ex:AstExpression),
      En:TypeCheckEnvironment
    ) =>
    typecheckVariableDeclarationExpressionResult(
      typecheckExpression(Ex, getTypedIdentifierListTypeTuple(TIL), En),
      TIL
    )

  rule
    typecheckVariableDeclarationExpressionResult(TypeCheckResultError(S:String), TIL:List) =>
    TypeCheckResultError(S)

  rule
    typecheckVariableDeclarationExpressionResult(
      TypeCheckResultSuccess(E:TypeCheckEnvironment),
      TIL:List
    ) =>
    typecheckVariableDeclarationSinglePassResult(typecheckVariableDeclarationSinglePass(TIL, E))

  rule
    typecheckVariableDeclarationSinglePass(.List, E:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(E)

  rule
    typecheckVariableDeclarationSinglePass(
      ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List,
      E:TypeCheckEnvironment
    ) =>
    TypeCheckResultError("Variable is already defined.")
    requires lookupVariable(I, E) =/=K .List

  rule
    typecheckVariableDeclarationSinglePass(
      ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List,
      E:TypeCheckEnvironment
    ) =>
    typecheckVariableDeclarationSinglePass(TIL, declareVariable(I, TN, E))
    requires lookupVariable(I, E) ==K .List

  rule
    typecheckVariableDeclarationSinglePassResult(TypeCheckResultError(S:String)) =>
    TypeCheckResultError(S)

  rule
    typecheckVariableDeclarationSinglePassResult(TypeCheckResultSuccess(E:TypeCheckEnvironment)) =>
    TypeCheckResultSuccess(E)

  /**
   * typecheckFunctionDefinition
   */

  syntax TypeCheckResult ::=
    typecheckFunctionDefinition(AstFunctionDefinition, TypeCheckEnvironment) [function] |
    typecheckFunctionDefinitionResults(
      TypeCheckResult,
      TypeCheckResult,
      TypeCheckEnvironment
    ) [function]
  
  rule
    typecheckFunctionDefinition(
      `AstFunctionDefinition`(_:Identifier, TIL1:List, TIL2:List, `AstBlock`(SS:List)),
      E:TypeCheckEnvironment
    ) =>
    typecheckFunctionDefinitionResults(
      typecheckBlock(
        `AstBlock`(
          ListItem(`AstVariableDeclaration1`(TIL1)) ListItem(`AstVariableDeclaration1`(TIL2))
        ),
        E
      ),
      typecheckBlock(
        `AstBlock`(
          ListItem(`AstVariableDeclaration1`(TIL1)) ListItem(`AstVariableDeclaration1`(TIL2)) SS
        ),
        clearScopeVariables(E)
      ),
      E
    )

  rule
    typecheckFunctionDefinitionResults(
      TypeCheckResultError(S:String),
      _:TypeCheckResult,
      _:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckFunctionDefinitionResults(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultError(S:String),
      _:TypeCheckEnvironment
    ) =>
    TypeCheckResultError(S)

  rule
    typecheckFunctionDefinitionResults(
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      TypeCheckResultSuccess(_:TypeCheckEnvironment),
      E:TypeCheckEnvironment
    ) =>
    TypeCheckResultSuccess(E)

  /**
   * typecheckExpression
   */

  syntax TypeCheckResult ::=
    typecheckExpression(AstExpression, Type, TypeCheckEnvironment) [function] |
    typecheckExpressionInferResult(TypeInferenceResult, Type, TypeCheckEnvironment) [function]

  rule
    typecheckExpression(Ex:AstExpression, T:Type, En:TypeCheckEnvironment) =>
    typecheckExpressionInferResult(inferTypeExpression(Ex, En), T, En)

  rule
    typecheckExpressionInferResult(TypeInferenceResultError(S), T:Type, E:TypeCheckEnvironment) =>
    TypeCheckResultError(S)

  rule
    typecheckExpressionInferResult(
      TypeInferenceResultSuccess(T1:Type),
      T2:Type,
      E:TypeCheckEnvironment
    ) =>
    TypeCheckResultError("Expression has wrong type.")
    requires T1 =/=K T2

  rule
    typecheckExpressionInferResult(
      TypeInferenceResultSuccess(T1:Type),
      T2:Type,
      E:TypeCheckEnvironment
    ) =>
    TypeCheckResultSuccess(E)
    requires T1 ==K T2

  /**
   * inferTypeExpression
   */

  syntax TypeInferenceResult ::=
    TypeInferenceResultError(String) |
    TypeInferenceResultSuccess(Type)

  syntax TypeInferenceResult ::=
    inferTypeExpression(AstExpression, TypeCheckEnvironment) [function] |
    inferTypeExpressionFunctionArgumentsResult(TypeCheckResult, TypeTuple) [function] |
    inferTypeExpressionFunctionLookupResult(List, List, TypeCheckEnvironment) [function] |
    inferTypeExpressionVariableLookupResult(List) [function]

  rule
    inferTypeExpression(I:Identifier, E:TypeCheckEnvironment) =>
    inferTypeExpressionVariableLookupResult(lookupVariable(I, E))
    
  rule
    inferTypeExpressionVariableLookupResult(.List) =>
    TypeInferenceResultError("Variable is undefined.")

  rule
    inferTypeExpressionVariableLookupResult(ListItem(T:Type)) =>
    TypeInferenceResultSuccess(TypeTuple(1, ListItem(T)))

  rule
    inferTypeExpression(`AstTypedLiteral`(_:Literal, TN:TypeName), E:TypeCheckEnvironment) =>
    TypeInferenceResultSuccess(TypeTuple(1, ListItem(TN)))

  rule
    inferTypeExpression(`AstFunctionCall`(I:Identifier, EL:List), E:TypeCheckEnvironment) =>
    inferTypeExpressionFunctionLookupResult(lookupFunction(I, E), EL, E)
  
  rule
    inferTypeExpressionFunctionLookupResult(.List, EL:List, E:TypeCheckEnvironment) =>
    TypeInferenceResultError("Function is undefined.")

  rule
    inferTypeExpressionFunctionLookupResult(
      ListItem(TypeFunction(TT1:TypeTuple, TT2:TypeTuple)),
      EL:List,
      E:TypeCheckEnvironment
    ) =>
    inferTypeExpressionFunctionArgumentsResult(typecheckFunctionArguments(EL, TT1, E), TT2)

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
    typecheckFunctionArguments(.List, TypeTuple(0, .List), E:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(E)

  rule
    typecheckFunctionArguments(
      ListItem(Ex:AstExpression) EL:List,
      TypeTuple(I:Int, ListItem(T:Type) TL:List),
      En:TypeCheckEnvironment
    ) =>
    typecheckFunctionArgumentsExpressionResult(
      typecheckExpression(Ex, TypeTuple(1, ListItem(T)), En),
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
      TypeCheckResultSuccess(E:TypeCheckEnvironment),
      EL:List,
      TT:TypeTuple
    ) =>
    typecheckFunctionArguments(EL, TT, E)

  /**
   * declareVariable
   */

  syntax TypeCheckEnvironment ::=
    declareVariable(Identifier, Type, TypeCheckEnvironment) [function]

  rule
    declareVariable(
      I:Identifier,
      T:Type,
      TypeCheckEnvironment(ListItem(VM:Map) VMS:List, FMS:List)
    ) =>
    TypeCheckEnvironment(ListItem(updateMap(VM, I |-> T)) VMS, FMS)

  /**
   * declareFunction
   */

  syntax TypeCheckEnvironment ::=
    declareFunction(Identifier, Type, TypeCheckEnvironment) [function]

  rule
    declareFunction(
      I:Identifier,
      T:Type,
      TypeCheckEnvironment(VMS:List, ListItem(FM:Map) FMS:List)
    ) =>
    TypeCheckEnvironment(VMS, ListItem(updateMap(FM, I |-> T)) FMS)

  /**
   * lookupVariable
   */

  syntax List ::=
    lookupVariable(Identifier, TypeCheckEnvironment) [function]

  rule
    lookupVariable(I:Identifier, TypeCheckEnvironment(.List, FMS:List)) =>
    .List

  rule
    lookupVariable(I:Identifier, TypeCheckEnvironment(ListItem(VM:Map) VMS:List, FMS:List)) =>
    lookupVariable(I, TypeCheckEnvironment(VMS, FMS))
    requires notBool(I in keys(VM))

  rule
    lookupVariable(I:Identifier, TypeCheckEnvironment(ListItem(VM:Map) VMS:List, FMS:List)) =>
    ListItem(VM[I])
    requires I in keys(VM)

  /**
   * lookupFunction
   */

  syntax List ::=
    lookupFunction(Identifier, TypeCheckEnvironment) [function]

  rule
    lookupFunction(I:Identifier, TypeCheckEnvironment(VMS:List, .List)) =>
    .List

  rule
    lookupFunction(I:Identifier, TypeCheckEnvironment(VMS:List, ListItem(FM:Map) FMS:List)) =>
    lookupFunction(I, TypeCheckEnvironment(VMS, FMS))
    requires notBool(I in keys(FM))

  rule
    lookupFunction(I:Identifier, TypeCheckEnvironment(VMS:List, ListItem(FM:Map) FMS:List)) =>
    ListItem(FM[I])
    requires I in keys(FM)

  /**
   * clearScopeVariables
   */

  syntax TypeCheckEnvironment ::=
    clearScopeVariables(TypeCheckEnvironment) [function]

  rule
    clearScopeVariables(TypeCheckEnvironment(_:List, FMS:List)) =>
    TypeCheckEnvironment(.List, FMS)

  /**
   * popScope
   */

  syntax TypeCheckEnvironment ::=
    popScope(TypeCheckEnvironment) [function]

  rule
    popScope(TypeCheckEnvironment(ListItem(_:Map) VMS:List, ListItem(_:Map) FMS:List)) =>
    TypeCheckEnvironment(VMS, FMS)

  /**
   * pushScope
   */

  syntax TypeCheckEnvironment ::=
    pushScope(TypeCheckEnvironment) [function]

  rule
    pushScope(TypeCheckEnvironment(VMS:List, FMS:List)) =>
    TypeCheckEnvironment(ListItem(.Map) VMS, ListItem(.Map) FMS)

endmodule

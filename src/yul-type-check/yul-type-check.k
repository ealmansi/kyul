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
    getTypedIdentifierListTypeTuple(ListItem(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) TIL:List) =>
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
    TypeCheckResultSuccess(E, .Type)

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
      declareFunction(
        getFunctionDefinitionName(FD),
        getFunctionDefinitionType(FD),
        E
      )
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

  rule typecheckStatement(VD:AstVariableDeclaration, E:TypeCheckEnvironment)
    => typecheckVariableDeclaration(VD, E)

  /**
   * typecheckVariableDeclaration
   */
  syntax TypeCheckResult ::=
    typecheckVariableDeclaration(AstVariableDeclaration, TypeCheckEnvironment) [function] |
    typecheckVariableDeclarationSinglePass(List, TypeCheckEnvironment) [function] |
    typecheckVariableDeclarationResult(TypeCheckResult) [function]

  rule
    typecheckVariableDeclaration(`AstVariableDeclaration1`(TIL:List), E:TypeCheckEnvironment) =>
    typecheckVariableDeclarationResult(typecheckVariableDeclarationSinglePass(TIL, E))

  rule
    typecheckVariableDeclaration(
      `AstVariableDeclaration2`(TIL:List, Ex:AstExpression),
      En:TypeCheckEnvironment
    ) =>
    typecheckVariableDeclarationExpressionResult(typecheckExpression(Ex, En))

  rule
    typecheckVariableDeclarationExpressionResult(TypeCheckResultError(S:String))
    => TypeCheckResultError(S)

  rule
    typecheckVariableDeclarationExpressionResult(
      TypeCheckResultSuccess(E:TypeCheckEnvironment)
    )
    => TypeCheckResultSuccess(E, .Type)

  rule
    typecheckVariableDeclarationSinglePass(.List, E:TypeCheckEnvironment) =>
    TypeCheckResultSuccess(E, .Type)

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
    )
    => typecheckVariableDeclarationSinglePass(TIL, declareVariable(I, TN, E))
    requires lookupVariable(I, E) ==K .List

  rule
    typecheckVariableDeclarationResult(TypeCheckResultError(S:String))
    => TypeCheckResultError(S)

  rule
    typecheckVariableDeclarationResult(TypeCheckResultSuccess(E:TypeCheckEnvironment))
    => TypeCheckResultSuccess(E, .Type)

  /**
   * declareVariable
   */

  syntax TypeCheckEnvironment ::=
    declareVariable(Identifier, Type, TypeCheckEnvironment) [function]

  rule declareVariable(I:Identifier, T:Type, TypeCheckEnvironment(ListItem(VM:Map) VMS:List, FMS:List))
    => TypeCheckEnvironment(ListItem(updateMap(VM, I |-> T)) VMS, FMS)

  /**
   * declareFunction
   */

  syntax TypeCheckEnvironment ::=
    declareFunction(Identifier, Type, TypeCheckEnvironment) [function]

  rule declareFunction(I:Identifier, T:Type, TypeCheckEnvironment(VMS:List, ListItem(FM:Map) FMS:List))
    => TypeCheckEnvironment(VMS, ListItem(updateMap(FM, I |-> T)) FMS)

  /**
   * lookupVariable
   */

  syntax List ::=
    lookupVariable(Identifier, TypeCheckEnvironment) [function]

  rule lookupVariable(I:Identifier, TypeCheckEnvironment(.List, FMS:List))
    => .List

  rule lookupVariable(I:Identifier, TypeCheckEnvironment(ListItem(VM:Map) VMS:List, FMS:List))
    => lookupVariable(I, TypeCheckEnvironment(VMS, FMS))
    requires notBool(I in keys(VM))

  rule lookupVariable(I:Identifier, TypeCheckEnvironment(ListItem(VM:Map) VMS:List, FMS:List))
    => ListItem(VM[I])
    requires I in keys(VM)

  /**
   * lookupFunction
   */

  syntax List ::=
    lookupFunction(Identifier, TypeCheckEnvironment) [function]

  rule lookupFunction(I:Identifier, TypeCheckEnvironment(VMS:List, .List))
    => .List

  rule lookupFunction(I:Identifier, TypeCheckEnvironment(VMS:List, ListItem(FM:Map) FMS:List))
    => lookupFunction(I, TypeCheckEnvironment(VMS, FMS))
    requires notBool(I in keys(FM))

  rule lookupFunction(I:Identifier, TypeCheckEnvironment(VMS:List, ListItem(FM:Map) FMS:List))
    => ListItem(FM[I])
    requires I in keys(FM)

  /**
   * popScope
   */

  syntax TypeCheckEnvironment ::=
    popScope(TypeCheckEnvironment) [function]

  rule popScope(TypeCheckEnvironment(ListItem(_:Map) VMS:List, ListItem(_:Map) FMS:List))
    => TypeCheckEnvironment(VMS, FMS)

  /**
   * pushScope
   */

  syntax TypeCheckEnvironment ::=
    pushScope(TypeCheckEnvironment) [function]

  rule pushScope(TypeCheckEnvironment(VMS:List, FMS:List))
    => TypeCheckEnvironment(ListItem(.Map) VMS, ListItem(.Map) FMS)

  // rule typecheckProgram(O:AstObject, E:TypeCheckEnvironment)
  //   => TypeCheckResultSuccess(E, .Type)

  
  // syntax KItem ::=
  //   checkNotDefinedTypedIdentifier(AstTypedIdentifier) |
  //   checkTypeBlock(AstBlock) |
  //   checkTypeExpression(AstExpression, Type) |
  //   checkTypeExpressionCool(AstExpression, Type) |
  //   checkTypeProgram(AstProgram) |
  //   checkTypeStatement(AstStatement) |
  //   checkTypeStatementSequence(List) |
  //   checkTypeStatementSequenceFirstPass(List) |
  //   checkTypeStatementSequenceSecondPass(List) |
  //   checkTypeTypedIdentifierList(List) |
  //   inferTypeExpression(AstExpression) |
  //   updateEnvironmentFunctionDefinition(AstStatement) |
  //   updateEnvironmentTypedIdentifier(AstTypedIdentifier)

  
  // rule
  //   typecheckProgram(B:AstBlock, E:Environment) =>
  //   typecheckBlock(B, E)
  
  // rule
  //   typecheckBlock(`AstBlock`(SS:List), E:Environment) =>
  //   typecheckStatementSequence(SS, addFunctions(SS, E))

  // rule
  //   typecheckStatementSequence(.List, E) =>
  //   OK(E)

  // rule
  //   typecheckStatementSequence(ListItem(S) SS, E) =>
  //   typecheckStatementSequence'(typecheckStatement(S, E), SS)

  // rule
  //   typecheckStatementSequence'(Error, SS) =>
  //   Error

  // rule
  //   typecheckStatementSequence'(OK(E), SS) =>
  //   typecheckStatementSequence(SS, E)

  // syntax KItem ::=
  //   "#TypeCheckError" String

  // rule
  //   <k>
  //     #TypeCheckError S:String ~> _:K =>
  //     .
  //   </k>
  //   <cStdout> ... .List => ListItem(S) </cStdout>

  
  
  // rule
  //   <k>
  //     checkTypeProgram(B:AstBlock) =>
  //     checkTypeBlock(B)
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeBlock(`AstBlock`(SS:List)) =>
  //     checkTypeStatementSequence(SS)
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeStatementSequence(SS:List) =>
  //     (
  //       checkTypeStatementSequenceFirstPass(SS) ~>
  //       checkTypeStatementSequenceSecondPass(SS)
  //     )
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeStatementSequenceFirstPass(.List) =>
  //     .
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeStatementSequenceFirstPass(ListItem(S:AstStatement) SS:List) =>
  //     checkTypeStatementSequenceFirstPass(SS)
  //     ...
  //   </k>
  //   requires notBool(isAstFunctionDefinition(S))

  // rule
  //   <k>
  //     checkTypeStatementSequenceFirstPass(ListItem(FD:AstFunctionDefinition) SS:List) =>
  //     (
  //       updateEnvironmentFunctionDefinition(FD) ~>
  //       checkTypeStatementSequenceFirstPass(SS)
  //     )
  //     ...
  //   </k>

  // rule
  //   <k>
  //     updateEnvironmentFunctionDefinition(FD:AstFunctionDefinition) =>
  //     .
  //     ...
  //   </k>
  //   <cSignature>
  //     ...
  //     (
  //       .Map =>
  //       getFunctionDefinitionName(FD) |-> getFunctionDefinitionType(FD)
  //     )
  //   </cSignature>

  // rule
  //   <k>
  //     checkTypeStatementSequenceSecondPass(.List) =>
  //     .
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeStatementSequenceSecondPass(ListItem(S:AstStatement) SS:List) =>
  //     (
  //       checkTypeStatement(S) ~>
  //       checkTypeStatementSequenceSecondPass(SS)
  //     )
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeStatement(FD:AstFunctionDefinition) =>
  //     .
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeStatement(`AstVariableDeclaration1`(TIL:List)) =>
  //     checkTypeTypedIdentifierList(TIL)
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeStatement(`AstVariableDeclaration2`(TIL:List, E:AstExpression)) =>
  //     (
  //       checkTypeExpression(E, getTypedIdentifierListTypeTuple(TIL)) ~>
  //       checkTypeTypedIdentifierList(TIL)
  //     )
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeTypedIdentifierList(.List) =>
  //     .
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkTypeTypedIdentifierList(ListItem(TI:AstTypedIdentifier) TIL:List) =>
  //     (
  //       checkNotDefinedTypedIdentifier(TI) ~>
  //       updateEnvironmentTypedIdentifier(TI) ~>
  //       checkTypeTypedIdentifierList(TIL)
  //     )
  //     ...
  //   </k>

  // rule
  //   <k>
  //     checkNotDefinedTypedIdentifier(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) =>
  //     #TypeCheckError "Identifier is already defined.\n"
  //     ...
  //   </k>
  //   <cContext>
  //     C:Map
  //   </cContext>
  //   requires I in keys(C)

  // rule
  //   <k>
  //     checkNotDefinedTypedIdentifier(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) =>
  //     .
  //     ...
  //   </k>
  //   <cContext>
  //     C:Map
  //   </cContext>
  //   requires notBool(I in keys(C))

  // rule
  //   <k>
  //     updateEnvironmentTypedIdentifier(`AstTypedIdentifier`(I:Identifier, TN:TypeName)) =>
  //     .
  //     ...
  //   </k>
  //   <cContext>
  //     ...
  //     (
  //       .Map =>
  //       I |-> TN
  //     )
  //   </cContext>

  // rule
  //   <k>
  //     checkTypeExpression(E:AstExpression, T:Type) =>
  //     inferTypeExpression(E) ~> checkTypeExpressionCool(E, T)
  //     ...
  //   </k>

  // rule
  //   <k>
  //     T1:Type ~> checkTypeExpressionCool(E:AstExpression, T2:Type) =>
  //     .
  //     ...
  //   </k>
  //   requires T1 ==K T2

  // rule
  //   <k>
  //     T1:Type ~> checkTypeExpressionCool(E:AstExpression, T2:Type) =>
  //     #TypeCheckError "Expression has wrong type.\n"
  //     ...
  //   </k>
  //   requires T1 =/=K T2

  // rule
  //   <k>
  //     inferTypeExpression(`AstTypedLiteral`(_:Literal, TN:TypeName)) =>
  //     #TypeTuple 1 ListItem(TN)
  //     ...
  //   </k>

  // rule
  //   <k>
  //     inferTypeExpression(I:Identifier) =>
  //     #TypeTuple 1 ListItem(T)
  //     ...
  //   </k>
  //   <cContext>
  //     ...
  //     I |-> T:Type
  //     ...
  //   </cContext>

  // rule
  //   <k>
  //     inferTypeExpression(I:Identifier) =>
  //     #TypeCheckError "Identifier is undefined.\n"
  //     ...
  //   </k>
  //   <cContext>
  //     C:Map
  //   </cContext>
  //   requires notBool(I in keys(C))
  
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

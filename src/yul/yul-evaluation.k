requires "./yul-ast.k"
requires "./yul-configuration.k"
requires "./yul-syntax.k"
requires "./yul-utility.k"
requires "./yul-value.k"

module YUL-EVALUATION
  imports DOMAINS
  imports YUL-AST
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  /**
   * evaluateProgram
   */

  syntax KItem ::=
    evaluateProgram(AstProgram)

  rule
    evaluateProgram(B:AstBlock) =>
    (
      beginEvaluationScope() ~>
      evaluateBlock(B) ~>
      endEvaluationScope()
    )

  rule
    evaluateProgram(O:AstObject) =>
    (
      beginEvaluationScope() ~>
      evaluateObject(O) ~>
      endEvaluationScope()
    )

  /**
   * evaluateBlock
   */

  syntax KItem ::=
    evaluateBlock(AstBlock)

  rule
    evaluateBlock(AstBlock(SS:List)) =>
    (
      beginEvaluationScope() ~>
      evaluateStatementSequence(SS) ~>
      endEvaluationScope()
    )

  /**
   * evaluateStatementSequence
   */

  syntax KItem ::=
    evaluateStatementSequence(List) |
    evaluateStatementSequenceFirstPass(List) |
    evaluateStatementSequenceSecondPass(List) |
    evaluateStatementSequenceSecondPassAfterStatement(List)

  rule
    evaluateStatementSequence(SS:List) =>
    (
      evaluateStatementSequenceFirstPass(SS) ~>
      evaluateStatementSequenceSecondPass(SS)
    )

  rule
    evaluateStatementSequenceFirstPass(.List) =>
    .

  rule
    evaluateStatementSequenceFirstPass(ListItem(S:AstStatement) SS:List) =>
    evaluateStatementSequenceFirstPass(SS)
    requires notBool(isAstFunctionDefinition(S))

  rule
    evaluateStatementSequenceFirstPass(ListItem(S:AstStatement) SS:List) =>
    (
      evaluateStatement(S) ~>
      evaluateStatementSequenceFirstPass(SS)
    )
    requires isAstFunctionDefinition(S)

  rule
    evaluateStatementSequenceSecondPass(.List) =>
    .

  rule
    evaluateStatementSequenceSecondPass(ListItem(S:AstStatement) SS:List) =>
    evaluateStatementSequenceSecondPass(SS)
    requires isAstFunctionDefinition(S)

  rule
    evaluateStatementSequenceSecondPass(ListItem(S:AstStatement) SS:List) =>
    (
      evaluateStatement(S) ~>
      evaluateStatementSequenceSecondPassAfterStatement(SS)
    )
    requires notBool(isAstFunctionDefinition(S))

  rule
    <k>
      evaluateStatementSequenceSecondPassAfterStatement(SS:List) =>
      evaluateStatementSequenceSecondPass(SS)
      ...
    </k>
    <cEvaluationMode>
      EvaluationModeRegular()
    </cEvaluationMode>

  rule
    <k>
      evaluateStatementSequenceSecondPassAfterStatement(SS:List) =>
      .
      ...
    </k>
    <cEvaluationMode>
      M:EvaluationMode
    </cEvaluationMode>
    requires (M ==K EvaluationModeContinue()) orBool (M ==K EvaluationModeBreak())

  /**
   * evaluateStatement
   */

  syntax KItem ::=
    evaluateStatement(AstStatement) |
    evaluateStatementAfterExpression()

  rule
    evaluateStatement(A:AstAssignment) =>
    evaluateAssignment(A)

  rule
    evaluateStatement(B:AstBlock) =>
    evaluateBlock(B)

  rule
    evaluateStatement(_:Break) =>
    setEvaluationMode(EvaluationModeBreak())

  rule
    evaluateStatement(_:Continue) =>
    setEvaluationMode(EvaluationModeContinue())

  rule
    evaluateStatement(D:AstDebug) =>
    evaluateDebug(D)

  rule
    evaluateStatement(F:AstFor) =>
    evaluateFor(F)

  rule
    evaluateStatement(E:AstExpression) =>
    evaluateExpression(E) ~> evaluateStatementAfterExpression()

  rule
    _:ValueTuple ~> evaluateStatementAfterExpression() =>
    .

  rule
    evaluateStatement(FD:AstFunctionDefinition) =>
    evaluateFunctionDefinition(FD)

  rule
    evaluateStatement(I:AstIf) =>
    evaluateIf(I)

  rule
    evaluateStatement(S:AstSwitch) =>
    evaluateSwitch(S)

  rule
    evaluateStatement(VD:AstVariableDeclaration) =>
    evaluateVariableDeclaration(VD)

  /**
   * evaluateAssignment
   */

  syntax KItem ::=
    evaluateAssignment(AstAssignment) |
    evaluateAssignmentAux(List, Hole) |
    evaluateAssignmentAux(List, ValueTuple)

  rule
    evaluateAssignment(AstAssignment(IL:List, E:AstExpression)) =>
    evaluateExpression(E) ~> evaluateAssignmentAux(IL, HOLE)

  rule
    VT:ValueTuple ~> evaluateAssignmentAux(IL:List, HOLE) =>
    evaluateAssignmentAux(IL, VT)

  rule
    evaluateAssignmentAux(.List, ValueTuple(0, .List)) =>
    .

  rule
    evaluateAssignmentAux(
      ListItem(Ide:Identifier) IL:List,
      ValueTuple(In:Int, ListItem(V:Value) VL:List)
    ) =>
    (
      updateVariableInEvaluationScope(Ide, EvaluationVariableAttributes(V)) ~>
      evaluateAssignmentAux(IL, ValueTuple(In -Int 1, VL))
    )

  /**
   * evaluateExpression
   */

  syntax KItem ::=
    evaluateExpression(AstExpression)

  rule
    evaluateExpression(FC:AstFunctionCall) =>
    evaluateExpressionFunctionCall(FC)

  rule
    evaluateExpression(TL:AstTypedLiteral) =>
    evaluateExpressionTypedLiteral(TL)

  rule
    evaluateExpression(I:Identifier) =>
    evaluateExpressionIdentifier(I)

  /**
   * evaluateExpressionFunctionCall
   */

  syntax KItem ::=
    evaluateExpressionFunctionCall(AstFunctionCall) |
    evaluateExpressionFunctionCallAfterBody(Hole) |
    evaluateExpressionFunctionCallAfterBody(ValueTuple) |
    evaluateExpressionFunctionCallAux(EvaluationFunctionAttributes, Hole) |
    evaluateExpressionFunctionCallAux(EvaluationFunctionAttributes, ValueTuple) |
    evaluateExpressionFunctionCallAux(Hole, List) |
    evaluateExpressionFunctionCallBuiltIn(Identifier, Hole) |
    evaluateExpressionFunctionCallBuiltIn(Identifier, ValueTuple)

  rule
    evaluateExpressionFunctionCall(AstFunctionCall(I:Identifier, EL:List)) =>
    evaluateFunctionArguments(EL) ~> evaluateExpressionFunctionCallBuiltIn(I, HOLE)
    requires isIdentifierBuiltInFunction(I)

  rule
    VT:ValueTuple ~> evaluateExpressionFunctionCallBuiltIn(I:Identifier, HOLE) =>
    evaluateExpressionFunctionCallBuiltIn(I, VT)

  rule
    evaluateExpressionFunctionCall(AstFunctionCall(I:Identifier, EL:List)) =>
    lookupFunctionInEvaluationScope(I) ~> evaluateExpressionFunctionCallAux(HOLE, EL)
    requires notBool(isIdentifierBuiltInFunction(I))

  rule
    Just(FA:EvaluationFunctionAttributes) ~> evaluateExpressionFunctionCallAux(HOLE, EL:List) =>
    evaluateFunctionArguments(EL) ~> evaluateExpressionFunctionCallAux(FA, HOLE)

  rule
    VT:ValueTuple ~> evaluateExpressionFunctionCallAux(FA:EvaluationFunctionAttributes, HOLE) =>
    evaluateExpressionFunctionCallAux(FA, VT)

  rule
    evaluateExpressionFunctionCallAux(
      EvaluationFunctionAttributes(TIL1:List, TIL2:List, B:AstBlock),
      VT:ValueTuple
    ) =>
    (
      beginEvaluationScope() ~>
      evaluateVariableDeclarationWithValues(TIL1, VT) ~>
      evaluateVariableDeclarationWithDefaults(TIL2) ~>
      evaluateBlock(B) ~>
      getReturnParameterValues(TIL2) ~> evaluateExpressionFunctionCallAfterBody(HOLE)
    )

  rule
    VT:ValueTuple ~> evaluateExpressionFunctionCallAfterBody(HOLE) =>
    evaluateExpressionFunctionCallAfterBody(VT)

  rule
    evaluateExpressionFunctionCallAfterBody(VT:ValueTuple) =>
    (
      endEvaluationScope() ~>
      VT
    )

  /**
   * getReturnParameterValues
   */

  syntax KItem ::=
    getReturnParameterValues(List) |
    getReturnParameterValuesAux(Hole, List) |
    getReturnParameterValuesAux(ValueTuple, Hole) |
    getReturnParameterValuesAux(ValueTuple, ValueTuple)

  rule
    getReturnParameterValues(.List) =>
    makeValueTuple()

  rule
    getReturnParameterValues(ListItem(AstTypedIdentifier(I:Identifier, _:TypeName)) TIL:List) =>
    evaluateExpression(I) ~> getReturnParameterValuesAux(HOLE, TIL)

  rule
    VT:ValueTuple ~> getReturnParameterValuesAux(HOLE, TIL) =>
    getReturnParameterValues(TIL) ~> getReturnParameterValuesAux(VT, HOLE)

  rule
    VT1:ValueTuple ~> getReturnParameterValuesAux(VT2:ValueTuple, HOLE) =>
    getReturnParameterValuesAux(VT2, VT1)

  rule
    getReturnParameterValuesAux(VT1:ValueTuple, VT2:ValueTuple) =>
    mergeValueTuples(VT1, VT2)

  /**
   * evaluateFunctionArguments
   */

  syntax KItem ::=
    evaluateFunctionArguments(List) |
    evaluateFunctionArgumentsReversed(List) |
    evaluateFunctionArgumentsReversedAux(Hole, List) |
    evaluateFunctionArgumentsReversedAux(ValueTuple, Hole) |
    evaluateFunctionArgumentsReversedAux(ValueTuple, ValueTuple)

  rule
    evaluateFunctionArguments(EL:List) =>
    evaluateFunctionArgumentsReversed(reverseExpressionList(EL))

  rule
    evaluateFunctionArgumentsReversed(.List) =>
    makeValueTuple()

  rule
    evaluateFunctionArgumentsReversed(ListItem(E:AstExpression) EL:List) =>
    evaluateExpression(E) ~> evaluateFunctionArgumentsReversedAux(HOLE, EL)

  rule
    VT:ValueTuple ~> evaluateFunctionArgumentsReversedAux(HOLE, EL:List) =>
    evaluateFunctionArgumentsReversed(EL) ~> evaluateFunctionArgumentsReversedAux(VT, HOLE)

  rule
    VT1:ValueTuple ~> evaluateFunctionArgumentsReversedAux(VT2:ValueTuple, HOLE) =>
    evaluateFunctionArgumentsReversedAux(VT2, VT1)

  rule
    evaluateFunctionArgumentsReversedAux(VT1:ValueTuple, VT2:ValueTuple) =>
    mergeValueTuples(VT2, VT1)

  /**
   * reverseExpressionList
   */

  syntax List ::=
    reverseExpressionList(List) [function]

  rule
    reverseExpressionList(.List) =>
    .List

  rule
    reverseExpressionList(ListItem(E:AstExpression) EL:List) =>
    reverseExpressionList(EL) ListItem(E)

  /**
   * evaluateExpressionTypedLiteral
   */

  syntax KItem ::=
    evaluateExpressionTypedLiteral(AstTypedLiteral)

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(B:Bool, bool)) =>
    makeValueTuple(ValueBool(B))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, u8)) =>
    makeValueTuple(ValueU8(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, u32)) =>
    makeValueTuple(ValueU32(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, u64)) =>
    makeValueTuple(ValueU64(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, u128)) =>
    makeValueTuple(ValueU128(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, u256)) =>
    makeValueTuple(ValueU256(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, s8)) =>
    makeValueTuple(ValueS8(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, s32)) =>
    makeValueTuple(ValueS32(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, s64)) =>
    makeValueTuple(ValueS64(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, s128)) =>
    makeValueTuple(ValueS128(I))

  rule
    evaluateExpressionTypedLiteral(AstTypedLiteral(I:Int, s256)) =>
    makeValueTuple(ValueS256(I))

  /**
   * evaluateExpressionIdentifier
   */

  syntax KItem ::=
    evaluateExpressionIdentifier(Identifier) |
    evaluateExpressionIdentifierAux(Hole) |
    evaluateExpressionIdentifierAux(EvaluationVariableAttributes)

  rule
    evaluateExpressionIdentifier(I:Identifier) =>
    lookupVariableInEvaluationScope(I) ~> evaluateExpressionIdentifierAux(HOLE)

  rule
    Just(VA:EvaluationVariableAttributes) ~> evaluateExpressionIdentifierAux(HOLE) =>
    evaluateExpressionIdentifierAux(VA)

  rule
    evaluateExpressionIdentifierAux(EvaluationVariableAttributes(V:Value)) =>
    makeValueTuple(V)

  /**
   * evaluateDebug
   */

  syntax KItem ::=
    evaluateDebug(AstDebug) |
    evaluateDebugAux(Identifier, Hole) |
    evaluateDebugAux(Identifier, ValueTuple)

  rule
    evaluateDebug(AstDebug(I:Identifier)) =>
    evaluateExpression(I) ~> evaluateDebugAux(I, HOLE)

  rule
    VT:ValueTuple ~> evaluateDebugAux(I:Identifier, HOLE) =>
    evaluateDebugAux(I, VT)

  rule
    <k>
      evaluateDebugAux(I:Identifier, VT:ValueTuple) =>
      .
      ...
    </k>
    <cDebug> ... .List => ListItem(ListItem(I) ListItem(VT)) </cDebug>

  /**
   * evaluateFor
   */

  syntax KItem ::=
    evaluateFor(AstFor) |
    evaluateForAfterBody(AstExpression, List, List) |
    evaluateForBeforeBody(AstExpression, List, List) |
    evaluateForCheckCondition(Hole, AstExpression, List, List) |
    evaluateForCheckCondition(ValueTuple, AstExpression, List, List)

  rule
    evaluateFor(
      AstFor(AstBlock(SS1:List), E:AstExpression, AstBlock(SS2:List), AstBlock(SS3:List))
    ) =>
    (
      beginEvaluationScope() ~>
      evaluateStatementSequence(SS1) ~>
      evaluateForBeforeBody(E, SS2, SS3) ~>
      endEvaluationScope()
    )

  rule
    evaluateForBeforeBody(E:AstExpression, SS1:List, SS2:List) =>
    evaluateExpression(E) ~> evaluateForCheckCondition(HOLE, E, SS1, SS2)

  rule
    VT:ValueTuple ~> evaluateForCheckCondition(HOLE, E:AstExpression, SS1:List, SS2:List) =>
    evaluateForCheckCondition(VT, E, SS1, SS2)

  rule
    evaluateForCheckCondition(VT:ValueTuple, E:AstExpression, SS1:List, SS2:List) =>
    .
    requires VT ==K ValueTuple(1, ListItem(ValueBool(false)))

  rule
    evaluateForCheckCondition(VT:ValueTuple, E:AstExpression, SS1:List, SS2:List) =>
    (
      evaluateStatementSequence(SS2) ~>
      evaluateForAfterBody(E, SS1, SS2)
    )
    requires VT ==K ValueTuple(1, ListItem(ValueBool(true)))

  rule
    <k>
      evaluateForAfterBody(E:AstExpression, SS1:List, SS2:List) =>
      (
        setEvaluationMode(EvaluationModeRegular()) ~>
        evaluateStatementSequence(SS1) ~>
        evaluateForBeforeBody(E, SS1, SS2)
      )
      ...
    </k>
    <cEvaluationMode>
      M:EvaluationMode
    </cEvaluationMode>
    requires (M ==K EvaluationModeRegular()) orBool (M ==K EvaluationModeContinue())

  rule
    <k>
      evaluateForAfterBody(E:AstExpression, SS1:List, SS2:List) =>
      setEvaluationMode(EvaluationModeRegular())
      ...
    </k>
    <cEvaluationMode>
      EvaluationModeBreak()
    </cEvaluationMode>

  /**
   * evaluateFunctionDefinition
   */

  syntax KItem ::=
    evaluateFunctionDefinition(AstFunctionDefinition)

  rule
    evaluateFunctionDefinition(
      AstFunctionDefinition(I:Identifier, TIL1:List, TIL2:List, B:AstBlock)
    ) =>
    setFunctionInEvaluationScope(I, EvaluationFunctionAttributes(TIL1, TIL2, B))

  /**
   * evaluateIf
   */

  syntax KItem ::=
    evaluateIf(AstIf) |
    evaluateIfAux(Hole, AstBlock) |
    evaluateIfAux(ValueBool, AstBlock)

  rule
    evaluateIf(AstIf(E:AstExpression, B:AstBlock)) =>
    evaluateExpression(E) ~> evaluateIfAux(HOLE, B)

  rule
    ValueTuple(1, ListItem(VB:ValueBool)) ~> evaluateIfAux(HOLE, B:AstBlock) =>
    evaluateIfAux(VB, B)

  rule
    evaluateIfAux(ValueBool(false), _:AstBlock) =>
    .

  rule
    evaluateIfAux(ValueBool(true), B:AstBlock) =>
    evaluateBlock(B)

  /**
   * evaluateSwitch
   */

  syntax KItem ::=
    evaluateSwitch(AstSwitch) |
    evaluateSwitchAfterCaseSequence(AstDefault) |
    evaluateSwitchAux(Hole, List, AstDefault) |
    evaluateSwitchAux(ValueTuple, List, AstDefault)

  rule
    evaluateSwitch(AstSwitch1(E:AstExpression, CS:List)) =>
    evaluateSwitch(AstSwitch2(E, CS, AstDefault(AstBlock(.List))))

  rule
    evaluateSwitch(AstSwitch2(E:AstExpression, CS:List, D:AstDefault)) =>
    evaluateExpression(E) ~> evaluateSwitchAux(HOLE, CS, D)

  rule
    VT:ValueTuple ~> evaluateSwitchAux(HOLE, CS:List, D:AstDefault) =>
    evaluateSwitchAux(VT, CS, D)

  rule
    evaluateSwitchAux(VT:ValueTuple, CS:List, D:AstDefault) =>
    (
      evaluateCaseSequence(CS, VT) ~>
      evaluateSwitchAfterCaseSequence(D)
    )

  rule
    <k>
      evaluateSwitchAfterCaseSequence(D:AstDefault) =>
      evaluateDefault(D)
      ...
    </k>
    <cEvaluationMode>
      EvaluationModeRegular()
    </cEvaluationMode>

  rule
    <k>
      evaluateSwitchAfterCaseSequence(_:AstDefault) =>
      setEvaluationMode(EvaluationModeRegular())
      ...
    </k>
    <cEvaluationMode>
      EvaluationModeBreak()
    </cEvaluationMode>

  /**
   * evaluateCaseSequence
   */

  syntax KItem ::=
    evaluateCaseSequence(List, ValueTuple) |
    evaluateCaseSequenceAfterCase(List, ValueTuple)

  rule
    evaluateCaseSequence(.List, _:ValueTuple) =>
    .

  rule
    evaluateCaseSequence(ListItem(C:AstCase) CS:List, VT:ValueTuple) =>
    (
      evaluateCase(C, VT) ~>
      evaluateCaseSequenceAfterCase(CS, VT)
    )

  rule
    <k>
      evaluateCaseSequenceAfterCase(CS:List, VT:ValueTuple) =>
      evaluateCaseSequence(CS, VT)
      ...
    </k>
    <cEvaluationMode>
      EvaluationModeRegular()
    </cEvaluationMode>

  rule
    <k>
      evaluateCaseSequenceAfterCase(_:List, _:ValueTuple) =>
      .
      ...
    </k>
    <cEvaluationMode>
      EvaluationModeBreak()
    </cEvaluationMode>

  /**
   * evaluateCase
   */

  syntax KItem ::=
    evaluateCase(AstCase, ValueTuple) |
    evaluateCaseAux(Hole, AstBlock, ValueTuple) |
    evaluateCaseAux(ValueTuple, AstBlock, ValueTuple)

  rule
    evaluateCase(AstCase(TL:AstTypedLiteral, B:AstBlock), VT:ValueTuple) =>
    evaluateExpression(TL) ~> evaluateCaseAux(HOLE, B, VT)

  rule
    VT1:ValueTuple ~> evaluateCaseAux(HOLE, B:AstBlock, VT2:ValueTuple) =>
    evaluateCaseAux(VT1, B, VT2)

  rule
    evaluateCaseAux(VT1:ValueTuple, B:AstBlock, VT2:ValueTuple) =>
    (
      evaluateBlock(B) ~>
      setEvaluationMode(EvaluationModeBreak())
    )
    requires VT1 ==K VT2

  rule
    evaluateCaseAux(VT1:ValueTuple, B:AstBlock, VT2:ValueTuple) =>
    .
    requires VT1 =/=K VT2

  /**
   * evaluateDefault
   */

  syntax KItem ::=
    evaluateDefault(AstDefault)

  rule
    evaluateDefault(AstDefault(B:AstBlock)) =>
    evaluateBlock(B)

  /**
   * evaluateVariableDeclaration
   */

  syntax KItem ::=
    evaluateVariableDeclaration(AstVariableDeclaration) |
    evaluateVariableDeclarationWithValues(List, Hole) |
    evaluateVariableDeclarationWithValues(List, ValueTuple) |
    evaluateVariableDeclarationWithDefaults(List)

  rule
    evaluateVariableDeclaration(AstVariableDeclaration1(TIL:List)) =>
    evaluateVariableDeclarationWithDefaults(TIL)

  rule
    evaluateVariableDeclarationWithDefaults(.List) =>
    .

  rule
    evaluateVariableDeclarationWithDefaults(
      ListItem(AstTypedIdentifier(I:Identifier, TN:TypeName)) TIL:List
    ) =>
    (
      setVariableInEvaluationScope(I, EvaluationVariableAttributes(getDefaultValue(TN))) ~>
      evaluateVariableDeclarationWithDefaults(TIL)
    )

  rule
    evaluateVariableDeclaration(AstVariableDeclaration2(TIL:List, E:AstExpression)) =>
    evaluateExpression(E) ~> evaluateVariableDeclarationWithValues(TIL, HOLE)

  rule
    VT:ValueTuple ~> evaluateVariableDeclarationWithValues(TIL:List, HOLE) =>
    evaluateVariableDeclarationWithValues(TIL, VT)

  rule
    evaluateVariableDeclarationWithValues(.List, ValueTuple(0, .List)) =>
    .

  rule
    evaluateVariableDeclarationWithValues(
      ListItem(AstTypedIdentifier(Ide:Identifier, _:TypeName)) TIL:List,
      ValueTuple(In:Int, ListItem(V:Value) VL:List)
    ) =>
    (
      setVariableInEvaluationScope(Ide, EvaluationVariableAttributes(V)) ~>
      evaluateVariableDeclarationWithValues(TIL, ValueTuple(In -Int 1, VL))
    )

  /**
   * evaluateObject
   */

  syntax KItem ::=
    evaluateObject(AstObject)

  rule
    evaluateObject(AstObject(_:LiteralString, C:AstCode, OODS:List)) =>
    (
      evaluateCode(C) ~>
      evaluateObjectOrDataSequence(OODS)
    )

  /**
   * evaluateCode
   */

  syntax KItem ::=
    evaluateCode(AstCode)

  rule
    evaluateCode(AstCode(B:AstBlock)) =>
    evaluateBlock(B)

  /**
   * evaluateObjectOrDataSequence
   */

  syntax KItem ::=
    evaluateObjectOrDataSequence(List)

  rule
    evaluateObjectOrDataSequence(.List) =>
    .

  rule
    evaluateObjectOrDataSequence(ListItem(OOD:AstObjectOrData) OODS:List) =>
    (
      evaluateObjectOrData(OOD) ~>
      evaluateObjectOrDataSequence(OODS)
    )

  /**
   * evaluateObjectOrData
   */

  syntax KItem ::=
    evaluateObjectOrData(AstObjectOrData)

  rule
    evaluateObjectOrData(_:AstData) =>
    .

  rule
    evaluateObjectOrData(O:AstObject) =>
    evaluateObject(O)

  /**
   *
   * Environment utility.
   *
   */

  /**
   * EvaluationVariableAttributes
   */

  syntax EvaluationVariableAttributes ::=
    EvaluationVariableAttributes(Value)

  /**
   * EvaluationFunctionAttributes
   */

  syntax EvaluationFunctionAttributes ::=
    EvaluationFunctionAttributes(typedIdentifierList1:List, typedIdentifierList2:List, AstBlock)

  /**
   * setEvaluationMode
   */

  syntax KItem ::=
    setEvaluationMode(EvaluationMode)

  rule
    <k>
      setEvaluationMode(M:EvaluationMode) =>
      .
      ...
    </k>
    <cEvaluationMode>
      _:EvaluationMode =>
      M
    </cEvaluationMode>

  /**
   * setVariableInEvaluationScope
   */

  syntax KItem ::=
    setVariableInEvaluationScope(Identifier, EvaluationVariableAttributes)

  rule
    <k>
      setVariableInEvaluationScope(I:Identifier, VA:EvaluationVariableAttributes) =>
      .
      ...
    </k>
    <cEvaluationVariableEnvironmentStack>
      ListItem(VE:Map) VES:List =>
      ListItem(updateMap(VE, I |-> VA)) VES:List
    </cEvaluationVariableEnvironmentStack>

  /**
   * updateVariableInEvaluationScope
   */

  syntax KItem ::=
    updateVariableInEvaluationScope(Identifier, EvaluationVariableAttributes)

  rule
    <k>
      updateVariableInEvaluationScope(I:Identifier, VA:EvaluationVariableAttributes) =>
      .
      ...
    </k>
    <cEvaluationVariableEnvironmentStack>
      VES:List =>
      updateVariableInEvaluationScopeAux(I, VA, VES)
    </cEvaluationVariableEnvironmentStack>

  syntax List ::=
    updateVariableInEvaluationScopeAux(
      Identifier,
      EvaluationVariableAttributes,
      variableEnvironmentStack:List
    ) [function]

  rule
    updateVariableInEvaluationScopeAux(
      I:Identifier,
      VA:EvaluationVariableAttributes,
      ListItem(VE:Map) VES:List
    ) =>
    ListItem(VE) updateVariableInEvaluationScopeAux(I, VA, VES)
    requires notBool(I in keys(VE))

  rule
    updateVariableInEvaluationScopeAux(
      I:Identifier,
      VA:EvaluationVariableAttributes,
      ListItem(VE:Map) VES:List
    ) =>
    ListItem(updateMap(VE, I |-> VA)) VES
    requires I in keys(VE)

  /**
   * setFunctionInEvaluationScope
   */

  syntax KItem ::=
    setFunctionInEvaluationScope(Identifier, EvaluationFunctionAttributes)

  rule
    <k>
      setFunctionInEvaluationScope(I:Identifier, FA:EvaluationFunctionAttributes) =>
      .
      ...
    </k>
    <cEvaluationFunctionEnvironmentStack>
      ListItem(FE:Map) FES:List =>
      ListItem(updateMap(FE, I |-> FA)) FES:List
    </cEvaluationFunctionEnvironmentStack>

  /**
   * lookupVariableInEvaluationScope
   */

  syntax KItem ::=
    lookupVariableInEvaluationScope(Identifier)

  rule
    <k>
      lookupVariableInEvaluationScope(I:Identifier) =>
      lookupVariableInEvaluationScopeAux(I, VES)
      ...
    </k>
    <cEvaluationVariableEnvironmentStack>
      VES:List
    </cEvaluationVariableEnvironmentStack>

  syntax Maybe ::=
    lookupVariableInEvaluationScopeAux(Identifier, variableEnvironmentStack:List) [function]

  rule
    lookupVariableInEvaluationScopeAux(I:Identifier, .List) =>
    Nothing()

  rule
    lookupVariableInEvaluationScopeAux(I:Identifier, ListItem(VE:Map) VES:List) =>
    lookupVariableInEvaluationScopeAux(I, VES)
    requires notBool(I in keys(VE))

  rule
    lookupVariableInEvaluationScopeAux(I:Identifier, ListItem(VE:Map) VES:List) =>
    Just(VE[I])
    requires I in keys(VE)

  /**
   * lookupFunctionInEvaluationScope
   */

  syntax KItem ::=
    lookupFunctionInEvaluationScope(Identifier)

  rule
    <k>
      lookupFunctionInEvaluationScope(I:Identifier) =>
      lookupFunctionInEvaluationScopeAux(I, FES)
      ...
    </k>
    <cEvaluationFunctionEnvironmentStack>
      FES:List
    </cEvaluationFunctionEnvironmentStack>

  syntax Maybe ::=
    lookupFunctionInEvaluationScopeAux(Identifier, functionEnvironmentStack:List) [function]

  rule
    lookupFunctionInEvaluationScopeAux(I:Identifier, .List) =>
    Nothing()

  rule
    lookupFunctionInEvaluationScopeAux(I:Identifier, ListItem(FE:Map) FES:List) =>
    lookupFunctionInEvaluationScopeAux(I, FES)
    requires notBool(I in keys(FE))

  rule
    lookupFunctionInEvaluationScopeAux(I:Identifier, ListItem(FE:Map) FES:List) =>
    Just(FE[I])
    requires I in keys(FE)

  /**
   * beginEvaluationScope
   */

  syntax KItem ::=
    beginEvaluationScope()

  rule
    <k>
      beginEvaluationScope() =>
      .
      ...
    </k>
    <cEvaluationVariableEnvironmentStack>
      VES:List =>
      ListItem(.Map) VES
    </cEvaluationVariableEnvironmentStack>
    <cEvaluationFunctionEnvironmentStack>
      FES:List =>
      ListItem(.Map) FES
    </cEvaluationFunctionEnvironmentStack>

  /**
   * endEvaluationScope
   */

  syntax KItem ::=
    endEvaluationScope()

  rule
    <k>
      endEvaluationScope() =>
      .
      ...
    </k>
    <cEvaluationVariableEnvironmentStack>
      ListItem(_:Map) VES:List =>
      VES
    </cEvaluationVariableEnvironmentStack>
    <cEvaluationFunctionEnvironmentStack>
      ListItem(_:Map) FES:List =>
      FES
    </cEvaluationFunctionEnvironmentStack>

endmodule

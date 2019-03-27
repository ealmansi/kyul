requires "../yul-ast/yul-ast.k"
requires "../yul-configuration/yul-configuration.k"
requires "../yul-syntax/yul-syntax.k"
requires "../yul-type/yul-type.k"
requires "../yul-utility/yul-utility.k"

module YUL-TYPE-CHECK
  imports DOMAINS
  imports YUL-AST
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-TYPE
  imports YUL-UTILITY

  /**
   * TypeCheckError
   */

  syntax TypeCheckError ::=
    TypeCheckErrorExpressionHasWrongType(AstExpression) |
    TypeCheckErrorFunctionAlreadyDefined(Identifier) |
    TypeCheckErrorFunctionIsUndefined(Identifier) |
    TypeCheckErrorInvalidFunctionCall() |
    TypeCheckErrorVariableAlreadyDefined(Identifier) |
    TypeCheckErrorVariableIsNotAccessible() |
    TypeCheckErrorVariableIsUndefined(Identifier)

  rule
    E:TypeCheckError ~> KI:KItem =>
    E

  /**
   * typecheckProgram
   */

  syntax KItem ::=
    typecheckProgram(AstProgram)

  rule
    typecheckProgram(B:AstBlock) =>
    (
      beginTypeCheckScope() ~>
      setBuiltInFunctionsInTypeCheckScope() ~>
      typecheckBlock(B) ~>
      endTypeCheckScope()
    )

  rule
    typecheckProgram(O:AstObject) =>
    (
      beginTypeCheckScope() ~>
      setBuiltInFunctionsInTypeCheckScope() ~>
      typecheckObject(O) ~>
      endTypeCheckScope()
    )

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
    checkFunctionNotInTypeCheckScopeAux(Identifier)

  rule
    checkFunctionNotInTypeCheckScope(I:Identifier) =>
    lookupFunctionInTypeCheckScope(I) ~> checkFunctionNotInTypeCheckScopeAux(I)

  rule
    Nothing() ~> checkFunctionNotInTypeCheckScopeAux(_:Identifier) =>
    .

  rule
    Just(_:TypeCheckFunctionAttributes) ~> checkFunctionNotInTypeCheckScopeAux(I:Identifier) =>
    TypeCheckErrorFunctionAlreadyDefined(I)

  /**
   * typecheckStatement
   */

  syntax KItem ::=
    typecheckStatement(AstStatement)

  rule
    typecheckStatement(A:AstAssignment) =>
    typecheckAssignment(A)

  rule
    typecheckStatement(B:AstBlock) =>
    typecheckBlock(B)

  rule
    typecheckStatement(B:Break) =>
    .

  rule
    typecheckStatement(C:Continue) =>
    .

  rule
    typecheckStatement(D:AstDebug) =>
    typecheckDebug(D)

  rule
    typecheckStatement(F:AstFor) =>
    typecheckFor(F)

  rule
    typecheckStatement(E:AstExpression) =>
    typecheckExpression(E, makeTypeTuple())

  rule
    typecheckStatement(FD:AstFunctionDefinition) =>
    typecheckFunctionDefinition(FD)

  rule
    typecheckStatement(I:AstIf) =>
    typecheckIf(I)

  rule
    typecheckStatement(S:AstSwitch) =>
    typecheckSwitch(S)

  rule
    typecheckStatement(VD:AstVariableDeclaration) =>
    typecheckVariableDeclaration(VD)

  /**
   * typecheckAssignment
   */

  syntax KItem ::=
    typecheckAssignment(AstAssignment) |
    typecheckAssignmentAux(Hole, AstExpression) |
    typecheckAssignmentAux(TypeTuple, AstExpression)

  rule
    typecheckAssignment(AstAssignment(IL:List, E:AstExpression)) =>
    inferTypeIdentifierList(IL) ~> typecheckAssignmentAux(HOLE, E)

  rule
    TT:TypeTuple ~> typecheckAssignmentAux(HOLE, E:AstExpression) =>
    typecheckAssignmentAux(TT, E)

  rule
    typecheckAssignmentAux(TT:TypeTuple, E:AstExpression) =>
    typecheckExpression(E, TT)

  /**
   * inferTypeIdentifierList
   */

  syntax KItem ::=
    inferTypeIdentifierList(List) |
    inferTypeIdentifierListAux(Hole, List) |
    inferTypeIdentifierListAux(TypeTuple, Hole) |
    inferTypeIdentifierListAux(TypeTuple, TypeTuple)

  rule
    inferTypeIdentifierList(.List) =>
    makeTypeTuple()

  rule
    inferTypeIdentifierList(ListItem(I:Identifier) IL:List) =>
    inferTypeExpression(I) ~> inferTypeIdentifierListAux(HOLE, IL)

  rule
    TT:TypeTuple ~> inferTypeIdentifierListAux(HOLE, IL:List) =>
    inferTypeIdentifierList(IL) ~> inferTypeIdentifierListAux(TT, HOLE)

  rule
    TT1:TypeTuple ~> inferTypeIdentifierListAux(TT2:TypeTuple, HOLE) =>
    inferTypeIdentifierListAux(TT2, TT1)

  rule
    inferTypeIdentifierListAux(TT1:TypeTuple, TT2:TypeTuple) =>
    mergeTypeTuples(TT1, TT2)

  /**
   * typecheckExpression
   */

  syntax KItem ::=
    typecheckExpression(AstExpression, TypeTuple) |
    typecheckExpressionAux(AstExpression, Hole, TypeTuple) |
    typecheckExpressionAux(AstExpression, TypeTuple, TypeTuple)

  rule
    typecheckExpression(E:AstExpression, TT:TypeTuple) =>
    inferTypeExpression(E) ~> typecheckExpressionAux(E, HOLE, TT)

  rule
    TT1:TypeTuple ~> typecheckExpressionAux(E:AstExpression, HOLE, TT2:TypeTuple) =>
    typecheckExpressionAux(E, TT1, TT2)

  rule
    typecheckExpressionAux(E:AstExpression, TT1:TypeTuple, TT2:TypeTuple) =>
    TypeCheckErrorExpressionHasWrongType(E)
    requires TT1 =/=K TT2

  rule
    typecheckExpressionAux(_:AstExpression, TT1:TypeTuple, TT2:TypeTuple) =>
    .
    requires TT1 ==K TT2

  /**
   * inferTypeExpression
   */

  syntax KItem ::=
    inferTypeExpression(AstExpression)

  rule
    inferTypeExpression(FC:AstFunctionCall) =>
    inferTypeExpressionFunctionCall(FC)

  rule
    inferTypeExpression(TL:AstTypedLiteral) =>
    inferTypeExpressionTypedLiteral(TL)

  rule
    inferTypeExpression(I:Identifier) =>
    inferTypeExpressionIdentifier(I)

  /**
   * inferTypeExpressionTypedLiteral
   */

  syntax KItem ::=
    inferTypeExpressionTypedLiteral(AstTypedLiteral)

  rule
    inferTypeExpressionTypedLiteral(AstTypedLiteral(_:Literal, TN:TypeName)) =>
    makeTypeTuple(TN)

  /**
   * inferTypeExpressionFunctionCall
   */

  syntax KItem ::=
    inferTypeExpressionFunctionCall(AstFunctionCall) |
    inferTypeExpressionFunctionCallAux(Identifier, List)

  rule
    inferTypeExpressionFunctionCall(AstFunctionCall(I:Identifier, EL:List)) =>
    lookupFunctionInTypeCheckScope(I) ~> inferTypeExpressionFunctionCallAux(I, EL)

  rule
    Nothing() ~> inferTypeExpressionFunctionCallAux(I:Identifier, _:List) =>
    TypeCheckErrorFunctionIsUndefined(I)

  rule
    (
      Just(TypeCheckFunctionAttributes(TypeFunction(TT1:TypeTuple, TT2:TypeTuple))) ~>
      inferTypeExpressionFunctionCallAux(_:Identifier, EL:List)
    ) =>
    (
      typecheckFunctionArguments(EL, TT1) ~>
      TT2
    )

  /**
   * typecheckFunctionArguments
   */

  syntax KItem ::=
    typecheckFunctionArguments(List, TypeTuple)

  rule
    typecheckFunctionArguments(.List, TypeTuple(0, .List)) =>
    .

  rule
    typecheckFunctionArguments(ListItem(_:AstExpression) _:List, TypeTuple(0, .List)) =>
    TypeCheckErrorInvalidFunctionCall()

  rule
    typecheckFunctionArguments(.List, TypeTuple(_:Int, ListItem(_:Type) _:List)) =>
    TypeCheckErrorInvalidFunctionCall()

  rule
    typecheckFunctionArguments(
      ListItem(E:AstExpression) EL:List,
      TypeTuple(I:Int, ListItem(T:Type) TL:List)
    ) =>
    (
      typecheckExpression(E, makeTypeTuple(T)) ~>
      typecheckFunctionArguments(EL, TypeTuple(I -Int 1, TL))
    )

  /**
   * inferTypeExpressionIdentifier
   */

  syntax KItem ::=
    inferTypeExpressionIdentifier(Identifier) |
    inferTypeExpressionIdentifierAux(Identifier)

  rule
    inferTypeExpressionIdentifier(I:Identifier) =>
    lookupVariableInTypeCheckScope(I) ~> inferTypeExpressionIdentifierAux(I)

  rule
    Nothing() ~> inferTypeExpressionIdentifierAux(I:Identifier) =>
    TypeCheckErrorVariableIsUndefined(I)

  rule
    Just(
      TypeCheckVariableAttributes(_:Type, TypeCheckVariableAccessNone())
    ) ~> inferTypeExpressionIdentifierAux(_:Identifier) =>
    TypeCheckErrorVariableIsNotAccessible()

  rule
    Just(
      TypeCheckVariableAttributes(T:Type, TypeCheckVariableAccessReadWrite())
    ) ~> inferTypeExpressionIdentifierAux(_:Identifier) =>
    makeTypeTuple(T)

  /**
   * typecheckDebug
   */

  syntax KItem ::=
    typecheckDebug(AstDebug) |
    typecheckDebugAux()

  rule
    typecheckDebug(AstDebug(I:Identifier)) =>
    inferTypeExpression(I) ~> typecheckDebugAux()

  rule
    _:TypeTuple ~> typecheckDebugAux() =>
    .

  /**
   * typecheckFor
   */

  syntax KItem ::=
    typecheckFor(AstFor)

  rule
    typecheckFor(
      AstFor(AstBlock(SS1:List), E:AstExpression, AstBlock(SS2:List), AstBlock(SS3:List))
    ) =>
    (
      typecheckBlock(AstBlock(SS1 ListItem(AstIf(E, AstBlock(.List))))) ~>
      typecheckBlock(AstBlock(SS1 SS2)) ~>
      typecheckBlock(AstBlock(SS1 SS3))
    )

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
        typecheckBlock(
          AstBlock(
            ListItem(AstVariableDeclaration1(TIL1))
            ListItem(AstVariableDeclaration1(TIL2))
            SS
          )
        ) ~>
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

  /**
   * typecheckIf
   */

  syntax KItem ::=
    typecheckIf(AstIf)

  rule
    typecheckIf(AstIf(E:AstExpression, B:AstBlock)) =>
    (
      typecheckExpression(E, makeTypeTuple(bool)) ~>
      typecheckBlock(B)
    )

  /**
   * typecheckSwitch
   */

  syntax KItem ::=
    typecheckSwitch(AstSwitch) |
    typecheckSwitchAux(Hole, List, AstDefault) |
    typecheckSwitchAux(TypeTuple, List, AstDefault)

  rule
    typecheckSwitch(AstSwitch1(E:AstExpression, CS:List)) =>
    typecheckSwitch(AstSwitch2(E, CS, AstDefault(AstBlock(.List))))

  rule
    typecheckSwitch(AstSwitch2(E:AstExpression, CS:List, D:AstDefault)) =>
    inferTypeExpression(E) ~> typecheckSwitchAux(HOLE, CS, D)

  rule
    TT:TypeTuple ~> typecheckSwitchAux(HOLE, CS:List, D:AstDefault) =>
    typecheckSwitchAux(TT, CS, D)

  rule
    typecheckSwitchAux(TT, CS, D) =>
    (
      typecheckCaseSequence(CS, TT) ~>
      typecheckDefault(D)
    )

  /**
   * typecheckCaseSequence
   */

  syntax KItem ::=
    typecheckCaseSequence(List, TypeTuple)

  rule
    typecheckCaseSequence(.List, _:TypeTuple) =>
    .

  rule
    typecheckCaseSequence(ListItem(C:AstCase) CS:List, TT:TypeTuple) =>
    (
      typecheckCase(C, TT) ~>
      typecheckCaseSequence(CS, TT)
    )

  /**
   * typecheckCase
   */

  syntax KItem ::=
    typecheckCase(AstCase, TypeTuple)

  rule
    typecheckCase(AstCase(TL:AstTypedLiteral, B:AstBlock), TT:TypeTuple) =>
    (
      typecheckExpression(TL, TT) ~>
      typecheckBlock(B)
    )

  /**
   * typecheckDefault
   */

  syntax KItem ::=
    typecheckDefault(AstDefault)

  rule
    typecheckDefault(AstDefault(B:AstBlock)) =>
    typecheckBlock(B)

  /**
   * typecheckVariableDeclaration
   */

  syntax KItem ::=
    typecheckVariableDeclaration(AstVariableDeclaration)

  rule
    typecheckVariableDeclaration(AstVariableDeclaration1(TIL:List)) =>
    setDeclaredVariablesInTypeCheckScope(TIL)

  rule
    typecheckVariableDeclaration(AstVariableDeclaration2(TIL:List, E:AstExpression)) =>
    (
      typecheckExpression(E, getTypedIdentifierListTypeTuple(TIL)) ~>
      setDeclaredVariablesInTypeCheckScope(TIL)
    )

  /**
   * setDeclaredVariablesInTypeCheckScope
   */

  syntax KItem ::=
    setDeclaredVariablesInTypeCheckScope(List)

  rule
    setDeclaredVariablesInTypeCheckScope(.List) =>
    .

  rule
    setDeclaredVariablesInTypeCheckScope(
      ListItem(AstTypedIdentifier(I:Identifier, TN:TypeName)) TIL:List
    ) =>
    (
      checkVariableNotInTypeCheckScope(I) ~>
      setVariableInTypeCheckScope(
        I,
        TypeCheckVariableAttributes(TN, TypeCheckVariableAccessReadWrite())
      ) ~>
      setDeclaredVariablesInTypeCheckScope(TIL)
    )

  /**
   * checkVariableNotInTypeCheckScope
   */

  syntax KItem ::=
    checkVariableNotInTypeCheckScope(Identifier) |
    checkVariableNotInTypeCheckScopeAux(Identifier, Hole) |
    checkVariableNotInTypeCheckScopeAux(Identifier, Maybe)

  rule
    checkVariableNotInTypeCheckScope(I:Identifier) =>
    lookupVariableInTypeCheckScope(I) ~> checkVariableNotInTypeCheckScopeAux(I, HOLE)

  rule
    M:Maybe ~> checkVariableNotInTypeCheckScopeAux(I:Identifier, HOLE) =>
    checkVariableNotInTypeCheckScopeAux(I, M)

  rule
    checkVariableNotInTypeCheckScopeAux(_:Identifier, Nothing()) =>
    .

  rule
    checkVariableNotInTypeCheckScopeAux(I:Identifier, Just(_:TypeCheckVariableAttributes)) =>
    TypeCheckErrorVariableAlreadyDefined(I)

  /**
   * typecheckObject
   */

  syntax KItem ::=
    typecheckObject(AstObject)

  rule
    typecheckObject(AstObject(_:LiteralString, C:AstCode, OODS:List)) =>
    (
      typecheckCode(C) ~>
      typecheckObjectOrDataSequence(OODS)
    )

  /**
   * typecheckCode
   */

  syntax KItem ::=
    typecheckCode(AstCode)

  rule
    typecheckCode(AstCode(B:AstBlock)) =>
    typecheckBlock(B)

  /**
   * typecheckObjectOrDataSequence
   */

  syntax KItem ::=
    typecheckObjectOrDataSequence(List)

  rule
    typecheckObjectOrDataSequence(.List) =>
    .

  rule
    typecheckObjectOrDataSequence(ListItem(OOD:AstObjectOrData) OODS:List) =>
    (
      typecheckObjectOrData(OOD) ~>
      typecheckObjectOrDataSequence(OODS)
    )

  /**
   * typecheckObjectOrData
   */

  syntax KItem ::=
    typecheckObjectOrData(AstObjectOrData)

  rule
    typecheckObjectOrData(D:AstData) =>
    .

  rule
    typecheckObjectOrData(O:AstObject) =>
    typecheckObject(O)

  /**
   *
   * Environment utility.
   *
   */

  /**
   * TypeCheckVariableAttributes
   */

  syntax TypeCheckVariableAccess ::=
    TypeCheckVariableAccessNone() |
    TypeCheckVariableAccessReadWrite()

  syntax TypeCheckVariableAttributes ::=
    TypeCheckVariableAttributes(Type, TypeCheckVariableAccess)

  /**
   * TypeCheckFunctionAttributes
   */

  syntax TypeCheckFunctionAttributes ::=
    TypeCheckFunctionAttributes(Type)

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
    Nothing()

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
    Nothing()

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
    updateMap(VE, I |-> TypeCheckVariableAttributes(T, TypeCheckVariableAccessNone()))

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
   * setBuiltInFunctionsInTypeCheckScope
   */

  syntax KItem ::=
    setBuiltInFunctionInTypeCheckScope(Identifier, TypeTuple, TypeTuple) |
    setBuiltInFunctionsInTypeCheckScope()

  rule
    setBuiltInFunctionInTypeCheckScope(I:Identifier, TT1:TypeTuple, TT2:TypeTuple) =>
    setFunctionInTypeCheckScope(I, TypeCheckFunctionAttributes(TypeFunction(TT1, TT2)))

  /* lint:disable */
  rule
    setBuiltInFunctionsInTypeCheckScope() => (
      setBuiltInFunctionInTypeCheckScope(and, makeTypeTuple(bool, bool), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(not, makeTypeTuple(bool), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(or, makeTypeTuple(bool, bool), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(xor, makeTypeTuple(bool, bool), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(addmodu256, makeTypeTuple(u256, u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(addu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(andu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(byte, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(divs256, makeTypeTuple(s256, s256), makeTypeTuple(s256)) ~>
      setBuiltInFunctionInTypeCheckScope(divu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(equ256, makeTypeTuple(u256, u256), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(expu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(gts256, makeTypeTuple(s256, s256), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(gtu256, makeTypeTuple(u256, u256), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(iszerou256, makeTypeTuple(u256), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(lts256, makeTypeTuple(s256, s256), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(ltu256, makeTypeTuple(u256, u256), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(mods256, makeTypeTuple(s256, s256), makeTypeTuple(s256)) ~>
      setBuiltInFunctionInTypeCheckScope(modu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(mulmodu256, makeTypeTuple(u256, u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(mulu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(notu256, makeTypeTuple(u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(oru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(sars256, makeTypeTuple(s256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(shlu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(shru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(signextendu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(subu256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(xoru256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(mload, makeTypeTuple(u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(msize, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(mstore, makeTypeTuple(u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(mstore8, makeTypeTuple(u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(sload, makeTypeTuple(u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(sstore, makeTypeTuple(u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(abort, makeTypeTuple(), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(call, makeTypeTuple(u256, u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(callcode, makeTypeTuple(u256, u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(create, makeTypeTuple(u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(create2, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(delegatecall, makeTypeTuple(u256, u256, u256, u256, u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(log0, makeTypeTuple(u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(log1, makeTypeTuple(u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(log2, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(log3, makeTypeTuple(u256, u256, u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(log4, makeTypeTuple(u256, u256, u256, u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(return, makeTypeTuple(u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(revert, makeTypeTuple(u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(selfdestruct, makeTypeTuple(u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(balance, makeTypeTuple(u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(blockcoinbase, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(blockdifficulty, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(blockgaslimit, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(blockhash, makeTypeTuple(u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(blocknumber, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(blocktimestamp, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(calldatacopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(calldataload, makeTypeTuple(u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(calldatasize, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(caller, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(callvalue, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(codecopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(codesize, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(extcodecopy, makeTypeTuple(u256, u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(extcodehash, makeTypeTuple(u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(extcodesize, makeTypeTuple(u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(gasleft, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(this, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(txgasprice, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(txorigin, makeTypeTuple(), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(combineu64tou256, makeTypeTuple(u64, u64, u64, u64), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(datacopy, makeTypeTuple(u256, u256, u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(discard, makeTypeTuple(bool), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(discardu256, makeTypeTuple(u256), makeTypeTuple()) ~>
      setBuiltInFunctionInTypeCheckScope(keccak256, makeTypeTuple(u256, u256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(splitu256tou64, makeTypeTuple(u256), makeTypeTuple(u64, u64, u64, u64)) ~>
      setBuiltInFunctionInTypeCheckScope(booltos256, makeTypeTuple(bool), makeTypeTuple(s256)) ~>
      setBuiltInFunctionInTypeCheckScope(booltou256, makeTypeTuple(bool), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(booltou32, makeTypeTuple(bool), makeTypeTuple(u32)) ~>
      setBuiltInFunctionInTypeCheckScope(booltou64, makeTypeTuple(bool), makeTypeTuple(u64)) ~>
      setBuiltInFunctionInTypeCheckScope(s256tobool, makeTypeTuple(s256), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(s256tou256, makeTypeTuple(s256), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(s256tou32, makeTypeTuple(s256), makeTypeTuple(u32)) ~>
      setBuiltInFunctionInTypeCheckScope(s256tou64, makeTypeTuple(s256), makeTypeTuple(u64)) ~>
      setBuiltInFunctionInTypeCheckScope(u256tobool, makeTypeTuple(u256), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(u256tos256, makeTypeTuple(u256), makeTypeTuple(s256)) ~>
      setBuiltInFunctionInTypeCheckScope(u256tou32, makeTypeTuple(u256), makeTypeTuple(u32)) ~>
      setBuiltInFunctionInTypeCheckScope(u256tou64, makeTypeTuple(u256), makeTypeTuple(u64)) ~>
      setBuiltInFunctionInTypeCheckScope(u32tobool, makeTypeTuple(u32), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(u32tos256, makeTypeTuple(u32), makeTypeTuple(s256)) ~>
      setBuiltInFunctionInTypeCheckScope(u32tou256, makeTypeTuple(u32), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(u32tou64, makeTypeTuple(u32), makeTypeTuple(u64)) ~>
      setBuiltInFunctionInTypeCheckScope(u64tobool, makeTypeTuple(u64), makeTypeTuple(bool)) ~>
      setBuiltInFunctionInTypeCheckScope(u64tos256, makeTypeTuple(u64), makeTypeTuple(s256)) ~>
      setBuiltInFunctionInTypeCheckScope(u64tou256, makeTypeTuple(u64), makeTypeTuple(u256)) ~>
      setBuiltInFunctionInTypeCheckScope(u64tou32, makeTypeTuple(u64), makeTypeTuple(u32))
    )
  /* lint:enable */

endmodule

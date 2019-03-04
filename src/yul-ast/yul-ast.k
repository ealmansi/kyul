require "../yul-syntax/yul-syntax.k"

module YUL-AST
  imports DOMAINS
  imports YUL-SYNTAX

  syntax Ast ::=
    AstAssignment |
    AstBlock |
    AstBreak |
    AstCase |
    AstCaseSequence |
    AstCode |
    AstContinue |
    AstData |
    AstDebug |
    AstDefault |
    AstExpression |
    AstExpressionList |
    AstFor |
    AstFunctionCall |
    AstFunctionDefinition |
    AstIdentifier |
    AstIdentifierList |
    AstIf |
    AstLiteral |
    AstLiteralBool |
    AstLiteralHex |
    AstLiteralHexDouble |
    AstLiteralHexSingle |
    AstLiteralNumber |
    AstLiteralNumberHex |
    AstLiteralNumberInt |
    AstLiteralString |
    AstObject |
    AstObjectOrData |
    AstObjectOrDataSequence |
    AstProgram |
    AstStatement |
    AstStatementSequence |
    AstSwitch |
    AstTypedIdentifier |
    AstTypedIdentifierList |
    AstTypedLiteral |
    AstTypeName |
    AstTypeNameBuiltIn |
    AstVariableDeclaration

  syntax AstAssignment ::=
    "AstAssignment" "(" AstIdentifierList "," AstExpression ")"

  syntax AstAssignment ::=
    toAstAssignment(Assignment) [function]

  rule toAstAssignment(IL := E) =>
    AstAssignment(toAstIdentifierList(IL), toAstExpression(E))

  syntax AstBlock ::=
    "AstBlock" "(" AstStatementSequence ")"

  syntax AstBlock ::=
    toAstBlock(Block) [function]

  rule toAstBlock({}) =>
    AstBlock(.List)

  rule toAstBlock({ SS }) =>
    AstBlock(toAstStatementSequence(SS))

  syntax AstBreak ::=
    "AstBreak" "(" ")"

  syntax AstBreak ::=
    toAstBreak(Break) [function]

  rule toAstBreak(B) =>
    AstBreak()

  syntax AstCase ::=
    "AstCase" "(" AstTypedLiteral "," AstBlock ")"

  syntax AstCase ::=
    toAstCase(Case) [function]

  rule toAstCase(case TL B) =>
    AstCase(toAstTypedLiteral(TL), toAstBlock(B))

  syntax AstCaseSequence ::=
    List

  syntax List ::=
    toAstCaseSequence(CaseSequence) [function]

  rule toAstCaseSequence(C:Case) =>
    ListItem(toAstCase(C))

  rule toAstCaseSequence(CS:CaseSequence C:Case) =>
    toAstCaseSequence(CS) ListItem(toAstCase(C))

  syntax AstCode ::=
    "AstCode" "(" AstBlock ")"

  syntax AstCode ::=
    toAstCode(Code) [function]

  rule toAstCode(code B) =>
    AstCode(toAstBlock(B))

  syntax AstContinue ::=
    "AstContinue" "(" ")"

  syntax AstContinue ::=
    toAstContinue(Continue) [function]

  rule toAstContinue(C) =>
    AstContinue()

  syntax AstData ::=
    "AstData" "(" AstLiteralString "," AstLiteralHex ")" |
    "AstData" "(" AstLiteralString "," AstLiteralString ")"

  syntax AstData ::=
    toAstData(Data) [function]

  rule toAstData(data LS:LiteralString LH:LiteralHex) =>
    AstData(toAstLiteralString(LS), toAstLiteralHex(LH))

  rule toAstData(data LS1:LiteralString LS2:LiteralString) =>
    AstData(toAstLiteralString(LS1), toAstLiteralString(LS2))

  syntax AstDebug ::=
    "AstDebug" "(" ")"

  syntax AstDebug ::=
    toAstDebug(Debug) [function]

  rule toAstDebug(D) =>
    AstDebug()

  syntax AstDefault ::=
    "AstDefault" "(" AstBlock ")" |
    ".AstDefault"

  syntax AstDefault ::=
    toAstDefault(Default) [function]

  rule toAstDefault(default B) =>
    AstDefault(toAstBlock(B))

  syntax AstExpression ::=
    "AstExpression" "(" AstFunctionCall ")" |
    "AstExpression" "(" AstIdentifier ")" |
    "AstExpression" "(" AstTypedLiteral ")"

  syntax AstExpression ::=
    toAstExpression(Expression) [function]

  rule toAstExpression(FC:FunctionCall) =>
    AstExpression(toAstFunctionCall(FC))

  rule toAstExpression(I:Identifier) =>
    AstExpression(toAstIdentifier(I))

  rule toAstExpression(TL:TypedLiteral) =>
    AstExpression(toAstTypedLiteral(TL))

  syntax AstExpressionList ::=
    List

  syntax List ::=
    toAstExpressionList(ExpressionList) [function]

  rule toAstExpressionList(E:Expression) =>
    ListItem(toAstExpression(E))

  rule toAstExpressionList(EL:ExpressionList , E:Expression) =>
    toAstExpressionList(EL) ListItem(toAstExpression(E))

  syntax AstFor ::=
    "AstFor" "(" AstBlock "," AstExpression "," AstBlock "," AstBlock ")"

  syntax AstFor ::=
    toAstFor(For) [function]

  rule toAstFor(for B1 E B2 B3) =>
    AstFor(toAstBlock(B1), toAstExpression(E), toAstBlock(B2), toAstBlock(B3))

  syntax AstFunctionCall ::=
    "AstFunctionCall" "(" AstIdentifier "," AstExpressionList ")"

  syntax AstFunctionCall ::=
    toAstFunctionCall(FunctionCall) [function]

  rule toAstFunctionCall(I ( )) =>
    AstFunctionCall(toAstIdentifier(I), .List)

  rule toAstFunctionCall(I ( EL )) =>
    AstFunctionCall(toAstIdentifier(I), toAstExpressionList(EL))

  syntax AstFunctionDefinition ::=
    "AstFunctionDefinition" "(" AstIdentifier "," AstTypedIdentifierList "," AstTypedIdentifierList "," AstBlock ")"
      [klabel(AstFunctionDefinition1)]

  syntax AstFunctionDefinition ::=
    toAstFunctionDefinition(FunctionDefinition) [function]

  rule toAstFunctionDefinition(function I ( ) B) =>
    AstFunctionDefinition(
      toAstIdentifier(I),
      .List,
      .List,
      toAstBlock(B)
    )

  rule toAstFunctionDefinition(function I ( TIL ) B) =>
    AstFunctionDefinition(
      toAstIdentifier(I),
      toAstTypedIdentifierList(TIL),
      .List,
      toAstBlock(B)
    )

  rule toAstFunctionDefinition(function I ( ) -> TIL B) =>
    AstFunctionDefinition(
      toAstIdentifier(I),
      .List,
      toAstTypedIdentifierList(TIL),
      toAstBlock(B)
    )

  rule toAstFunctionDefinition(function I ( TIL1 ) -> TIL2 B) =>
    AstFunctionDefinition(
      toAstIdentifier(I),
      toAstTypedIdentifierList(TIL1),
      toAstTypedIdentifierList(TIL2),
      toAstBlock(B)
    )

  syntax AstIdentifier ::=
    "AstIdentifier" "(" Id ")"

  syntax AstIdentifier ::=
    toAstIdentifier(Identifier) [function]

  rule toAstIdentifier(I) =>
    AstIdentifier(I)

  syntax AstIdentifierList ::=
    List

  syntax List ::=
    toAstIdentifierList(IdentifierList) [function]

  rule toAstIdentifierList(I) =>
    ListItem(toAstIdentifier(I))

  rule toAstIdentifierList(IL , I) =>
    toAstIdentifierList(IL) ListItem(toAstIdentifier(I))

  syntax AstIf ::=
    "AstIf" "(" AstExpression "," AstBlock ")"

  syntax AstIf ::=
    toAstIf(If) [function]

  rule toAstIf(if E B) =>
    AstIf(toAstExpression(E), toAstBlock(B))

  syntax AstLiteral ::=
    "AstLiteral" "(" AstLiteralBool ")" |
    "AstLiteral" "(" AstLiteralHex ")" |
    "AstLiteral" "(" AstLiteralNumber ")" |
    "AstLiteral" "(" AstLiteralString ")"

  syntax AstLiteral ::=
    toAstLiteral(Literal) [function]

  rule toAstLiteral(LB:LiteralBool) =>
    AstLiteral(toAstLiteralBool(LB))

  rule toAstLiteral(LH:LiteralHex) =>
    AstLiteral(toAstLiteralHex(LH))

  rule toAstLiteral(LN:LiteralNumber) =>
    AstLiteral(toAstLiteralNumber(LN))

  rule toAstLiteral(LS:LiteralString) =>
    AstLiteral(toAstLiteralString(LS))

  syntax AstLiteralBool ::=
    "AstLiteralBool" "(" Bool ")"

  syntax AstLiteralBool ::=
    toAstLiteralBool(LiteralBool) [function]

  rule toAstLiteralBool(B) =>
    AstLiteralBool(B)

  syntax AstLiteralHex ::=
    "AstLiteralHex" "(" AstLiteralHexDouble ")" |
    "AstLiteralHex" "(" AstLiteralHexSingle ")"

  syntax AstLiteralHex ::=
    toAstLiteralHex(LiteralHex) [function]

  rule toAstLiteralHex(LXD:LiteralHexDouble) =>
    AstLiteralHex(toAstLiteralHexDouble(LXD))

  rule toAstLiteralHex(LXS:LiteralHexSingle) =>
    AstLiteralHex(toAstLiteralHexSingle(LXS))

  syntax AstLiteralHexDouble ::=
    "AstLiteralHexDouble" "(" LiteralHexDouble ")"

  syntax AstLiteralHexDouble ::=
    toAstLiteralHexDouble(LiteralHexDouble) [function]

  rule toAstLiteralHexDouble(LHD) =>
    AstLiteralHexDouble(LHD)

  syntax AstLiteralHexSingle ::=
    "AstLiteralHexSingle" "(" LiteralHexSingle ")"

  syntax AstLiteralHexSingle ::=
    toAstLiteralHexSingle(LiteralHexSingle) [function]

  rule toAstLiteralHexSingle(LHS) =>
    AstLiteralHexSingle(LHS)

  syntax AstLiteralNumber ::=
    "AstLiteralNumber" "(" AstLiteralNumberInt ")" |
    "AstLiteralNumber" "(" AstLiteralNumberHex ")"

  syntax AstLiteralNumber ::=
    toAstLiteralNumber(LiteralNumber) [function]

  rule toAstLiteralNumber(LNI:LiteralNumberInt) =>
    AstLiteralNumber(toAstLiteralNumberInt(LNI))

  rule toAstLiteralNumber(LNH:LiteralNumberHex) =>
    AstLiteralNumber(toAstLiteralNumberHex(LNH))

  syntax AstLiteralNumberHex ::=
    "AstLiteralNumberHex" "(" LiteralNumberHex ")"

  syntax AstLiteralNumberHex ::=
    toAstLiteralNumberHex(LiteralNumberHex) [function]

  rule toAstLiteralNumberHex(LNX) =>
    AstLiteralNumberHex(LNX)

  syntax AstLiteralNumberInt ::=
    "AstLiteralNumberInt" "(" Int ")"

  syntax AstLiteralNumberInt ::=
    toAstLiteralNumberInt(LiteralNumberInt) [function]

  rule toAstLiteralNumberInt(I) =>
    AstLiteralNumberInt(I)

  syntax AstLiteralString ::=
    "AstLiteralString" "(" String ")"

  syntax AstLiteralString ::=
    toAstLiteralString(LiteralString) [function]

  rule toAstLiteralString(S) =>
    AstLiteralString(S)

  syntax AstObject ::=
    "AstObject" "(" AstLiteralString "," AstCode "," AstObjectOrDataSequence ")"

  syntax AstObject ::=
    toAstObject(Object) [function]

  rule toAstObject(object LS { C }) =>
    AstObject(toAstLiteralString(LS), toAstCode(C), .List)

  rule toAstObject(object LS { C OODS }) =>
    AstObject(toAstLiteralString(LS), toAstCode(C), toAstObjectOrDataSequence(OODS))

  syntax AstObjectOrData ::=
    "AstObjectOrData" "(" AstData ")" |
    "AstObjectOrData" "(" AstObject ")"

  syntax AstObjectOrData ::=
    toAstObjectOrData(ObjectOrData) [function]

  rule toAstObjectOrData(D:Data) =>
    AstObjectOrData(toAstData(D))

  rule toAstObjectOrData(O:Object) =>
    AstObjectOrData(toAstObject(O))

  syntax AstObjectOrDataSequence ::=
    List

  syntax List ::=
    toAstObjectOrDataSequence(ObjectOrDataSequence) [function]

  rule toAstObjectOrDataSequence(OOD) =>
    ListItem(toAstObjectOrData(OOD))

  rule toAstObjectOrDataSequence(OODS OOD) =>
    toAstObjectOrDataSequence(OODS) ListItem(toAstObjectOrData(OOD))

  syntax AstProgram ::=
    "AstProgram" "(" AstBlock ")" |
    "AstProgram" "(" AstObject ")"

  syntax AstProgram ::=
    toAstProgram(Program) [function]

  rule toAstProgram(O:Object) =>
    AstProgram(toAstObject(O))

  rule toAstProgram(B:Block) =>
    AstProgram(toAstBlock(B))

  syntax AstStatement ::=
    "AstStatement" "(" AstAssignment ")"
      [klabel(AstStatement1)] |
    "AstStatement" "(" AstBlock ")"
      [klabel(AstStatement2)] |
    "AstStatement" "(" AstBreak ")"
      [klabel(AstStatement3)] |
    "AstStatement" "(" AstContinue ")"
      [klabel(AstStatement4)] |
    "AstStatement" "(" AstDebug ")"
      [klabel(AstStatement5)] |
    "AstStatement" "(" AstExpression ")"
      [klabel(AstStatement6)] |
    "AstStatement" "(" AstFor ")"
      [klabel(AstStatement7)] |
    "AstStatement" "(" AstFunctionDefinition ")"
      [klabel(AstStatement8)] |
    "AstStatement" "(" AstIf ")"
      [klabel(AstStatement9)] |
    "AstStatement" "(" AstSwitch ")"
      [klabel(AstStatement10)] |
    "AstStatement" "(" AstVariableDeclaration ")"
      [klabel(AstStatement11)]

  syntax AstStatement ::=
    toAstStatement(Statement) [function]

  rule toAstStatement(A:Assignment) =>
    AstStatement(toAstAssignment(A))

  rule toAstStatement(B:Block) =>
    AstStatement(toAstBlock(B))

  rule toAstStatement(B:Break) =>
    AstStatement(toAstBreak(B))

  rule toAstStatement(C:Continue) =>
    AstStatement(toAstContinue(C))

  rule toAstStatement(D:Debug) =>
    AstStatement(toAstDebug(D))

  rule toAstStatement(E:Expression) =>
    AstStatement(toAstExpression(E))

  rule toAstStatement(F:For) =>
    AstStatement(toAstFor(F))

  rule toAstStatement(FD:FunctionDefinition) =>
    AstStatement(toAstFunctionDefinition(FD))

  rule toAstStatement(I:If) =>
    AstStatement(toAstIf(I))

  rule toAstStatement(S:Switch) =>
    AstStatement(toAstSwitch(S))

  rule toAstStatement(VD:VariableDeclaration) =>
    AstStatement(toAstVariableDeclaration(VD))

  syntax AstStatementSequence ::=
    List

  syntax List ::=
    toAstStatementSequence(StatementSequence) [function]

  rule toAstStatementSequence(S) =>
    ListItem(toAstStatement(S))

  rule toAstStatementSequence(SS S) =>
    toAstStatementSequence(SS) ListItem(toAstStatement(S))

  syntax AstSwitch ::=
    "AstSwitch" "(" AstExpression "," AstCaseSequence "," AstDefault ")"

  syntax AstSwitch ::=
    toAstSwitch(Switch) [function]

  rule toAstSwitch(switch E CS:CaseSequence) =>
    AstSwitch(toAstExpression(E), toAstCaseSequence(CS), .AstDefault)

  rule toAstSwitch(switch E CS:CaseSequence D:Default) =>
    AstSwitch(toAstExpression(E), toAstCaseSequence(CS), toAstDefault(D))

  rule toAstSwitch(switch E D:Default) =>
    AstSwitch(toAstExpression(E), .List, toAstDefault(D))

  syntax AstTypedIdentifier ::=
    "AstTypedIdentifier" "(" AstIdentifier "," AstTypeName ")"

  syntax AstTypedIdentifier ::=
    toAstTypedIdentifier(TypedIdentifier) [function]

  rule toAstTypedIdentifier(I : TN) =>
    AstTypedIdentifier(toAstIdentifier(I), toAstTypeName(TN))

  syntax AstTypedIdentifierList ::=
    List

  syntax List ::=
    toAstTypedIdentifierList(TypedIdentifierList) [function]

  rule toAstTypedIdentifierList(TI) =>
    ListItem(toAstTypedIdentifier(TI))

  rule toAstTypedIdentifierList(TIL , TI) =>
    toAstTypedIdentifierList(TIL) ListItem(toAstTypedIdentifier(TI))

  syntax AstTypedLiteral ::=
    "AstTypedLiteral" "(" AstLiteral "," AstTypeName ")"

  syntax AstTypedLiteral ::=
    toAstTypedLiteral(TypedLiteral) [function]

  rule toAstTypedLiteral(L : TN) =>
    AstTypedLiteral(toAstLiteral(L), toAstTypeName(TN))

  syntax AstTypeName ::=
    "AstTypeName" "(" AstIdentifier ")" |
    "AstTypeName" "(" AstTypeNameBuiltIn ")"

  syntax AstTypeName ::=
    toAstTypeName(TypeName) [function]

  rule toAstTypeName(I:Identifier) =>
    AstTypeName(toAstIdentifier(I))

  rule toAstTypeName(TNBI:TypeNameBuiltIn) =>
    AstTypeName(toAstTypeNameBuiltIn(TNBI))

  syntax AstTypeNameBuiltIn ::=
    "AstTypeNameBuiltIn" "(" TypeNameBuiltIn ")"

  syntax AstTypeNameBuiltIn ::=
    toAstTypeNameBuiltIn(TypeNameBuiltIn) [function]

  rule toAstTypeNameBuiltIn(TNBI) =>
    AstTypeNameBuiltIn(TNBI)

  syntax AstVariableDeclaration ::=
    "AstVariableDeclaration" "(" AstTypedIdentifierList ")" |
    "AstVariableDeclaration" "(" AstTypedIdentifierList "," AstExpression ")"

  syntax AstVariableDeclaration ::=
    toAstVariableDeclaration(VariableDeclaration) [function]

  rule toAstVariableDeclaration(let TIL) =>
    AstVariableDeclaration(toAstTypedIdentifierList(TIL))

  rule toAstVariableDeclaration(let TIL := E) =>
    AstVariableDeclaration(toAstTypedIdentifierList(TIL), toAstExpression(E))

endmodule

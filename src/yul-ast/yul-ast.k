requires "../yul-syntax/yul-syntax.k"

module YUL-AST
  imports DOMAINS
  imports YUL-SYNTAX

  /**
   * AST Nodes.
   */

  syntax AstProgram ::=
    AstBlock |
    AstObject

  syntax AstBlock ::=
    AstBlock(statementSequence:List)

  syntax AstStatement ::=
    AstAssignment |
    AstBlock |
    AstDebug |
    AstExpression |
    AstFor |
    AstFunctionDefinition |
    AstIf |
    AstSwitch |
    AstVariableDeclaration |
    Break |
    Continue

  syntax AstAssignment ::=
    AstAssignment(identifierList:List, AstExpression)

  syntax AstExpression ::=
    AstFunctionCall |
    AstTypedLiteral |
    Identifier

  syntax AstFunctionCall ::=
    AstFunctionCall(Identifier, expressionList:List)

  syntax AstTypedLiteral ::=
    AstTypedLiteral(Literal, TypeName)

  syntax AstDebug ::=
    AstDebug(Identifier)

  syntax AstFor ::=
    AstFor(AstBlock, AstExpression, AstBlock, AstBlock)

  syntax AstFunctionDefinition ::=
    AstFunctionDefinition(
      Identifier,
      typedIdentifierList1:List,
      typedIdentifierList2:List,
      AstBlock
    )

  syntax AstTypedIdentifier ::=
    AstTypedIdentifier(Identifier, TypeName)

  syntax AstIf ::=
    AstIf(AstExpression, AstBlock)

  syntax AstSwitch ::=
    AstSwitch1(AstExpression, caseSequence:List) |
    AstSwitch2(AstExpression, caseSequence:List, AstDefault)

  syntax AstCase ::=
    AstCase(AstTypedLiteral, AstBlock)

  syntax AstDefault ::=
    AstDefault(AstBlock)

  syntax AstVariableDeclaration ::=
    AstVariableDeclaration1(typedIdentifierList:List) |
    AstVariableDeclaration2(typedIdentifierList:List, AstExpression)

  syntax AstObject ::=
    AstObject(LiteralString, AstCode, objectOrDataSequence:List)

  syntax AstCode ::=
    AstCode(AstBlock)

  syntax AstObjectOrData ::=
    AstData |
    AstObject

  syntax AstData ::=
    AstData1(LiteralString, LiteralHex) |
    AstData2(LiteralString, LiteralString)

  /**
   * toAstProgram
   */

  syntax AstProgram ::=
    toAstProgram(Program) [function]

  rule
    toAstProgram(B:Block) =>
    toAstBlock(B)

  rule
    toAstProgram(O:Object) =>
    toAstObject(O)

  /**
   * toAstBlock
   */

  syntax AstBlock ::=
    toAstBlock(Block) [function]

  rule
    toAstBlock(`Block1`(.KList)) =>
    AstBlock(.List)

  rule
    toAstBlock(`Block2`(SS:StatementSequence)) =>
    AstBlock(toAstStatementSequence(SS))

  /**
   * toAstStatementSequence
   */

  syntax List ::=
    toAstStatementSequence(StatementSequence) [function]

  rule
    toAstStatementSequence(S:Statement) =>
    ListItem(toAstStatement(S))

  rule
    toAstStatementSequence(`StatementSequence`(
      SS:StatementSequence,
      S:Statement
    )) =>
    toAstStatementSequence(SS) ListItem(toAstStatement(S))

  /**
   * toAstStatement
   */

  syntax AstStatement ::=
    toAstStatement(Statement) [function]

  rule
    toAstStatement(A:Assignment) =>
    toAstAssignment(A)

  rule
    toAstStatement(B:Block) =>
    toAstBlock(B)

  rule
    toAstStatement(B:Break) =>
    B

  rule
    toAstStatement(C:Continue) =>
    C

  rule
    toAstStatement(D:Debug) =>
    toAstDebug(D)

  rule
    toAstStatement(E:Expression) =>
    toAstExpression(E)

  rule
    toAstStatement(F:For) =>
    toAstFor(F)

  rule
    toAstStatement(FD:FunctionDefinition) =>
    toAstFunctionDefinition(FD)

  rule
    toAstStatement(I:If) =>
    toAstIf(I)

  rule
    toAstStatement(S:Switch) =>
    toAstSwitch(S)

  rule
    toAstStatement(VD:VariableDeclaration) =>
    toAstVariableDeclaration(VD)

  /**
   * toAstAssignment
   */

  syntax AstAssignment ::=
    toAstAssignment(Assignment) [function]

  rule
    toAstAssignment(`Assignment`(IL:IdentifierList, E:Expression)) =>
    AstAssignment(toAstIdentifierList(IL), toAstExpression(E))

  /**
   * toAstIdentifierList
   */

  syntax List ::=
    toAstIdentifierList(IdentifierList) [function]

  rule
    toAstIdentifierList(I:Identifier) =>
    ListItem(I)

  rule
    toAstIdentifierList(`IdentifierList`(IL:IdentifierList, I:Identifier)) =>
    toAstIdentifierList(IL) ListItem(I)

  /**
   * toAstExpression
   */

  syntax AstExpression ::=
    toAstExpression(Expression) [function]

  rule
    toAstExpression(FC:FunctionCall) =>
    toAstFunctionCall(FC)

  rule
    toAstExpression(I:Identifier) =>
    I

  rule
    toAstExpression(TL:TypedLiteral) =>
    toAstTypedLiteral(TL)

  /**
   * toAstFunctionCall
   */

  syntax AstFunctionCall ::=
    toAstFunctionCall(FunctionCall) [function]

  rule
    toAstFunctionCall(`FunctionCall1`(I:Identifier)) =>
    AstFunctionCall(I, .List)

  rule
    toAstFunctionCall(`FunctionCall2`(I:Identifier, EL:ExpressionList)) =>
    AstFunctionCall(I, toAstExpressionList(EL))

  /**
   * toAstExpressionList
   */

  syntax List ::=
    toAstExpressionList(ExpressionList) [function]

  rule
    toAstExpressionList(E:Expression) =>
    ListItem(toAstExpression(E))

  rule
    toAstExpressionList(`ExpressionList`(EL:ExpressionList, E:Expression)) =>
    toAstExpressionList(EL) ListItem(toAstExpression(E))

  /**
   * toAstTypedLiteral
   */

  syntax AstTypedLiteral ::=
    toAstTypedLiteral(TypedLiteral) [function]

  rule
    toAstTypedLiteral(`TypedLiteral`(L:Literal, TN:TypeName)) =>
    AstTypedLiteral(L, TN)

  /**
   * toAstDebug
   */

  syntax AstDebug ::=
    toAstDebug(Debug) [function]

  rule
    toAstDebug(`Debug`(I:Identifier)) =>
    AstDebug(I)

  /**
   * toAstFor
   */

  syntax AstFor ::=
    toAstFor(For) [function]

  rule
    toAstFor(`For`(B1:Block, E:Expression, B2:Block, B3:Block)) =>
    AstFor(toAstBlock(B1), toAstExpression(E), toAstBlock(B2), toAstBlock(B3))

  /**
   * toAstFunctionDefinition
   */

  syntax AstFunctionDefinition ::=
    toAstFunctionDefinition(FunctionDefinition) [function]

  rule
    toAstFunctionDefinition(`FunctionDefinition1`(I:Identifier, B:Block)) =>
    AstFunctionDefinition(I, .List, .List, toAstBlock(B))

  rule
    toAstFunctionDefinition(
      `FunctionDefinition2`(I:Identifier, TIL:TypedIdentifierList, B:Block)
    ) =>
    AstFunctionDefinition(I, toAstTypedIdentifierList(TIL), .List, toAstBlock(B))

  rule
    toAstFunctionDefinition(
      `FunctionDefinition3`(I:Identifier, TIL:TypedIdentifierList, B:Block)
    ) =>
    AstFunctionDefinition(I, .List, toAstTypedIdentifierList(TIL), toAstBlock(B))

  rule
    toAstFunctionDefinition(
      `FunctionDefinition4`(
        I:Identifier,
        TIL1:TypedIdentifierList,
        TIL2:TypedIdentifierList,
        B:Block
      )
    ) =>
    AstFunctionDefinition(
      I,
      toAstTypedIdentifierList(TIL1),
      toAstTypedIdentifierList(TIL2),
      toAstBlock(B)
    )

  /**
   * toAstTypedIdentifierList
   */

  syntax List ::=
    toAstTypedIdentifierList(TypedIdentifierList) [function]

  rule
    toAstTypedIdentifierList(TI:TypedIdentifier) =>
    ListItem(toAstTypedIdentifier(TI))

  rule
    toAstTypedIdentifierList(`TypedIdentifierList`(TIL:TypedIdentifierList, TI:TypedIdentifier)) =>
    toAstTypedIdentifierList(TIL) ListItem(toAstTypedIdentifier(TI))

  /**
   * toAstTypedIdentifier
   */

  syntax AstTypedIdentifier ::=
    toAstTypedIdentifier(TypedIdentifier) [function]

  rule
    toAstTypedIdentifier(`TypedIdentifier`(I:Identifier, TN:TypeName)) =>
    AstTypedIdentifier(I, TN)

  /**
   * toAstIf
   */

  syntax AstIf ::=
    toAstIf(If) [function]

  rule
    toAstIf(`If`(E:Expression, B:Block)) =>
    AstIf(toAstExpression(E), toAstBlock(B))

  /**
   * toAstSwitch
   */

  syntax AstSwitch ::=
    toAstSwitch(Switch) [function]

  rule
    toAstSwitch(`Switch1`(E:Expression, CS:CaseSequence)) =>
    AstSwitch1(toAstExpression(E), toAstCaseSequence(CS))

  rule
    toAstSwitch(`Switch2`(E:Expression, CS:CaseSequence, D:Default)) =>
    AstSwitch2(toAstExpression(E), toAstCaseSequence(CS), toAstDefault(D))

  rule
    toAstSwitch(`Switch3`(E:Expression, D:Default)) =>
    AstSwitch2(toAstExpression(E), .List, toAstDefault(D))

  /**
   * toAstCaseSequence
   */

  syntax List ::=
    toAstCaseSequence(CaseSequence) [function]

  rule
    toAstCaseSequence(C:Case) =>
    ListItem(toAstCase(C))

  rule
    toAstCaseSequence(`CaseSequence`(CS:CaseSequence, C:Case)) =>
    toAstCaseSequence(CS) ListItem(toAstCase(C))

  /**
   * toAstCase
   */

  syntax AstCase ::=
    toAstCase(Case) [function]

  rule
    toAstCase(`Case`(TL:TypedLiteral, B:Block)) =>
    AstCase(toAstTypedLiteral(TL), toAstBlock(B))

  /**
   * toAstDefault
   */

  syntax AstDefault ::=
    toAstDefault(Default) [function]

  rule
    toAstDefault(`Default`(B:Block)) =>
    AstDefault(toAstBlock(B))

  /**
   * toAstVariableDeclaration
   */

  syntax AstVariableDeclaration ::=
    toAstVariableDeclaration(VariableDeclaration) [function]

  rule
    toAstVariableDeclaration(`VariableDeclaration1`(TIL:TypedIdentifierList)) =>
    AstVariableDeclaration1(toAstTypedIdentifierList(TIL))

  rule
    toAstVariableDeclaration(`VariableDeclaration2`(TIL:TypedIdentifierList, E:Expression)) =>
    AstVariableDeclaration2(toAstTypedIdentifierList(TIL), toAstExpression(E))

  /**
   * toAstObject
   */

  syntax AstObject ::=
    toAstObject(Object) [function]

  rule
    toAstObject(`Object1`(LS:LiteralString, C:Code)) =>
    AstObject(LS, toAstCode(C), .List)

  rule
    toAstObject(`Object2`(LS:LiteralString, C:Code, OODS:ObjectOrDataSequence)) =>
    AstObject(LS, toAstCode(C), toAstObjectOrDataSequence(OODS))

  /**
   * toAstCode
   */

  syntax AstCode ::=
    toAstCode(Code) [function]

  rule
    toAstCode(`Code`(B:Block)) =>
    AstCode(toAstBlock(B))

  /**
   * toAstObjectOrDataSequence
   */

  syntax List ::=
    toAstObjectOrDataSequence(ObjectOrDataSequence) [function]

  rule
    toAstObjectOrDataSequence(OOD:ObjectOrData) =>
    ListItem(toAstObjectOrData(OOD))

  rule
    toAstObjectOrDataSequence(
      `ObjectOrDataSequence`(OODS:ObjectOrDataSequence, OOD:ObjectOrData)
    ) =>
    toAstObjectOrDataSequence(OODS) ListItem(toAstObjectOrData(OOD))

  /**
   * toAstObjectOrData
   */

  syntax AstObjectOrData ::=
    toAstObjectOrData(ObjectOrData) [function]

  rule
    toAstObjectOrData(D:Data) =>
    toAstData(D)

  rule
    toAstObjectOrData(O:Object) =>
    toAstObject(O)

  /**
   * toAstData
   */

  syntax AstData ::=
    toAstData(Data) [function]

  rule
    toAstData(`Data1`(LS:LiteralString, LH:LiteralHex)) =>
    AstData1(LS, LH)

  rule
    toAstData(`Data2`(LS1:LiteralString, LS2:LiteralString)) =>
    AstData2(LS1, LS2)

endmodule

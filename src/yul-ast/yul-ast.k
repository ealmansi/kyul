require "../yul-syntax/yul-syntax.k"

module YUL-AST
  imports DOMAINS
  imports YUL-SYNTAX

  syntax AstAssignment ::=
    "#AstAssignment" List AstExpression |
    toAstAssignment(Assignment) [function]

  rule
    toAstAssignment(`Assignment`(
      IL:IdentifierList,
      E:Expression
    )) =>
    #AstAssignment toAstIdentifierList(IL) toAstExpression(E)

  syntax AstBlock ::=
    "#AstBlock" List [klabel(AstBlock)] |
    toAstBlock(Block) [function]

  rule
    toAstBlock(`Block1`(
      .KList
    )) =>
    #AstBlock .List

  rule
    toAstBlock(`Block2`(
      SS:StatementSequence
    )) =>
    #AstBlock toAstStatementSequence(SS)

  syntax AstCase ::=
    "#AstCase" AstTypedLiteral AstBlock |
    toAstCase(Case) [function]

  rule
    toAstCase(`Case`(
      TL:TypedLiteral,
      B:Block
    )) =>
    #AstCase toAstTypedLiteral(TL) toAstBlock(B)

  syntax List ::=
    toAstCaseSequence(CaseSequence) [function]

  rule
    toAstCaseSequence(C:Case) =>
    ListItem(toAstCase(C))

  rule
    toAstCaseSequence(`CaseSequence`(
      CS:CaseSequence,
      C:Case
    )) =>
    toAstCaseSequence(CS) ListItem(toAstCase(C))

  syntax AstCode ::=
    "#AstCode" AstBlock |
    toAstCode(Code) [function]

  rule
    toAstCode(`Code`(
      B:Block
    )) =>
    #AstCode toAstBlock(B)

  syntax AstData ::=
    "#AstData1" LiteralString LiteralHex |
    "#AstData2" LiteralString LiteralString |
    toAstData(Data) [function]

  rule
    toAstData(`Data1`(
      LS:LiteralString,
      LH:LiteralHex
    )) =>
    #AstData1 LS LH

  rule
    toAstData(`Data2`(
      LS1:LiteralString,
      LS2:LiteralString
    )) =>
    #AstData2 LS1 LS2

  syntax AstDebug ::=
    "#AstDebug" Identifier |
    toAstDebug(Debug) [function]

  rule
    toAstDebug(`Debug`(
      I:Identifier
    )) =>
    #AstDebug I

  syntax AstDefault ::=
    "#AstDefault" AstBlock |
    toAstDefault(Default) [function]

  rule
    toAstDefault(`Default`(
      B:Block
    )) =>
    #AstDefault toAstBlock(B)

  syntax AstExpression ::=
    AstFunctionCall |
    AstTypedLiteral |
    Identifier |
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

  syntax List ::=
    toAstExpressionList(ExpressionList) [function]

  rule
    toAstExpressionList(E:Expression) =>
    ListItem(toAstExpression(E))

  rule
    toAstExpressionList(`ExpressionList`(
      EL:ExpressionList,
      E:Expression
    )) =>
    toAstExpressionList(EL) ListItem(toAstExpression(E))

  syntax AstFor ::=
    "#AstFor" AstBlock AstExpression AstBlock AstBlock |
    toAstFor(For) [function]

  rule
    toAstFor(`For`(
      B1:Block
      E:Expression
      B2:Block
      B3:Block
    )) =>
    #AstFor toAstBlock(B1) toAstExpression(E) toAstBlock(B2) toAstBlock(B3)

  syntax AstFunctionCall ::=
    "#AstFunctionCall" Identifier List [klabel(AstFunctionCall)] |
    toAstFunctionCall(FunctionCall) [function]

  rule
    toAstFunctionCall(`FunctionCall1`(
      I:Identifier
    )) =>
    #AstFunctionCall I .List

  rule
    toAstFunctionCall(`FunctionCall2`(
      I:Identifier,
      EL:ExpressionList
    )) =>
    #AstFunctionCall I toAstExpressionList(EL)

  syntax AstFunctionDefinition ::=
    "#AstFunctionDefinition" Identifier List List AstBlock [klabel(AstFunctionDefinition)] |
    toAstFunctionDefinition(FunctionDefinition) [function]

  rule
    toAstFunctionDefinition(`FunctionDefinition1`(
      I:Identifier,
      B:Block
    )) =>
    #AstFunctionDefinition I .List .List toAstBlock(B)

  rule
    toAstFunctionDefinition(`FunctionDefinition2`(
      I:Identifier,
      TIL:TypedIdentifierList,
      B:Block
    )) =>
    #AstFunctionDefinition I toAstTypedIdentifierList(TIL) .List toAstBlock(B)

  rule
    toAstFunctionDefinition(`FunctionDefinition3`(
      I:Identifier,
      TIL:TypedIdentifierList,
      B:Block
    )) =>
    #AstFunctionDefinition I .List toAstTypedIdentifierList(TIL) toAstBlock(B)

  rule
    toAstFunctionDefinition(`FunctionDefinition4`(
      I:Identifier,
      TIL1:TypedIdentifierList,
      TIL2:TypedIdentifierList,
      B:Block
    )) =>
    #AstFunctionDefinition I toAstTypedIdentifierList(TIL1) toAstTypedIdentifierList(TIL2) toAstBlock(B)

  syntax List ::=
    toAstIdentifierList(IdentifierList) [function]

  rule
    toAstIdentifierList(I:Identifier) =>
    ListItem(I)

  rule
    toAstIdentifierList(`IdentifierList`(
      IL:IdentifierList,
      I:Identifier
    )) =>
    toAstIdentifierList(IL) ListItem(I)

  syntax AstIf ::=
    "#AstIf" AstExpression AstBlock |
    toAstIf(If) [function]

  rule
    toAstIf(`If`(
      E:Expression,
      B:Block
    )) =>
    #AstIf toAstExpression(E) toAstBlock(B)

  syntax AstObject ::=
    "#AstObject" LiteralString AstCode List |
    toAstObject(Object) [function]

  rule
    toAstObject(`Object1`(
      LS:LiteralString,
      C:Code
    )) =>
    #AstObject LS toAstCode(C) .List

  rule
    toAstObject(`Object2`(
      LS:LiteralString,
      C:Code,
      OODS:ObjectOrDataSequence
    )) =>
    #AstObject LS toAstCode(C) toAstObjectOrDataSequence(OODS)

  syntax AstObjectOrData ::=
    AstData |
    AstObject |
    toAstObjectOrData(ObjectOrData) [function]

  rule
    toAstObjectOrData(D:Data) =>
    toAstData(D)

  rule
    toAstObjectOrData(O:Object) =>
    toAstObject(O)

  syntax List ::=
    toAstObjectOrDataSequence(ObjectOrDataSequence) [function]

  rule
    toAstObjectOrDataSequence(OOD:ObjectOrData) =>
    ListItem(toAstObjectOrData(OOD))

  rule
    toAstObjectOrDataSequence(`ObjectOrDataSequence`(
      OODS:ObjectOrDataSequence,
      OOD:ObjectOrData
    )) =>
    toAstObjectOrDataSequence(OODS) ListItem(toAstObjectOrData(OOD))

  syntax AstProgram ::=
    AstBlock |
    AstObject |
    toAstProgram(Program) [function]

  rule
    toAstProgram(B:Block) => toAstBlock(B)

  rule
    toAstProgram(O:Object) => toAstObject(O)

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
    toAstStatement(Statement) [function]
  
  rule
    toAstStatement(A:Assignment) =>
    toAstAssignment(A)

  rule
    toAstStatement(B:Block) =>
    toAstBlock(B)

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

  syntax AstSwitch ::=
    "#AstSwitch1" AstExpression List |
    "#AstSwitch2" AstExpression List AstDefault |
    toAstSwitch(Switch) [function]

  rule
    toAstSwitch(`Switch1`(
      E:Expression,
      CS:CaseSequence
    )) =>
    #AstSwitch1 toAstExpression(E) toAstCaseSequence(CS)

  rule
    toAstSwitch(`Switch2`(
      E:Expression,
      CS:CaseSequence,
      D:Default
    )) =>
    #AstSwitch2 toAstExpression(E) toAstCaseSequence(CS) toAstDefault(D)

  rule
    toAstSwitch(`Switch3`(
      E:Expression,
      D:Default
    )) =>
    #AstSwitch2 toAstExpression(E) .List toAstDefault(D)

  syntax AstTypedIdentifier ::=
    "#AstTypedIdentifier" Identifier TypeName [klabel(AstTypedIdentifier)] |
    toAstTypedIdentifier(TypedIdentifier) [function]

  rule
    toAstTypedIdentifier(`TypedIdentifier`(
      I:Identifier,
      TN:TypeName
    )) =>
    #AstTypedIdentifier I TN

  syntax List ::=
    toAstTypedIdentifierList(TypedIdentifierList) [function]

  rule
    toAstTypedIdentifierList(TI:TypedIdentifier) =>
    ListItem(toAstTypedIdentifier(TI))

  rule
    toAstTypedIdentifierList(`TypedIdentifierList`(
      TIL:TypedIdentifierList,
      TI:TypedIdentifier
    )) =>
    toAstTypedIdentifierList(TIL) ListItem(toAstTypedIdentifier(TI))

  syntax AstTypedLiteral ::=
    "#AstTypedLiteral" Literal TypeName [klabel(AstTypedLiteral)] |
    toAstTypedLiteral(TypedLiteral) [function]

  rule
    toAstTypedLiteral(`TypedLiteral`(
      L:Literal,
      TN:TypeName
    )) =>
    #AstTypedLiteral L TN

  syntax AstVariableDeclaration ::=
    "#AstVariableDeclaration1" List [klabel(AstVariableDeclaration1)] |
    "#AstVariableDeclaration2" List AstExpression [klabel(AstVariableDeclaration2)] |
    toAstVariableDeclaration(VariableDeclaration) [function]

  rule
    toAstVariableDeclaration(`VariableDeclaration1`(
      TIL:TypedIdentifierList
    )) =>
    #AstVariableDeclaration1 toAstTypedIdentifierList(TIL)

  rule
    toAstVariableDeclaration(`VariableDeclaration2`(
      TIL:TypedIdentifierList,
      E:Expression
    )) =>
    #AstVariableDeclaration2 toAstTypedIdentifierList(TIL) toAstExpression(E)

endmodule

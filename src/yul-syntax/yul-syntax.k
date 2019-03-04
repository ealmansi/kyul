module YUL-SYNTAX
  imports DOMAINS-SYNTAX
  imports INT-SYNTAX

  syntax Assignment ::=
    IdentifierList ":=" Expression
      [klabel(Assignment)]

  syntax Block ::=
    "{" "}"
      [klabel(Block1)] |
    "{" StatementSequence "}"
      [klabel(Block2)]

  syntax Break ::=
    "break"
      [klabel(Break)]

  syntax Case ::=
    "case" TypedLiteral Block
      [klabel(Case)]

  syntax CaseSequence ::=
    Case |
    CaseSequence Case
      [klabel(CaseSequence)]

  syntax Code ::=
    "code" Block
      [klabel(Code)]

  syntax Continue ::=
    "continue"
      [klabel(Continue)]

  syntax Data ::=
    "data" LiteralString LiteralHex
      [klabel(Data1)] |
    "data" LiteralString LiteralString
      [klabel(Data2)]

  syntax Debug ::=
    "#debug"
      [klabel(Debug)]

  syntax Default ::=
    "default" Block
      [klabel(Default)]

  syntax Expression ::=
    FunctionCall |
    Identifier |
    TypedLiteral

  syntax ExpressionList ::=
    Expression |
    ExpressionList "," Expression
      [klabel(ExpressionList)]

  syntax For ::=
    "for" Block Expression Block Block
      [klabel(For)]

  syntax FunctionCall ::=
    Identifier "(" ")"
      [klabel(FunctionCall1)] |
    Identifier "(" ExpressionList ")"
      [klabel(FunctionCall2)]

  syntax FunctionDefinition ::=
    "function" Identifier "(" ")" Block
      [klabel(FunctionDefinition1)] |
    "function" Identifier "(" TypedIdentifierList ")" Block
      [klabel(FunctionDefinition2)] |
    "function" Identifier "(" ")" "->" TypedIdentifierList Block
      [klabel(FunctionDefinition3)] |
    "function" Identifier "(" TypedIdentifierList ")" "->" TypedIdentifierList Block
      [klabel(FunctionDefinition4)]

  syntax Identifier ::=
    Id

  syntax IdentifierList ::=
    Identifier |
    IdentifierList "," Identifier
      [klabel(IdentifierList)]

  syntax If ::=
    "if" Expression Block
      [klabel(If)]

  syntax Literal ::=
    LiteralBool |
    LiteralHex |
    LiteralNumber |
    LiteralString

  syntax LiteralBool ::=
    Bool

  syntax LiteralHex ::=
    LiteralHexDouble |
    LiteralHexSingle

  syntax LiteralHexDouble ::=
    r"hex\\\"([0-9a-fA-F][0-9a-fA-F])*\\\""
      [klabel(LiteralHexDouble), prefer, token, prec(4)]

  syntax LiteralHexSingle ::=
    r"hex'([0-9a-fA-F][0-9a-fA-F])*'"
      [klabel(LiteralHexSingle), prefer, token, prec(4)]

  syntax LiteralNumber ::=
    LiteralNumberInt |
    LiteralNumberHex

  syntax LiteralNumberHex ::=
    r"0x[0-9a-fA-F][0-9a-fA-F]*"
      [klabel(LiteralNumberHex), prefer, token, prec(4)]

  syntax LiteralNumberInt ::=
    Int

  syntax LiteralString ::=
    String

  syntax Object ::=
    "object" LiteralString "{" Code "}"
      [klabel(Object1)] |
    "object" LiteralString "{" Code ObjectOrDataSequence "}"
      [klabel(Object2)]

  syntax ObjectOrData ::=
    Data |
    Object

  syntax ObjectOrDataSequence ::=
    ObjectOrData |
    ObjectOrDataSequence ObjectOrData
      [klabel(ObjectOrDataSequence)]

  syntax Program ::=
    Block |
    Object

  syntax Statement ::=
    Assignment |
    Block |
    Break |
    Continue |
    Debug |
    Expression |
    For |
    FunctionDefinition |
    If |
    Switch |
    VariableDeclaration

  syntax StatementSequence ::=
    Statement |
    StatementSequence Statement
      [klabel(StatementSequence)]

  syntax Switch ::=
    "switch" Expression CaseSequence
      [klabel(Switch1)] |
    "switch" Expression CaseSequence Default
      [klabel(Switch2)] |
    "switch" Expression Default
      [klabel(Switch3)]

  syntax TypedIdentifier ::=
    Identifier ":" TypeName
      [klabel(TypedIdentifier)]

  syntax TypedIdentifierList ::=
    TypedIdentifier |
    TypedIdentifierList "," TypedIdentifier
      [klabel(TypedIdentifierList)]

  syntax TypedLiteral ::=
    Literal ":" TypeName
      [klabel(TypedLiteral)]

  syntax TypeName ::=
    Identifier |
    TypeNameBuiltIn

  syntax TypeNameBuiltIn ::=
    "bool" [token] |
    "u8" [token] |
    "u32" [token] |
    "u64" [token] |
    "u128" [token] |
    "u256" [token] |
    "s8" [token] |
    "s32" [token] |
    "s64" [token] |
    "s128" [token] |
    "s256" [token]

  syntax VariableDeclaration ::=
    "let" TypedIdentifierList
      [klabel(VariableDeclaration1)] |
    "let" TypedIdentifierList ":=" Expression
      [klabel(VariableDeclaration2)]

endmodule

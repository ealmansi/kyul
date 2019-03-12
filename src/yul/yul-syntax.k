module YUL-SYNTAX
  imports DOMAINS-SYNTAX
  imports INT-SYNTAX

  syntax Program ::=
    Block |
    Object

  syntax Block ::=
    "{" "}" [klabel(Block1)] |
    "{" StatementSequence "}" [klabel(Block2)]

  syntax StatementSequence ::=
    Statement |
    StatementSequence Statement [klabel(StatementSequence)]

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

  syntax Assignment ::=
    IdentifierList ":=" Expression [klabel(Assignment)]

  syntax IdentifierList ::=
    Identifier |
    IdentifierList "," Identifier [klabel(IdentifierList)]

  syntax Identifier ::=
    Id |
    IdentifierBuiltInFunction

  syntax IdentifierBuiltInFunction ::=
    IdentifierBuiltInFunctionArithmetic |
    IdentifierBuiltInFunctionExecutionControl |
    IdentifierBuiltInFunctionLogic |
    IdentifierBuiltInFunctionOther |
    IdentifierBuiltInFunctionState |
    IdentifierBuiltInFunctionStorage |
    IdentifierBuiltInFunctionTypeConversion

  syntax IdentifierBuiltInFunctionArithmetic ::=
    "addmodu256" [token] |
    "addu256" [token] |
    "andu256" [token] |
    "byte" [token] |
    "divs256" [token] |
    "divu256" [token] |
    "equ256" [token] |
    "expu256" [token] |
    "gts256" [token] |
    "gtu256" [token] |
    "iszerou256" [token] |
    "lts256" [token] |
    "ltu256" [token] |
    "mods256" [token] |
    "modu256" [token] |
    "mulmodu256" [token] |
    "mulu256" [token] |
    "notu256" [token] |
    "oru256" [token] |
    "sars256" [token] |
    "shlu256" [token] |
    "shru256" [token] |
    "signextendu256" [token] |
    "subu256" [token] |
    "xoru256" [token]

  syntax IdentifierBuiltInFunctionExecutionControl ::=
    "abort" [token] |
    "call" [token] |
    "callcode" [token] |
    "create" [token] |
    "create2" [token] |
    "delegatecall" [token] |
    "log0" [token] |
    "log1" [token] |
    "log2" [token] |
    "log3" [token] |
    "log4" [token] |
    "return" [token] |
    "revert" [token] |
    "selfdestruct" [token]

  syntax IdentifierBuiltInFunctionLogic ::=
    "and" [token] |
    "not" [token] |
    "or" [token] |
    "xor" [token]

  syntax IdentifierBuiltInFunctionOther ::=
    "combineu64tou256" [token] |
    "datacopy" [token] |
    "discard" [token] |
    "discardu256" [token] |
    "keccak256" [token] |
    "splitu256tou64" [token]

  syntax IdentifierBuiltInFunctionState ::=
    "balance" [token] |
    "blockcoinbase" [token] |
    "blockdifficulty" [token] |
    "blockgaslimit" [token] |
    "blockhash" [token] |
    "blocknumber" [token] |
    "blocktimestamp" [token] |
    "calldatacopy" [token] |
    "calldataload" [token] |
    "calldatasize" [token] |
    "caller" [token] |
    "callvalue" [token] |
    "codecopy" [token] |
    "codesize" [token] |
    "extcodecopy" [token] |
    "extcodehash" [token] |
    "extcodesize" [token] |
    "gasleft" [token] |
    "this" [token] |
    "txgasprice" [token] |
    "txorigin" [token]

  syntax IdentifierBuiltInFunctionStorage ::=
    "mload" [token] |
    "msize" [token] |
    "mstore" [token] |
    "mstore8" [token] |
    "sload" [token] |
    "sstore" [token]

  syntax IdentifierBuiltInFunctionTypeConversion ::=
    "booltos256" [token] |
    "booltou256" [token] |
    "booltou32" [token] |
    "booltou64" [token] |
    "s256tobool" [token] |
    "s256tou256" [token] |
    "s256tou32" [token] |
    "s256tou64" [token] |
    "u256tobool" [token] |
    "u256tos256" [token] |
    "u256tou32" [token] |
    "u256tou64" [token] |
    "u32tobool" [token] |
    "u32tos256" [token] |
    "u32tou256" [token] |
    "u32tou64" [token] |
    "u64tobool" [token] |
    "u64tos256" [token] |
    "u64tou256" [token] |
    "u64tou32" [token]

  syntax Expression ::=
    FunctionCall |
    Identifier |
    TypedLiteral

  syntax FunctionCall ::=
    Identifier "(" ")" [klabel(FunctionCall1)] |
    Identifier "(" ExpressionList ")" [klabel(FunctionCall2)]

  syntax ExpressionList ::=
    Expression |
    ExpressionList "," Expression [klabel(ExpressionList)]

  syntax TypedLiteral ::=
    Literal ":" TypeName [klabel(TypedLiteral)]

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
    r"hex\\\"([0-9a-fA-F][0-9a-fA-F])*\\\"" [token]

  syntax LiteralHexSingle ::=
    r"hex'([0-9a-fA-F][0-9a-fA-F])*'" [token]

  syntax LiteralNumber ::=
    LiteralNumberInt |
    LiteralNumberHex

  syntax LiteralNumberHex ::=
    r"0x[0-9a-fA-F][0-9a-fA-F]*" [token]

  syntax LiteralNumberInt ::=
    Int

  syntax LiteralString ::=
    String

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

  syntax Break ::=
    "break" [token]

  syntax Continue ::=
    "continue" [token]

  syntax Debug ::=
    "#debug" Identifier [klabel(Debug)]

  syntax For ::=
    "for" Block Expression Block Block [klabel(For)]

  syntax FunctionDefinition ::=
    "function" Identifier "(" ")" Block [klabel(FunctionDefinition1)] |
    "function" Identifier "(" TypedIdentifierList ")" Block [klabel(FunctionDefinition2)] |
    "function" Identifier "(" ")" "->" TypedIdentifierList Block [klabel(FunctionDefinition3)] |
    "function" Identifier "(" TypedIdentifierList ")" "->" TypedIdentifierList Block
      [klabel(FunctionDefinition4)]

  syntax TypedIdentifierList ::=
    TypedIdentifier |
    TypedIdentifierList "," TypedIdentifier [klabel(TypedIdentifierList)]

  syntax TypedIdentifier ::=
    Identifier ":" TypeName [klabel(TypedIdentifier)]

  syntax If ::=
    "if" Expression Block [klabel(If)]

  syntax Switch ::=
    "switch" Expression CaseSequence [klabel(Switch1)] |
    "switch" Expression CaseSequence Default [klabel(Switch2)] |
    "switch" Expression Default [klabel(Switch3)]

  syntax CaseSequence ::=
    Case |
    CaseSequence Case [klabel(CaseSequence)]

  syntax Case ::=
    "case" TypedLiteral Block [klabel(Case)]

  syntax Default ::=
    "default" Block [klabel(Default)]

  syntax VariableDeclaration ::=
    "let" TypedIdentifierList [klabel(VariableDeclaration1)] |
    "let" TypedIdentifierList ":=" Expression [klabel(VariableDeclaration2)]

  syntax Object ::=
    "object" LiteralString "{" Code "}" [klabel(Object1)] |
    "object" LiteralString "{" Code ObjectOrDataSequence "}" [klabel(Object2)]

  syntax Code ::=
    "code" Block [klabel(Code)]

  syntax ObjectOrDataSequence ::=
    ObjectOrData |
    ObjectOrDataSequence ObjectOrData [klabel(ObjectOrDataSequence)]

  syntax ObjectOrData ::=
    Data |
    Object

  syntax Data ::=
    "data" LiteralString LiteralHex [klabel(Data1)] |
    "data" LiteralString LiteralString [klabel(Data2)]

endmodule

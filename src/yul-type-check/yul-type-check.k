require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"
require "../yul-utility/yul-utility.k"
require "../yul-value/yul-value.k"

module YUL-TYPE-CHECK
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  syntax KItem ::=
    "#TypeCheck" Program |
    "#TypeCheck" Assignment |
    "#TypeCheck" Block |
    "#TypeCheck" Case |
    "#TypeCheck" CaseSequence |
    "#TypeCheck" Code |
    "#TypeCheck" Data |
    "#TypeCheck" Debug |
    "#TypeCheck" Default |
    "#TypeCheck" ExpressionList |
    "#TypeCheck" For |
    "#TypeCheck" FunctionCall |
    "#TypeCheck" FunctionDefinition |
    "#TypeCheck" IdentifierList |
    "#TypeCheck" If |
    "#TypeCheck" Object |
    "#TypeCheck" ObjectOrDataSequence |
    "#TypeCheck" StatementSequence |
    "#TypeCheck" Switch |
    "#TypeCheck" TypedIdentifier |
    "#TypeCheck" TypedIdentifierList |
    "#TypeCheck" TypedLiteral |
    "#TypeCheck" VariableDeclaration

  rule
    <k>
      P:Program =>
      #TypeCheck P
    </k>

  rule
    <k>
      #TypeCheck `Assignment`(
        IL:IdentifierList,
        E:Expression
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Block1`(
        .KList
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Block2`(
        SS:StatementSequence
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Case`(
        B:Block
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Data1`(
        LS:LiteralString,
        LH:LiteralHex
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Data2`(
        LS1:LiteralString,
        LS2:LiteralString
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Debug`(
        I:Identifier
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `For`(
        B1:Block,
        E:Expression,
        B2:Block,
        B3:Block
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `FunctionCall1`(
        I:Identifier
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `FunctionCall2`(
        I:Identifier,
        EL:ExpressionList
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `FunctionDefinition1`(
        I:Identifier,
        B:Block
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `FunctionDefinition2`(
        I:Identifier,
        TIL:TypedIdentifierList,
        B:Block
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `FunctionDefinition3`(
        I:Identifier,
        TIL:TypedIdentifierList,
        B:Block
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `FunctionDefinition4`(
        I:Identifier,
        TIL1:TypedIdentifierList,
        TIL2:TypedIdentifierList,
        B:Block
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `If`(
        E:Expression,
        B:Block
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Object1`(
        LS:LiteralString,
        C:Code
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Object2`(
        LS:LiteralString,
        C:Code,
        OODS:ObjectOrDataSequence
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `ObjectOrDataSequence`(
        OODS:ObjectOrDataSequence,
        OOD:ObjectOrData
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Switch1`(
        E:Expression,
        CS:CaseSequence
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Switch2`(
        E:Expression,
        CS:CaseSequence,
        D:Default
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `Switch3`(
        E:Expression,
        D:Default
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `VariableDeclaration1`(
        TIL:TypedIdentifierList
      ) =>
      .
    </k>

  rule
    <k>
      #TypeCheck `VariableDeclaration2`(
        TIL:TypedIdentifierList,
        E:Expression
      ) =>
      .
    </k>

endmodule

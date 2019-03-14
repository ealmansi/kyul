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
    "#TypeCheck" VariableDeclaration |
    TypeCheckResult

  syntax Type ::=
    "#Type" |
    "#TypeTuple" Int List

  syntax TypeCheckResult ::=
    "#TypeCheckError" String |
    "#TypeCheckSuccess" Type

  rule
    <k>
      #TypeCheckError S:String ~> _:K =>
      .
    </k>
    <cStdout> ... .List => ListItem(S) </cStdout>

  rule
    <k>
      P:Program =>
      #TypeCheck P
    </k>

  /**
   * Assignment.
   */
  
  syntax KItem ::=
    "#TypeCheckAssignment1" Expression |
    "#TypeCheckAssignment2" Type

  rule
    <k>
      #TypeCheck `Assignment`(
        IL:IdentifierList,
        E:Expression
      ) =>
      #TypeCheck IL ~> #TypeCheckAssignment1 E
      ...
    </k>

  rule
    <k>
      (#TypeCheckSuccess T:Type):TypeCheckResult ~> #TypeCheckAssignment1 E:Expression =>
      #TypeCheck E ~> #TypeCheckAssignment2 T
      ...
    </k>

  rule
    <k>
      (#TypeCheckSuccess T1:Type):TypeCheckResult ~> #TypeCheckAssignment2 T2:Type =>
      #TypeCheckSuccess (#TypeTuple 0 .List)
      ...
    </k>
    requires T1 ==K T2

  rule
    <k>
      (#TypeCheckSuccess T1:Type):TypeCheckResult ~> #TypeCheckAssignment2 T2:Type =>
      #TypeCheckError "Assignment"
      ...
    </k>
    requires T1 =/=K T2

  /**
   * Block.
   */
  
  rule
    <k>
      #TypeCheck `Block1`(
        .KList
      ) =>
      #TypeCheckSuccess (#TypeTuple 0 .List)
      ...
    </k>

  rule
    <k>
      #TypeCheck `Block2`(
        SS:StatementSequence
      ) =>
      #TypeCheckStatementSequence toBuiltInList(SS)
      ...
    </k>
  
  rule
    <k>
      #TypeCheckStatementSequence SS:List =>
      (
        #TypeCheckStatementSequenceFirstPass1 SS ~>
        #TypeCheckStatementSequenceSecondPass SS
      )
      ...
    </k>

  rule
    <k>
      #TypeCheckStatementSequenceFirstPass1 .List =>
      .
      ...
    </k>

  rule
    <k>
      #TypeCheckStatementSequenceFirstPass1 (ListItem(S:Statement) SS:List):List =>
      #IsFunctionDefinition S ~> #TypeCheckStatementSequenceFirstPass2 S SS
      ...
    </k>

  rule
    <k>
      true ~> #TypeCheckStatementSequenceFirstPass2 S:Statement SS:List =>
      (
        #TypeCheckStatementSequenceDefineFunction1 S ~>
        #TypeCheckStatementSequenceFirstPass1 SS
      )
      ...
    </k>

  rule
    <k>
      false ~> #TypeCheckStatementSequenceFirstPass2 S:Statement SS:List =>
      #TypeCheckStatementSequenceFirstPass1 SS
      ...
    </k>

  rule
    <k>
      #TypeCheckStatementSequenceDefineFunction1 `FunctionDefinition1`(
        I:Identifier,
        B:Block
      ) =>
      #TypeCheckStatementSequenceDefineFunction2 I .List .List
      ...
    </k>

  rule
    <k>
      #TypeCheckStatementSequenceDefineFunction1 `FunctionDefinition2`(
        I:Identifier,
        TIL:TypedIdentifierList,
        B:Block
      ) =>
      #TypeCheckStatementSequenceDefineFunction2 I toBuiltInList(TIL) .List
      ...
    </k>

  rule
    <k>
      #TypeCheckStatementSequenceDefineFunction1 `FunctionDefinition3`(
        I:Identifier,
        TIL:TypedIdentifierList,
        B:Block
      ) =>
      #TypeCheckStatementSequenceDefineFunction2 I .List toBuiltInList(TIL)
      ...
    </k>

  rule
    <k>
      #TypeCheckStatementSequenceDefineFunction1 `FunctionDefinition4`(
        I:Identifier,
        TIL1:TypedIdentifierList,
        TIL2:TypedIdentifierList,
        B:Block
      ) =>
      #TypeCheckStatementSequenceDefineFunction2 I toBuiltInList(TIL1) toBuiltInList(TIL2)
      ...
    </k>
  
  rule
    <k>
      #TypeCheckStatementSequenceDefineFunction2 I:Identifier TIL1:List TIL2:List =>
      
      ...
    </k>

  

  // rule
  //   <k>
  //     #TypeCheck `Case`(
  //       TL: TypedLiteral,
  //       B:Block
  //     ) =>
  //     // check t(switch exp) = t(TL)
  //     .
  //   </k>

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
      // check t(E) = bool
      // typecheck B1, B2, B3 (mmm)
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

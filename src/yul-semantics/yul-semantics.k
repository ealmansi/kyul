require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"
require "../yul-utility/yul-utility.k"
require "../yul-value/yul-value.k"

module YUL-SEMANTICS
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  /**
   * Assignment
   */

  syntax KItem ::=
    "#Assignment" List Expression |
    "#AssignmentCool" List |
    "#AssignmentRecursive" List List

  rule
    <k>
      `Assignment`(
        IL:IdentifierList,
        E:Expression
      ) =>
      #Assignment toBuiltInList(IL) E
      ...
    </k>

  rule
    <k>
      #Assignment IL:List E:Expression =>
      E ~> #AssignmentCool IL
      ...
    </k>

  rule
    <k>
      VL:List ~> #AssignmentCool IL:List =>
      #AssignmentRecursive IL VL
      ...
    </k>

  rule
    <k>
      #AssignmentRecursive .List .List =>
      .
      ...
    </k>

  rule
    <k>
      #AssignmentRecursive (ListItem(I) IL):List (ListItem(V) VL):List =>
      #AssignmentRecursive IL VL
      ...
    </k>
    <cVariable>
      <cVariableName> I </cVariableName>
      <cVariableValue> _ => V </cVariableValue>
      ...
    </cVariable>

  /**
   * Block
   */

  syntax KItem ::=
    "#Block" List

  rule
    <k>
      `Block1`(
        .KList
      ) =>
      #Block .List
      ...
    </k>

  rule
    <k>
      `Block2`(
        SS:StatementSequence
      ) =>
      #Block toBuiltInList(SS)
      ...
    </k>

  rule
    <k>
      #Block SS:List =>
      (
        #SymbolTablePush ~>
        #EnvironmentPush ~>
        #StatementSequenceHoist SS ~>
        #EnvironmentPop ~>
        #SymbolTablePop
      )
      ...
    </k>

  /**
   * Break
   */

  syntax KItem ::=
    "#ForBreak" |
    "#ForBreakMarker"

  rule
    <k>
      break =>
      #ForBreak
      ...
    </k>

  rule
    <k>
      #ForBreak ~> KI:KItem =>
      (
        #if (
          (KI ==K #SymbolTablePop) orBool
          (KI ==K #EnvironmentPop)
        )
        #then
          KI ~> #ForBreak
        #else
          #if KI ==K #ForBreakMarker
          #then
            KI
          #else
            #ForBreak
          #fi
        #fi
      )
      ...
    </k>

  rule
    <k>
      #ForBreakMarker =>
      .
      ...
    </k>

  /**
   * Code
   */

  rule
    <k>
      `Code`(
        B:Block
      ) =>
      B
      ...
    </k>

  /**
   * Continue
   */

  syntax KItem ::=
    "#ForContinue" |
    "#ForContinueMarker"

  rule
    <k>
      continue =>
      #ForContinue
      ...
    </k>

  rule
    <k>
      #ForContinue ~> KI:KItem =>
      (
        #if (
          (KI ==K #SymbolTablePop) orBool
          (KI ==K #EnvironmentPop)
        )
        #then
          KI ~> #ForContinue
        #else
          #if KI ==K #ForContinueMarker
          #then
            KI
          #else
            #ForContinue
          #fi
        #fi
      )
      ...
    </k>

  rule
    <k>
      #ForContinueMarker =>
      .
      ...
    </k>

  /**
   * Data
   */

  rule
    <k>
      `Data1`(
        LS:LiteralString,
        LH:LiteralHex
      ) =>
      .
      ...
    </k>

  rule
    <k>
      `Data2`(
        LS1:LiteralString,
        LS2:LiteralString
      ) =>
      .
      ...
    </k>

  /**
   * StatementSequenceHoist
   */

  syntax KItem ::=
    "#StatementSequenceHoist" List |
    "#StatementSequenceHoistRecursive" List List List |
    "#StatementSequenceHoistRecursiveCool" Statement List List List |
    "#StatementSequenceHoistRecursiveHeat" Statement List List List |
    "#StatementSequenceHoistSpread" List

  rule
    <k>
      #StatementSequenceHoist SS:List =>
      #StatementSequenceHoistRecursive SS .List .List
      ...
    </k>

  rule
    <k>
      #StatementSequenceHoistRecursive .List SS1:List SS2:List =>
      #StatementSequenceHoistSpread reverseList(reverseList(SS1) reverseList(SS2))
      ...
    </k>

  rule
    <k>
      #StatementSequenceHoistRecursive (ListItem(S) SS1):List SS2:List SS3:List =>
      #StatementSequenceHoistRecursiveHeat S SS1 SS2 SS3
      ...
    </k>

  rule
    <k>
      #StatementSequenceHoistRecursiveHeat S:Statement SS1:List SS2:List SS3:List =>
      #IsFunctionDefinition S ~> #StatementSequenceHoistRecursiveCool S SS1 SS2 SS3
      ...
    </k>

  rule
    <k>
      true ~> #StatementSequenceHoistRecursiveCool S:Statement SS1:List SS2:List SS3:List =>
      #StatementSequenceHoistRecursive SS1 (ListItem(S) SS2) SS3
      ...
    </k>

  rule
    <k>
      false ~> #StatementSequenceHoistRecursiveCool S:Statement SS1:List SS2:List SS3:List =>
      #StatementSequenceHoistRecursive SS1 SS2 (ListItem(S) SS3)
      ...
    </k>

  rule
    <k>
      #StatementSequenceHoistSpread .List =>
      .
      ...
    </k>

  rule
    <k>
      #StatementSequenceHoistSpread (ListItem(S) SS):List =>
      #StatementSequenceHoistSpread SS ~> S
      ...
    </k>

  /**
   * For
   */

  syntax KItem ::=
    "#For" List Expression Block Block |
    "#ForCool" Expression Block Block |
    "#ForHeat" Expression Block Block

  rule
    <k>
      `For`(
        `Block1`(.KList),
        E:Expression,
        B1:Block,
        B2:Block
      ) =>
      #For .List E B1 B2
      ...
    </k>

  rule
    <k>
      `For`(
        `Block2`(SS:StatementSequence),
        E:Expression,
        B1:Block,
        B2:Block
      ) =>
      #For toBuiltInList(SS) E B1 B2
      ...
    </k>

  rule
    <k>
     #For SS:List E:Expression B1:Block B2:Block =>
      (
        #SymbolTablePush ~>
        #EnvironmentPush ~>
        #StatementSequenceHoist SS ~>
        #ForHeat E B1 B2 ~>
        #ForBreakMarker ~>
        #EnvironmentPop ~>
        #SymbolTablePop
      )
      ...
    </k>

  rule
    <k>
      #ForHeat E:Expression B1:Block B2:Block =>
      E ~> #ForCool E B1 B2
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool true) ~> #ForCool E:Expression B1:Block B2:Block =>
      (
        B2 ~>
        #ForContinueMarker ~>
        B1 ~>
        #ForHeat E B1 B2
      )
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool false) ~> #ForCool E:Expression B1:Block B2:Block =>
      .
      ...
    </k>

  /**
   * FunctionArguments
   */

  syntax KItem ::=
    "#FunctionArguments" List |
    "#FunctionArgumentsRecursive" List List |
    "#FunctionArgumentsRecursiveCool" List List

  rule
    <k>
      #FunctionArguments EL:List =>
      #FunctionArgumentsRecursive reverseList(EL) .List
      ...
    </k>

  rule
    <k>
      #FunctionArgumentsRecursive .List VL:List =>
      VL
      ...
    </k>

  rule
    <k>
      #FunctionArgumentsRecursive (ListItem(E) EL):List VL:List =>
      E ~> #FunctionArgumentsRecursiveCool EL VL
      ...
    </k>

  rule
    <k>
      ListItem(V) ~> #FunctionArgumentsRecursiveCool EL:List VL:List =>
      #FunctionArgumentsRecursive EL (ListItem(V) VL)
      ...
    </k>

  /**
   * FunctionCall
   */

  syntax KItem ::=
    "#FunctionCall" Identifier List |
    "#FunctionCallCollectReturnValues" Identifier Int |
    "#FunctionCallCollectReturnValuesRecursive" Identifier Int List |
    "#FunctionCallCool" Identifier |
    "#FunctionCallDeclareArguments" Identifier Int List |
    "#FunctionCallDeclareReturnArguments" Identifier Int |
    "#FunctionCallReturn"

  rule
    <k>
      `FunctionCall1`(
        I:Identifier
      ) =>
      #FunctionCall I .List
      ...
    </k>
    <cFunctionName> I </cFunctionName>

  rule
    <k>
      `FunctionCall2`(
        I:Identifier,
        EL:ExpressionList
      ) =>
      #FunctionCall I toBuiltInList(EL)
      ...
    </k>
    <cFunctionName> I </cFunctionName>

  rule
    <k>
      #FunctionCall I:Identifier EL:List =>
      #FunctionArguments EL ~> #FunctionCallCool I
      ...
    </k>
    <cFunctionName> I </cFunctionName>

  rule
    <k>
      VL:List ~> #FunctionCallCool I:Identifier =>
      (
        #SymbolTablePush ~>
        #EnvironmentReplace ~>
        #EnvironmentPush ~>
        #FunctionCallDeclareArguments I 0 VL ~>
        #FunctionCallDeclareReturnArguments I 0 ~>
        FB ~>
        #FunctionCallCollectReturnValues I 0 ~>
        #FunctionCallReturn
      )
      ...
    </k>
    <cFunction>
      <cFunctionName> I </cFunctionName>
      <cFunctionBody> FB </cFunctionBody>
      ...
    </cFunction>

  rule
    <k>
      #FunctionCallDeclareArguments I1:Identifier I2:Int .List =>
      .
      ...
    </k>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionArity> I2 </cFunctionArity>
      ...
    </cFunction>

  rule
    <k>
      #FunctionCallDeclareArguments I1:Identifier I2:Int (ListItem(V) VL):List =>
      (
        ListItem(V) ~> #VariableDeclarationOne FPN FPT ~>
        #FunctionCallDeclareArguments I1 (I2 +Int 1) VL
      )
      ...
    </k>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionParameters>
        <cFunctionParameterIndex> I2 </cFunctionParameterIndex>
        <cFunctionParameterName> FPN </cFunctionParameterName>
        <cFunctionParameterType> FPT </cFunctionParameterType>
        ...
      </cFunctionParameters>
      ...
    </cFunction>

  rule
    <k>
      #FunctionCallDeclareReturnArguments I1:Identifier I2:Int =>
      .
      ...
    </k>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionReturnArity> I2 </cFunctionReturnArity>
      ...
    </cFunction>

  rule
    <k>
      #FunctionCallDeclareReturnArguments I1:Identifier I2:Int =>
      (
        #DefaultValue FRPT ~> #VariableDeclarationOne FRPN FRPT ~>
        #FunctionCallDeclareReturnArguments I1 (I2 +Int 1)
      )
      ...
    </k>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionReturnParameters>
        <cFunctionReturnParameterIndex> I2 </cFunctionReturnParameterIndex>
        <cFunctionReturnParameterName> FRPN </cFunctionReturnParameterName>
        <cFunctionReturnParameterType> FRPT </cFunctionReturnParameterType>
        ...
      </cFunctionReturnParameters>
      ...
    </cFunction>

  rule
    <k>
      #FunctionCallCollectReturnValues I1:Identifier I2:Int =>
      #FunctionCallCollectReturnValuesRecursive I1 I2 .List
      ...
    </k>
    <cFunctionName> I1 </cFunctionName>

  rule
    <k>
      #FunctionCallCollectReturnValuesRecursive I1:Identifier I2:Int VL:List =>
      reverseList(VL)
      ...
    </k>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionReturnArity> I2 </cFunctionReturnArity>
      ...
    </cFunction>

  rule
    <k>
      #FunctionCallCollectReturnValuesRecursive I1:Identifier I2:Int VL:List =>
      #FunctionCallCollectReturnValuesRecursive I1 (I2 +Int 1) (ListItem(VV) VL)
      ...
    </k>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionReturnParameters>
        <cFunctionReturnParameterIndex> I2 </cFunctionReturnParameterIndex>
        <cFunctionReturnParameterName> FRPN </cFunctionReturnParameterName>
        ...
      </cFunctionReturnParameters>
      ...
    </cFunction>
    <cVariable>
      <cVariableName> FRPN </cVariableName>
      <cVariableValue> VV </cVariableValue>
      ...
    </cVariable>

  rule
    <k>
      .List ~> #FunctionCallReturn =>
      (
        #EnvironmentPop ~>
        #EnvironmentRestore ~>
        #SymbolTablePop
      )
      ...
    </k>

  rule
    <k>
      (ListItem(V) VL):List ~> #FunctionCallReturn =>
      (
        #EnvironmentPop ~>
        #EnvironmentRestore ~>
        #SymbolTablePop ~>
        (ListItem(V) VL)
      )
      ...
    </k>

  /**
   * FunctionDefinition
   */

  syntax KItem ::=
    "#FunctionDefinition" Identifier List List Block |
    "#FunctionDefinitionBody" Identifier Block |
    "#FunctionDefinitionParameters" Identifier List |
    "#FunctionDefinitionReturnParameters" Identifier List

  rule
    <k>
      `FunctionDefinition1`(
        I:Identifier,
        B:Block
      ) =>
      #FunctionDefinition I .List .List B
      ...
    </k>

  rule
    <k>
      `FunctionDefinition2`(
        I:Identifier,
        TIL:TypedIdentifierList,
        B:Block
      ) =>
      #FunctionDefinition I toBuiltInList(TIL) .List B
      ...
    </k>

  rule
    <k>
      `FunctionDefinition3`(
        I:Identifier,
        TIL:TypedIdentifierList,
        B:Block
      ) =>
      #FunctionDefinition I .List toBuiltInList(TIL) B
      ...
    </k>

  rule
    <k>
      `FunctionDefinition4`(
        I:Identifier,
        TIL1:TypedIdentifierList,
        TIL2:TypedIdentifierList,
        B:Block
      ) =>
      #FunctionDefinition I toBuiltInList(TIL1) toBuiltInList(TIL2) B
      ...
    </k>

  rule
    <k>
      #FunctionDefinition I:Identifier TIL1:List TIL2:List B:Block =>
      (
        #FunctionDefinitionBody I B ~>
        #FunctionDefinitionParameters I TIL1 ~>
        #FunctionDefinitionReturnParameters I TIL2
      )
      ...
    </k>

  rule
    <k>
      #FunctionDefinitionBody I:Identifier B:Block =>
      .
      ...
    </k>
    <cSymbolTableStack>
      <cSymbolTableStackSize> STSS </cSymbolTableStackSize>
      <cSymbolTable>
        <cSymbolTableIndex> STSS -Int 1 </cSymbolTableIndex>
        (
          .Bag =>
          <cFunction>
            <cFunctionName> I </cFunctionName>
            <cFunctionArity> 0 </cFunctionArity>
            <cFunctionBody> B </cFunctionBody>
            <cFunctionReturnArity> 0 </cFunctionReturnArity>
          </cFunction>
        )
        ...
      </cSymbolTable>
      ...
    </cSymbolTableStack>

  rule
    <k>
      #FunctionDefinitionParameters I:Identifier .List =>
      .
      ...
    </k>

  rule
    <k>
      #FunctionDefinitionParameters I1:Identifier (ListItem(`TypedIdentifier`(I2, TN)) TIL):List =>
      #FunctionDefinitionParameters I1 TIL
      ...
    </k>
    <cSymbolTableStack>
      <cSymbolTableStackSize> STSS </cSymbolTableStackSize>
      <cSymbolTable>
        <cSymbolTableIndex> STSS -Int 1 </cSymbolTableIndex>
        <cFunction>
          <cFunctionName> I1 </cFunctionName>
          <cFunctionArity> FA => FA +Int 1 </cFunctionArity>
          (
            .Bag =>
            <cFunctionParameters>
              <cFunctionParameterIndex> FA </cFunctionParameterIndex>
              <cFunctionParameterName> I2 </cFunctionParameterName>
              <cFunctionParameterType> TN </cFunctionParameterType>
            </cFunctionParameters>
          )
          ...
        </cFunction>
        ...
      </cSymbolTable>
      ...
    </cSymbolTableStack>

  rule
    <k>
      #FunctionDefinitionReturnParameters I:Identifier .List =>
      .
      ...
    </k>

  rule
    <k>
      #FunctionDefinitionReturnParameters I1:Identifier (ListItem(`TypedIdentifier`(I2, TN)) TIL):List =>
      #FunctionDefinitionReturnParameters I1 TIL
      ...
    </k>
    <cSymbolTableStack>
      <cSymbolTableStackSize> STSS </cSymbolTableStackSize>
      <cSymbolTable>
        <cSymbolTableIndex> STSS -Int 1 </cSymbolTableIndex>
        <cFunction>
          <cFunctionName> I1 </cFunctionName>
          <cFunctionReturnArity> FRA => FRA +Int 1 </cFunctionReturnArity>
          (
            .Bag =>
            <cFunctionReturnParameters>
              <cFunctionReturnParameterIndex> FRA </cFunctionReturnParameterIndex>
              <cFunctionReturnParameterName> I2 </cFunctionReturnParameterName>
              <cFunctionReturnParameterType> TN </cFunctionReturnParameterType>
            </cFunctionReturnParameters>
          )
          ...
        </cFunction>
        ...
      </cSymbolTable>
      ...
    </cSymbolTableStack>

  /**
   * Identifier
   */

  rule
    <k>
      I:Identifier =>
      ListItem(VV)
      ...
    </k>
    <cVariable>
      <cVariableName> I </cVariableName>
      <cVariableValue> VV </cVariableValue>
      ...
    </cVariable>

  /**
   * If
   */

  syntax KItem ::=
    "#If" Expression Block |
    "#IfCool" Block

  rule
    <k>
      `If`(
        E:Expression,
        B:Block
      ) =>
      #If E B
      ...
    </k>

  rule
    <k>
      #If E:Expression B:Block =>
      E ~> #IfCool B
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool true) ~> #IfCool B:Block =>
      B
      ...
    </k>

  rule
    <k>
      ListItem(#ValueBool false) ~> #IfCool B:Block =>
      .
      ...
    </k>

  /**
   * Object
   */

  rule
    <k>
      `Object1`(
        LS:LiteralString,
        C:Code
      ) =>
      C
      ...
    </k>

  rule
    <k>
      `Object2`(
        LS:LiteralString,
        C:Code,
        OODS:ObjectOrDataSequence
      ) =>
      C ~> OODS
      ...
    </k>

  /**
   * ObjectOrDataSequence
   */

  rule
    <k>
      `ObjectOrDataSequence`(
        OODS:ObjectOrDataSequence,
        OOD:ObjectOrData
      ) =>
      OODS ~> OOD
      ...
    </k>

  /**
   * Switch
   */

  syntax KItem ::=
    "#Switch" Expression List List |
    "#SwitchCool" List List |
    "#SwitchRecursive" Value List List |
    "#SwitchRecursiveCool" Value Block List List |
    "#SwitchRecursiveHeat" TypedLiteral Value Block List List

  rule
    <k>
      `Switch1`(
        E:Expression,
        CS:CaseSequence
      ) =>
      #Switch E toBuiltInList(CS) .List
      ...
    </k>

  rule
    <k>
      `Switch2`(
        E:Expression,
        CS:CaseSequence,
        D:Default
      ) =>
      #Switch E toBuiltInList(CS) ListItem(D)
      ...
    </k>

  rule
    <k>
      `Switch3`(
        E:Expression,
        D:Default
      ) =>
      #Switch E .List ListItem(D)
      ...
    </k>

  rule
    <k>
      #Switch E:Expression CS1:List CS2:List =>
      E ~> #SwitchCool CS1 CS2
      ...
    </k>

  rule
    <k>
      ListItem(V) ~> #SwitchCool CS1:List CS2:List =>
      #SwitchRecursive V CS1 CS2
      ...
    </k>

  rule
    <k>
      #SwitchRecursive V:Value .List .List =>
      .
      ...
    </k>

  rule
    <k>
      #SwitchRecursive V:Value .List ListItem(`Default`(B)) =>
      B
      ...
    </k>

  rule
    <k>
      #SwitchRecursive V:Value (ListItem(`Case`(TL, B)) CS1):List CS2:List =>
      #SwitchRecursiveHeat TL V B CS1 CS2
      ...
    </k>

  rule
    <k>
      #SwitchRecursiveHeat TL:TypedLiteral V:Value B:Block CS1:List CS2:List =>
      TL ~> #SwitchRecursiveCool V B CS1 CS2
      ...
    </k>

  rule
    <k>
      ListItem(V1) ~> #SwitchRecursiveCool V2:Value B:Block CS1:List CS2:List =>
      (
        #if V1 ==K V2
        #then
          B
        #else
          #SwitchRecursive V2 CS1 CS2
        #fi
      )
      ...
    </k>

  /**
   * TypedLiteral
   */

  rule
    <k>
      `TypedLiteral`(
        B:Bool,
        bool
      ) =>
      ListItem(#ValueBool B)
      ...
    </k>

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        u8
      ) =>
      ListItem(#ValueU8 I)
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 8)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        u32
      ) =>
      ListItem(#ValueU32 I)
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 32)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        u64
      ) =>
      ListItem(#ValueU64 I)
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 64)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        u128
      ) =>
      ListItem(#ValueU128 I)
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 128)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        u256
      ) =>
      ListItem(#ValueU256 I)
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 256)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        s8
      ) =>
      ListItem(#ValueS8 I)
      ...
    </k>
    requires ((0 -Int (2 ^Int 7)) <=Int I) andBool (I <Int (2 ^Int 7)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        s32
      ) =>
      ListItem(#ValueS32 I)
      ...
    </k>
    requires ((0 -Int (2 ^Int 31)) <=Int I) andBool (I <Int (2 ^Int 31)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        s64
      ) =>
      ListItem(#ValueS64 I)
      ...
    </k>
    requires ((0 -Int (2 ^Int 63)) <=Int I) andBool (I <Int (2 ^Int 63)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        s128
      ) =>
      ListItem(#ValueS128 I)
      ...
    </k>
    requires ((0 -Int (2 ^Int 127)) <=Int I) andBool (I <Int (2 ^Int 127)) // >

  rule
    <k>
      `TypedLiteral`(
        I:Int,
        s256
      ) =>
      ListItem(#ValueS256 I)
      ...
    </k>
    requires ((0 -Int (2 ^Int 255)) <=Int I) andBool (I <Int (2 ^Int 255)) // >

  /**
   * VariableDeclaration
   */

  syntax KItem ::=
    "#VariableDeclaration" List Expression |
    "#VariableDeclarationCool" List |
    "#VariableDeclarationDefaultValues" List |
    "#VariableDeclarationMany" List List |
    "#VariableDeclarationOne" Identifier TypeName

  rule
    <k>
      `VariableDeclaration1`(
        TIL:TypedIdentifierList
      ) =>
      #VariableDeclarationDefaultValues toBuiltInList(TIL)
      ...
    </k>

  rule
    <k>
      `VariableDeclaration2`(
        TIL:TypedIdentifierList,
        E:Expression
      ) =>
      #VariableDeclaration toBuiltInList(TIL) E
      ...
    </k>

  rule
    <k>
      #VariableDeclarationDefaultValues .List =>
      .
      ...
    </k>

  rule
    <k>
      #VariableDeclarationDefaultValues (ListItem(`TypedIdentifier`(I, TN)) TIL):List =>
      (
        #DefaultValue TN ~> #VariableDeclarationOne I TN ~>
        #VariableDeclarationDefaultValues TIL
      )
      ...
    </k>

  rule
    <k>
      ListItem(V) ~> #VariableDeclarationOne I:Identifier TN:TypeName =>
      .
      ...
    </k>
    <cEnvironmentStack>
      <cEnvironmentStackSize> ESS </cEnvironmentStackSize>
      <cEnvironment>
        <cEnvironmentIndex> ESS -Int 1 </cEnvironmentIndex>
        (
          .Bag =>
          <cVariable>
            <cVariableName> I </cVariableName>
            <cVariableType> TN </cVariableType>
            <cVariableValue> V </cVariableValue>
          </cVariable>
        )
        ...
      </cEnvironment>
      ...
    </cEnvironmentStack>

  rule
    <k>
      #VariableDeclaration TIL:List E:Expression =>
      E ~> #VariableDeclarationCool TIL
      ...
    </k>

  rule
    <k>
      VL:List ~> #VariableDeclarationCool TIL:List =>
      #VariableDeclarationMany TIL VL
      ...
    </k>

  rule
    <k>
      #VariableDeclarationMany .List .List =>
      .
      ...
    </k>

  rule
    <k>
      #VariableDeclarationMany (ListItem(`TypedIdentifier`(I, TN)) TIL):List (ListItem(V) VL):List =>
      (
        ListItem(V) ~> #VariableDeclarationOne I TN ~>
        #VariableDeclarationMany TIL VL
      )
      ...
    </k>

endmodule

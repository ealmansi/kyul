require "../yul-built-in/yul-built-in.k"
require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"
require "../yul-utility/yul-utility.k"
require "../yul-value/yul-value.k"

module YUL
  imports DOMAINS
  imports YUL-BUILT-IN
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  syntax KItem ::=
    "#AssignmentCool" IdentifierList |
    "#AssignmentHeat" IdentifierList Expression |
    "#AssignmentMany" IdentifierList ValueSequence |
    "#AssignmentOne" Identifier Value |
    "#DefineFunction" Identifier Block |
    "#DefineFunctionParameter" Identifier TypedIdentifier |
    "#DefineFunctionReturnParameter" Identifier TypedIdentifier |
    "#ForBreak" |
    "#ForBreakMarker" |
    "#ForContinue" |
    "#ForContinueMarker" |
    "#ForCool" Expression Block Block |
    "#ForHeat" Expression Block Block |
    "#FunctionCallArgumentsCool" ExpressionList |
    "#FunctionCallArgumentsHeat" ExpressionList |
    "#FunctionCallArgumentsMerge" Value |
    "#FunctionCallCollectReturnValues" Identifier Int |
    "#FunctionCallCollectReturnValuesRecursive" Identifier Int ValueSequence |
    "#FunctionCallCool" Identifier |
    "#FunctionCallDeclareArguments" Identifier Int ValueSequence |
    "#FunctionCallDeclareReturnArguments" Identifier Int |
    "#FunctionCallHeat" Identifier ExpressionList |
    "#FunctionCallReturn" |
    "#FunctionDefinition1" Identifier Block |
    "#FunctionDefinition2" Identifier TypedIdentifierList Block |
    "#FunctionDefinition3" Identifier TypedIdentifierList Block |
    "#FunctionDefinition4" Identifier TypedIdentifierList TypedIdentifierList Block |
    "#IfCool" Block |
    "#IfHeat" Expression Block |
    "#StatementSequenceHoist" StatementSequence |
    "#StatementSequenceHoistCool1" Statement List List |
    "#StatementSequenceHoistCool2" StatementSequence Statement List List |
    "#StatementSequenceHoistHeat" StatementSequence List List |
    "#StatementSequenceHoistReverse" List |
    "#StatementSequenceHoistSpread" |
    "#SwitchCase" Case |
    "#SwitchCaseCompare" Block |
    "#SwitchCaseSequence" CaseSequence |
    "#SwitchDefault" Default |
    "#SwitchDone" |
    "#SwitchDoneMarker" |
    "#VariableDeclaration" TypedIdentifierList |
    "#VariableDeclarationCool" TypedIdentifierList |
    "#VariableDeclarationMany" TypedIdentifierList ValueSequence |
    "#VariableDeclarationOne" Identifier TypeName

  /**
   * Assignment
   */

  rule
    <k>
      IL:IdentifierList := E:Expression =>
      #AssignmentHeat IL E
      ...
    </k>
    <cRules> ... .Set => SetItem("1") </cRules>

  rule
    <k>
      #AssignmentHeat IL:IdentifierList E:Expression =>
      E ~> #AssignmentCool IL
      ...
    </k>
    <cRules> ... .Set => SetItem("2") </cRules>

  rule
    <k>
      VS:ValueSequence ~> #AssignmentCool IL:IdentifierList =>
      #AssignmentMany IL VS
      ...
    </k>
    <cRules> ... .Set => SetItem("3") </cRules>

  rule
    <k>
      #AssignmentMany I:Identifier (.ValueSequence V):ValueSequence =>
      #AssignmentOne I V
      ...
    </k>
    <cRules> ... .Set => SetItem("4") </cRules>

  rule
    <k>
      #AssignmentMany (IL , I):IdentifierList (VS V):ValueSequence =>
      #AssignmentMany IL VS ~> #AssignmentOne I V
      ...
    </k>
    <cRules> ... .Set => SetItem("5") </cRules>

  rule
    <k>
      #AssignmentOne I:Identifier V:Value =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("6") </cRules>
    <cVariable>
      <cVariableName> I </cVariableName>
      <cVariableValue> _ => V </cVariableValue>
      ...
    </cVariable>

  /**
   * Block
   */

  rule
    <k>
      { }:Block =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("7") </cRules>

  rule
    <k>
      { SS:StatementSequence }:Block =>
      (
        #SymbolTablePush ~>
        #EnvironmentPush ~>
        #StatementSequenceHoist SS ~>
        #EnvironmentPop ~>
        #SymbolTablePop
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("8") </cRules>

  /**
   * Data
   */

  rule
    <k>
      data LS:LiteralString LH:LiteralHex =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("9") </cRules>

  rule
    <k>
      data LS1:LiteralString LS2:LiteralString =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("10") </cRules>

  /**
   * Expression > FunctionCall
   */

  rule
    <k>
      I:Identifier ( ) =>
      .ValueSequence ~> #FunctionCallCool I
      ...
    </k>
    <cRules> ... .Set => SetItem("11") </cRules>
    <cFunctionName> I </cFunctionName>

  rule
    <k>
      I:Identifier ( EL:ExpressionList ) =>
      #FunctionCallHeat I EL
      ...
    </k>
    <cRules> ... .Set => SetItem("12") </cRules>
    <cFunctionName> I </cFunctionName>

  rule
    <k>
      #FunctionCallHeat I:Identifier EL:ExpressionList =>
      #FunctionCallArgumentsHeat EL ~> #FunctionCallCool I
      ...
    </k>
    <cRules> ... .Set => SetItem("13") </cRules>
    <cFunctionName> I </cFunctionName>

  rule
    <k>
      #FunctionCallArgumentsHeat E:Expression =>
      E
      ...
    </k>
    <cRules> ... .Set => SetItem("14") </cRules>

  rule
    <k>
      #FunctionCallArgumentsHeat (EL , E):ExpressionList =>
      E ~> #FunctionCallArgumentsCool EL
      ...
    </k>
    <cRules> ... .Set => SetItem("15") </cRules>

  rule
    <k>
      .ValueSequence V:Value ~> #FunctionCallArgumentsCool EL:ExpressionList =>
      #FunctionCallArgumentsHeat EL ~> #FunctionCallArgumentsMerge V
      ...
    </k>
    <cRules> ... .Set => SetItem("16") </cRules>

  rule
    <k>
      VS:ValueSequence ~> #FunctionCallArgumentsMerge V:Value =>
      VS V
      ...
    </k>
    <cRules> ... .Set => SetItem("17") </cRules>

  rule
    <k>
      VS:ValueSequence ~> #FunctionCallCool I:Identifier =>
      (
        #SymbolTablePush ~>
        #EnvironmentReplace ~>
        #EnvironmentPush ~>
        #FunctionCallDeclareArguments I FA VS ~>
        #FunctionCallDeclareReturnArguments I FRA ~>
        FB ~>
        #FunctionCallCollectReturnValues I FRA ~>
        #FunctionCallReturn
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("18") </cRules>
    <cFunction>
      <cFunctionName> I </cFunctionName>
      <cFunctionArity> FA </cFunctionArity>
      <cFunctionBody> FB </cFunctionBody>
      <cFunctionReturnArity> FRA </cFunctionReturnArity>
      ...
    </cFunction>

  rule
    <k>
      #FunctionCallDeclareArguments I1:Identifier I2:Int VS:ValueSequence =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("19") </cRules>
    <cFunctionName> I1 </cFunctionName>
    requires I2 ==Int 0

  rule
    <k>
      #FunctionCallDeclareArguments I1:Identifier I2:Int (VS V):ValueSequence =>
      #FunctionCallDeclareArguments I1 (I2 -Int 1) VS ~>
      V ~> #VariableDeclarationOne FPN FPT
      ...
    </k>
    <cRules> ... .Set => SetItem("20") </cRules>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionParameters>
        <cFunctionParameterIndex> I2 -Int 1 </cFunctionParameterIndex>
        <cFunctionParameterName> FPN </cFunctionParameterName>
        <cFunctionParameterType> FPT </cFunctionParameterType>
        ...
      </cFunctionParameters>
      ...
    </cFunction>
    requires I2 >Int 0

  rule
    <k>
      #FunctionCallDeclareReturnArguments I1:Identifier I2:Int =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("21") </cRules>
    <cFunctionName> I1 </cFunctionName>
    requires I2 ==Int 0

  rule
    <k>
      #FunctionCallDeclareReturnArguments I1:Identifier I2:Int =>
      (
        #FunctionCallDeclareReturnArguments I1 (I2 -Int 1) ~>
        #DefaultValue FRPT ~> #VariableDeclarationOne FRPN FRPT
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("22") </cRules>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionReturnParameters>
        <cFunctionReturnParameterIndex> I2 -Int 1 </cFunctionReturnParameterIndex>
        <cFunctionReturnParameterName> FRPN </cFunctionReturnParameterName>
        <cFunctionReturnParameterType> FRPT </cFunctionReturnParameterType>
        ...
      </cFunctionReturnParameters>
      ...
    </cFunction>
    requires I2 >Int 0

  rule
    <k>
      #FunctionCallCollectReturnValues I1:Identifier I2:Int =>
      #FunctionCallCollectReturnValuesRecursive I1 I2 .ValueSequence
      ...
    </k>
    <cRules> ... .Set => SetItem("23") </cRules>
    <cFunctionName> I1 </cFunctionName>

  rule
    <k>
      #FunctionCallCollectReturnValuesRecursive I1:Identifier I2:Int VS:ValueSequence =>
      VS
      ...
    </k>
    <cRules> ... .Set => SetItem("24") </cRules>
    <cFunctionName> I1 </cFunctionName>
    requires I2 ==Int 0

  rule
    <k>
      #FunctionCallCollectReturnValuesRecursive I1:Identifier I2:Int VS:ValueSequence =>
      #FunctionCallCollectReturnValuesRecursive I1 (I2 -Int 1) (VS VV)
      ...
    </k>
    <cRules> ... .Set => SetItem("25") </cRules>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionReturnParameters>
        <cFunctionReturnParameterIndex> I2 -Int 1 </cFunctionReturnParameterIndex>
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
    requires I2 >Int 0

  rule
    <k>
      .ValueSequence ~> #FunctionCallReturn =>
      (
        #EnvironmentPop ~>
        #EnvironmentRestore ~>
        #SymbolTablePop
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("26") </cRules>

  rule
    <k>
      (VS V):ValueSequence ~> #FunctionCallReturn =>
      (
        #EnvironmentPop ~>
        #EnvironmentRestore ~>
        #SymbolTablePop ~>
        VS V
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("27") </cRules>

  /**
   * Expression > Identifier
   */

  rule
    <k>
      I:Identifier =>
      .ValueSequence VV
      ...
    </k>
    <cRules> ... .Set => SetItem("28") </cRules>
    <cVariable>
      <cVariableName> I </cVariableName>
      <cVariableValue> VV </cVariableValue>
      ...
    </cVariable>

  /**
   * Expression > TypedLiteral
   */

  rule
    <k>
      (I:Int : u8):TypedLiteral =>
      .ValueSequence (#ValueU8 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("29") </cRules>
    requires 0 <=Int I andBool I <Int (2 ^Int 8)

  rule
    <k>
      (I:Int : u32):TypedLiteral =>
      .ValueSequence (#ValueU32 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("30") </cRules>
    requires 0 <=Int I andBool I <Int (2 ^Int 32)

  rule
    <k>
      (I:Int : u64):TypedLiteral =>
      .ValueSequence (#ValueU64 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("31") </cRules>
    requires 0 <=Int I andBool I <Int (2 ^Int 64)

  rule
    <k>
      (I:Int : u128):TypedLiteral =>
      .ValueSequence (#ValueU128 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("32") </cRules>
    requires 0 <=Int I andBool I <Int (2 ^Int 128)

  rule
    <k>
      (I:Int : u256):TypedLiteral =>
      .ValueSequence (#ValueU256 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("33") </cRules>
    requires 0 <=Int I andBool I <Int (2 ^Int 256)

  rule
    <k>
      (I:Int : s8):TypedLiteral =>
      .ValueSequence (#ValueS8 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("34") </cRules>
    requires (0 -Int (2 ^Int 7)) <=Int I andBool I <Int (2 ^Int 7)

  rule
    <k>
      (I:Int : s32):TypedLiteral =>
      .ValueSequence (#ValueS32 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("35") </cRules>
    requires (0 -Int (2 ^Int 31)) <=Int I andBool I <Int (2 ^Int 31)

  rule
    <k>
      (I:Int : s64):TypedLiteral =>
      .ValueSequence (#ValueS64 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("36") </cRules>
    requires (0 -Int (2 ^Int 63)) <=Int I andBool I <Int (2 ^Int 63)

  rule
    <k>
      (I:Int : s128):TypedLiteral =>
      .ValueSequence (#ValueS128 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("37") </cRules>
    requires (0 -Int (2 ^Int 127)) <=Int I andBool I <Int (2 ^Int 127)

  rule
    <k>
      (I:Int : s256):TypedLiteral =>
      .ValueSequence (#ValueS256 I)
      ...
    </k>
    <cRules> ... .Set => SetItem("38") </cRules>
    requires (0 -Int (2 ^Int 255)) <=Int I andBool I <Int (2 ^Int 255)

  rule
    <k>
      (B:Bool : bool):TypedLiteral =>
      .ValueSequence (#ValueBool B)
      ...
    </k>
    <cRules> ... .Set => SetItem("39") </cRules>

  /**
   * For
   */

  rule
    <k>
      for {} E:Expression B1:Block B2:Block =>
      (
        #ForHeat E B1 B2 ~>
        #ForBreakMarker
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("40") </cRules>

  rule
    <k>
      for { SS:StatementSequence } E:Expression B1:Block B2:Block =>
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
    <cRules> ... .Set => SetItem("41") </cRules>

  rule
    <k>
      #ForHeat E:Expression B1:Block B2:Block =>
      E ~> #ForCool E B1 B2
      ...
    </k>
    <cRules> ... .Set => SetItem("42") </cRules>

  rule
    <k>
      .ValueSequence (#ValueBool true) ~> #ForCool E:Expression B1:Block B2:Block =>
      (
        B2 ~>
        #ForContinueMarker ~>
        B1 ~>
        #ForHeat E B1 B2
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("43") </cRules>

  rule
    <k>
      .ValueSequence (#ValueBool false) ~> #ForCool E:Expression B1:Block B2:Block =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("44") </cRules>

  rule
    <k>
      break:Break =>
      #ForBreak
      ...
    </k>
    <cRules> ... .Set => SetItem("45") </cRules>

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
    <cRules> ... .Set => SetItem("46") </cRules>

  rule
    <k>
      #ForBreakMarker =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("47") </cRules>

  rule
    <k>
      continue:Continue =>
      #ForContinue
      ...
    </k>
    <cRules> ... .Set => SetItem("48") </cRules>

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
    <cRules> ... .Set => SetItem("49") </cRules>

  rule
    <k>
      #ForContinueMarker =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("50") </cRules>

  /**
   * FunctionDefinition
   */

  rule
    <k>
      function I:Identifier ( ) B:Block =>
      #FunctionDefinition1 I B
      ...
    </k>
    <cRules> ... .Set => SetItem("51") </cRules>

  rule
    <k>
      function I:Identifier ( TIL:TypedIdentifierList ) B:Block =>
      #FunctionDefinition2 I TIL B
      ...
    </k>
    <cRules> ... .Set => SetItem("52") </cRules>

  rule
    <k>
      function I:Identifier ( ) -> TIL:TypedIdentifierList B:Block =>
      #FunctionDefinition3 I TIL B
      ...
    </k>
    <cRules> ... .Set => SetItem("53") </cRules>

  rule
    <k>
      function I:Identifier ( TIL1:TypedIdentifierList ) -> TIL2:TypedIdentifierList B:Block =>
      #FunctionDefinition4 I TIL1 TIL2 B
      ...
    </k>
    <cRules> ... .Set => SetItem("54") </cRules>

  rule
    <k>
      #FunctionDefinition1 I:Identifier B:Block =>
      #DefineFunction I B
      ...
    </k>
    <cRules> ... .Set => SetItem("55") </cRules>

  rule
    <k>
      #FunctionDefinition2 I:Identifier TI:TypedIdentifier B:Block =>
      #DefineFunction I B ~> #DefineFunctionParameter I TI
      ...
    </k>
    <cRules> ... .Set => SetItem("56") </cRules>

  rule
    <k>
      #FunctionDefinition2 I:Identifier (TIL , TI):TypedIdentifierList B:Block =>
      #FunctionDefinition2 I TIL B ~> #DefineFunctionParameter I TI
      ...
    </k>
    <cRules> ... .Set => SetItem("57") </cRules>

  rule
    <k>
      #FunctionDefinition3 I:Identifier TI:TypedIdentifier B:Block =>
      #DefineFunction I B ~> #DefineFunctionReturnParameter I TI
      ...
    </k>
    <cRules> ... .Set => SetItem("58") </cRules>

  rule
    <k>
      #FunctionDefinition3 I:Identifier (TIL , TI):TypedIdentifierList B:Block =>
      #FunctionDefinition3 I TIL B ~> #DefineFunctionReturnParameter I TI
      ...
    </k>
    <cRules> ... .Set => SetItem("59") </cRules>

  rule
    <k>
      #FunctionDefinition4 I:Identifier TIL1:TypedIdentifierList TI:TypedIdentifier B:Block =>
      #FunctionDefinition2 I TIL1 B ~> #DefineFunctionReturnParameter I TI
      ...
    </k>
    <cRules> ... .Set => SetItem("60") </cRules>

  rule
    <k>
      #FunctionDefinition4 I:Identifier TIL1:TypedIdentifierList (TIL2 , TI):TypedIdentifierList B:Block =>
      #FunctionDefinition4 I TIL1 TIL2 B ~> #DefineFunctionReturnParameter I TI
      ...
    </k>
    <cRules> ... .Set => SetItem("61") </cRules>

  rule
    <k>
      #DefineFunction I:Identifier B:Block =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("62") </cRules>
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
      #DefineFunctionParameter I1:Identifier (I2 : TN):TypedIdentifier =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("63") </cRules>
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
      #DefineFunctionReturnParameter I1:Identifier (I2 : TN):TypedIdentifier =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("64") </cRules>
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
   * If
   */

  rule
    <k>
      if E:Expression B:Block =>
      #IfHeat E B
      ...
    </k>
    <cRules> ... .Set => SetItem("65") </cRules>

  rule
    <k>
      #IfHeat E:Expression B:Block =>
      E ~> #IfCool B
      ...
    </k>
    <cRules> ... .Set => SetItem("66") </cRules>

  rule
    <k>
      .ValueSequence (#ValueBool true) ~> #IfCool B:Block =>
      B
      ...
    </k>
    <cRules> ... .Set => SetItem("67") </cRules>

  rule
    <k>
      .ValueSequence (#ValueBool false) ~> #IfCool B:Block =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("68") </cRules>

  /**
   * Statement Sequence
   */

  rule
    <k>
      #StatementSequenceHoist SS:StatementSequence =>
      (
        #StatementSequenceHoistHeat SS .List .List ~>
        #StatementSequenceHoistReverse .List ~>
        #StatementSequenceHoistSpread
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("69") </cRules>

  rule
    <k>
      #StatementSequenceHoistHeat S:Statement L1:List L2:List =>
      #IsFunctionDefinition S ~> #StatementSequenceHoistCool1 S L1 L2
      ...
    </k>
    <cRules> ... .Set => SetItem("70") </cRules>

  rule
    <k>
      #StatementSequenceHoistHeat (SS S):StatementSequence L1:List L2:List =>
      #IsFunctionDefinition S ~> #StatementSequenceHoistCool2 SS S L1 L2
      ...
    </k>
    <cRules> ... .Set => SetItem("71") </cRules>

  rule
    <k>
      false ~> #StatementSequenceHoistCool1 S:Statement L1:List L2:List =>
      L1 (ListItem(S) L2)
      ...
    </k>
    <cRules> ... .Set => SetItem("72") </cRules>

  rule
    <k>
      true ~> #StatementSequenceHoistCool1 S:Statement L1:List L2:List =>
      (ListItem(S) L1) L2
      ...
    </k>
    <cRules> ... .Set => SetItem("73") </cRules>

  rule
    <k>
      false ~> #StatementSequenceHoistCool2 SS:StatementSequence S:Statement L1:List L2:List =>
      #StatementSequenceHoistHeat SS L1 (ListItem(S) L2)
      ...
    </k>
    <cRules> ... .Set => SetItem("74") </cRules>

  rule
    <k>
      true ~> #StatementSequenceHoistCool2 SS:StatementSequence S:Statement L1:List L2:List =>
      #StatementSequenceHoistHeat SS (ListItem(S) L1) L2
      ...
    </k>
    <cRules> ... .Set => SetItem("75") </cRules>

  rule
    <k>
      .List ~> #StatementSequenceHoistReverse L:List =>
      L
      ...
    </k>
    <cRules> ... .Set => SetItem("76") </cRules>

  rule
    <k>
      ListItem(S) L1:List ~> #StatementSequenceHoistReverse L2:List =>
      L1 ~> #StatementSequenceHoistReverse (ListItem(S) L2)
      ...
    </k>
    <cRules> ... .Set => SetItem("77") </cRules>

  rule
    <k>
      .List ~> #StatementSequenceHoistSpread =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("78") </cRules>

  rule
    <k>
      ListItem(S) L:List ~> #StatementSequenceHoistSpread =>
      L ~> #StatementSequenceHoistSpread ~> S
      ...
    </k>
    <cRules> ... .Set => SetItem("79") </cRules>

  /**
   * Object
   */
  rule
    <k>
      object LS:LiteralString { code B:Block } =>
      B
      ...
    </k>
    <cRules> ... .Set => SetItem("80") </cRules>

  rule
    <k>
      object LS:LiteralString { code B:Block OODS:ObjectOrDataSequence } =>
      B ~> OODS
      ...
    </k>
    <cRules> ... .Set => SetItem("81") </cRules>

  rule
    <k>
      OODS:ObjectOrDataSequence OOD:ObjectOrData =>
      OODS ~> OOD
      ...
    </k>
    <cRules> ... .Set => SetItem("82") </cRules>

  /**
   * Switch
   */

  rule
    <k>
      switch E:Expression CS:CaseSequence =>
      E ~> #SwitchCaseSequence CS ~> #SwitchDoneMarker
      ...
    </k>
    <cRules> ... .Set => SetItem("83") </cRules>

  rule
    <k>
      switch E:Expression CS:CaseSequence D:Default =>
      E ~> #SwitchCaseSequence CS ~> #SwitchDefault D ~> #SwitchDoneMarker
      ...
    </k>
    <cRules> ... .Set => SetItem("84") </cRules>

  rule
    <k>
      switch E:Expression D:Default =>
      E ~> #SwitchDefault D ~> #SwitchDoneMarker
      ...
    </k>
    <cRules> ... .Set => SetItem("85") </cRules>

  rule
    <k>
      .ValueSequence V:Value ~> #SwitchCaseSequence C:Case =>
      .ValueSequence V:Value ~> #SwitchCase C
      ...
    </k>
    <cRules> ... .Set => SetItem("86") </cRules>

  rule
    <k>
      .ValueSequence V:Value ~> #SwitchCaseSequence (CS C):CaseSequence =>
      .ValueSequence V:Value ~> #SwitchCaseSequence CS ~> #SwitchCase C
      ...
    </k>
    <cRules> ... .Set => SetItem("87") </cRules>

  rule
    <k>
      .ValueSequence V:Value ~> #SwitchCase (case L : TN B):Case =>
      (L : TN) ~> .ValueSequence V:Value ~> #SwitchCaseCompare B
      ...
    </k>
    <cRules> ... .Set => SetItem("88") </cRules>

  rule
    <k>
      .ValueSequence V1:Value ~> .ValueSequence V2:Value ~> #SwitchCaseCompare B:Block =>
      (
        #if V1 ==K V2
        #then
          B ~> #SwitchDone
        #else
          .ValueSequence V2
        #fi
      )
      ...
    </k>
    <cRules> ... .Set => SetItem("89") </cRules>

  rule
    <k>
      .ValueSequence V:Value ~> #SwitchDefault (default B):Default =>
      B ~> #SwitchDone
      ...
    </k>
    <cRules> ... .Set => SetItem("90") </cRules>

  rule
    <k>
      #SwitchDone ~> #SwitchCase C:Case =>
      #SwitchDone
      ...
    </k>
    <cRules> ... .Set => SetItem("91") </cRules>

  rule
    <k>
      #SwitchDone ~> #SwitchDefault D:Default =>
      #SwitchDone
      ...
    </k>
    <cRules> ... .Set => SetItem("92") </cRules>

  rule
    <k>
      #SwitchDone ~> #SwitchDoneMarker =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("93") </cRules>

  /**
   * VariableDeclaration
   */

  rule
    <k>
      let TIL:TypedIdentifierList =>
      #VariableDeclaration TIL
      ...
    </k>
    <cRules> ... .Set => SetItem("94") </cRules>

  rule
    <k>
      let TIL:TypedIdentifierList := E:Expression =>
      E ~> #VariableDeclarationCool TIL
      ...
    </k>
    <cRules> ... .Set => SetItem("95") </cRules>

  rule
    <k>
      #VariableDeclaration (I : TN):TypedIdentifier =>
      #DefaultValue TN ~> #VariableDeclarationOne I TN
      ...
    </k>
    <cRules> ... .Set => SetItem("96") </cRules>

  rule
    <k>
      #VariableDeclaration (TIL , I : TN):TypedIdentifierList =>
      #VariableDeclaration TIL ~> #DefaultValue TN ~> #VariableDeclarationOne I TN
      ...
    </k>
    <cRules> ... .Set => SetItem("97") </cRules>

  rule
    <k>
      VS:ValueSequence ~> #VariableDeclarationCool TIL:TypedIdentifierList =>
      #VariableDeclarationMany TIL VS
      ...
    </k>
    <cRules> ... .Set => SetItem("98") </cRules>

  rule
    <k>
      VV:Value ~> #VariableDeclarationOne I1:Identifier TN:TypeName =>
      .
      ...
    </k>
    <cRules> ... .Set => SetItem("99") </cRules>
    <cEnvironmentStack>
      <cEnvironmentStackSize> ESS </cEnvironmentStackSize>
      <cEnvironment>
        <cEnvironmentIndex> ESS -Int 1 </cEnvironmentIndex>
        (
          .Bag =>
          <cVariable>
            <cVariableName> I1 </cVariableName>
            <cVariableType> TN </cVariableType>
            <cVariableValue> VV </cVariableValue>
          </cVariable>
        )
        ...
      </cEnvironment>
      ...
    </cEnvironmentStack>

  rule
    <k>
      #VariableDeclarationMany (I : TN):TypedIdentifier (.ValueSequence V):ValueSequence =>
      V ~> #VariableDeclarationOne I TN
      ...
    </k>
    <cRules> ... .Set => SetItem("100") </cRules>

  rule
    <k>
      #VariableDeclarationMany (TIL , I : TN):TypedIdentifierList (VS V):ValueSequence =>
      #VariableDeclarationMany TIL VS ~> V ~> #VariableDeclarationOne I TN
      ...
    </k>
    <cRules> ... .Set => SetItem("101") </cRules>

endmodule

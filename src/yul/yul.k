require "../yul-ast/yul-ast.k"
require "../yul-built-in/yul-built-in.k"
require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"
require "../yul-utility/yul-utility.k"
require "../yul-value/yul-value.k"

module YUL
  imports DOMAINS
  imports YUL-AST
  imports YUL-BUILT-IN
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-UTILITY
  imports YUL-VALUE

  syntax KItem ::=
    "#AssignmentCool" AstIdentifierList |
    "#AssignmentHeat" AstIdentifierList AstExpression |
    "#AssignmentRecursive" AstIdentifierList ValueSequence |
    "#DefineFunction" AstIdentifier AstBlock |
    "#DefineFunctionParameters" AstIdentifier AstTypedIdentifierList |
    "#DefineFunctionReturnParameters" AstIdentifier AstTypedIdentifierList |
    "#ForBreak" |
    "#ForBreakMarker" |
    "#ForContinue" |
    "#ForContinueMarker" |
    "#ForCool" AstExpression AstBlock AstBlock |
    "#ForHeat" AstExpression AstBlock AstBlock |
    "#FunctionCallCollectReturnValues" AstIdentifier Int |
    "#FunctionCallCollectReturnValuesRecursive" AstIdentifier Int ValueSequence |
    "#FunctionCallCool" AstIdentifier |
    "#FunctionCallDeclareArguments" AstIdentifier Int ValueSequence |
    "#FunctionCallDeclareReturnArguments" AstIdentifier Int |
    "#FunctionCallHeat" AstIdentifier AstExpressionList |
    "#FunctionCallReturn" |
    "#IfCool" AstBlock |
    "#IfHeat" AstExpression AstBlock |
    "#ObjectOrDataSequenceSpread" AstObjectOrDataSequence |
    "#StatementSequenceHoist" AstStatementSequence |
    "#StatementSequenceHoistRecursive" AstStatementSequence List List |
    "#StatementSequenceHoistRecursiveCool" AstStatement AstStatementSequence List List |
    "#StatementSequenceHoistRecursiveHeat" AstStatement AstStatementSequence List List |
    "#StatementSequenceHoistSpread" AstStatementSequence |
    "#SwitchCool" AstCaseSequence AstDefault |
    "#SwitchHeat" AstExpression AstCaseSequence AstDefault |
    "#SwitchRecursive" Value AstCaseSequence AstDefault |
    "#SwitchRecursiveCool" Value AstBlock AstCaseSequence AstDefault |
    "#SwitchRecursiveHeat" AstTypedLiteral Value AstBlock AstCaseSequence AstDefault |
    "#VariableDeclarationCool" AstTypedIdentifierList |
    "#VariableDeclarationDefault" AstTypedIdentifierList |
    "#VariableDeclarationHeat" AstExpression AstTypedIdentifierList |
    "#VariableDeclarationMany" AstTypedIdentifierList ValueSequence |
    "#VariableDeclarationOne" AstIdentifier AstTypeName

  /**
   * Assignment
   */

  rule
    <k>
      #Execute AstAssignment(IL:AstIdentifierList, E) =>
      #AssignmentHeat IL E
      ...
    </k>

  rule
    <k>
      #AssignmentHeat IL:AstIdentifierList E =>
      #Execute E ~> #AssignmentCool IL
      ...
    </k>

  rule
    <k>
      VS:ValueSequence ~> #AssignmentCool IL:AstIdentifierList =>
      #AssignmentRecursive IL VS
      ...
    </k>

  rule
    <k>
      #AssignmentRecursive .List .ValueSequence =>
      .
      ...
    </k>

  rule
    <k>
      #AssignmentRecursive (ListItem(I) IL):AstIdentifierList (V VS):ValueSequence =>
      #AssignmentRecursive IL VS
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

  rule
    <k>
      #Execute AstBlock(SS:AstStatementSequence) =>
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

  rule
    <k>
      #Execute AstBreak() =>
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
      #Execute AstCode(B:AstBlock) =>
      #Execute B
      ...
    </k>

  /**
   * Continue
   */

  rule
    <k>
      #Execute AstContinue() =>
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
      #Execute AstData(LS:AstLiteralString, LH:AstLiteralHex) =>
      .
      ...
    </k>

  rule
    <k>
      #Execute AstData(LS1:AstLiteralString, LS2:AstLiteralString) =>
      .
      ...
    </k>

  /**
   * Expression
   */

  rule
    <k>
      #Execute AstExpression(FC:AstFunctionCall) =>
      #Execute FC
      ...
    </k>

  rule
    <k>
      #Execute AstExpression(I:AstIdentifier) =>
      #Execute I
      ...
    </k>

  rule
    <k>
      #Execute AstExpression(TL:AstTypedLiteral) =>
      #Execute TL
      ...
    </k>

  /**
   * For
   */

  rule
    <k>
      #Execute AstFor(AstBlock(SS:AstStatementSequence), E:AstExpression, B1:AstBlock, B2:AstBlock) =>
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
      #ForHeat E:AstExpression B1:AstBlock B2:AstBlock =>
      #Execute E ~> #ForCool E B1 B2
      ...
    </k>

  rule
    <k>
      (#ValueBool true) .ValueSequence ~> #ForCool E:AstExpression B1:AstBlock B2:AstBlock =>
      (
        #Execute B2 ~>
        #ForContinueMarker ~>
        #Execute B1 ~>
        #ForHeat E B1 B2
      )
      ...
    </k>

  rule
    <k>
      (#ValueBool false) .ValueSequence ~> #ForCool E:AstExpression B1:AstBlock B2:AstBlock =>
      .
      ...
    </k>

  /**
   * FunctionCall
   */

  rule
    <k>
      #Execute AstFunctionCall(I:AstIdentifier, EL:AstExpressionList) =>
      #FunctionCallHeat I EL
      ...
    </k>
    <cFunctionName> I </cFunctionName>

  rule
    <k>
      #FunctionCallHeat I:AstIdentifier EL:AstExpressionList =>
      #ExecuteFunctionArguments EL ~> #FunctionCallCool I
      ...
    </k>
    <cFunctionName> I </cFunctionName>

  rule
    <k>
      VS:ValueSequence ~> #FunctionCallCool I:AstIdentifier =>
      (
        #SymbolTablePush ~>
        #EnvironmentReplace ~>
        #EnvironmentPush ~>
        #FunctionCallDeclareArguments I 0 VS ~>
        #FunctionCallDeclareReturnArguments I 0 ~>
        #Execute FB ~>
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
      #FunctionCallDeclareArguments I1:AstIdentifier I2:Int .ValueSequence =>
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
      #FunctionCallDeclareArguments I1:AstIdentifier I2:Int (V VS):ValueSequence =>
      (
        V ~> #VariableDeclarationOne FPN FPT ~>
        #FunctionCallDeclareArguments I1 (I2 +Int 1) VS
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
      #FunctionCallDeclareReturnArguments I1:AstIdentifier I2:Int =>
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
      #FunctionCallDeclareReturnArguments I1:AstIdentifier I2:Int =>
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
      #FunctionCallCollectReturnValues I1:AstIdentifier I2:Int =>
      #FunctionCallCollectReturnValuesRecursive I1 I2 .ValueSequence
      ...
    </k>
    <cFunctionName> I1 </cFunctionName>

  rule
    <k>
      #FunctionCallCollectReturnValuesRecursive I1:AstIdentifier I2:Int VS:ValueSequence =>
      reverseValueSequence(VS)
      ...
    </k>
    <cFunction>
      <cFunctionName> I1 </cFunctionName>
      <cFunctionReturnArity> I2 </cFunctionReturnArity>
      ...
    </cFunction>

  rule
    <k>
      #FunctionCallCollectReturnValuesRecursive I1:AstIdentifier I2:Int VS:ValueSequence =>
      #FunctionCallCollectReturnValuesRecursive I1 (I2 +Int 1) (VV VS)
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
      .ValueSequence ~> #FunctionCallReturn =>
      (
        #EnvironmentPop ~>
        #EnvironmentRestore ~>
        #SymbolTablePop
      )
      ...
    </k>

  rule
    <k>
      (V VS):ValueSequence ~> #FunctionCallReturn =>
      (
        #EnvironmentPop ~>
        #EnvironmentRestore ~>
        #SymbolTablePop ~>
        V VS
      )
      ...
    </k>

  /**
   * FunctionDefinition
   */

  rule
    <k>
      #Execute AstFunctionDefinition(
        I:AstIdentifier,
        TIL1:AstTypedIdentifierList,
        TIL2:AstTypedIdentifierList,
        B:AstBlock
      ) =>
      (
        #DefineFunction I B ~>
        #DefineFunctionParameters I TIL1 ~>
        #DefineFunctionReturnParameters I TIL2
      )
      ...
    </k>

  rule
    <k>
      #DefineFunction I:AstIdentifier B:AstBlock =>
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
      #DefineFunctionParameters I:AstIdentifier .List =>
      .
      ...
    </k>

  rule
    <k>
      #DefineFunctionParameters
        I1:AstIdentifier
        (ListItem(AstTypedIdentifier(I2, TN)) TIL):AstTypedIdentifierList
      =>
      #DefineFunctionParameters I1 TIL
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
      #DefineFunctionReturnParameters I:AstIdentifier .List =>
      .
      ...
    </k>

  rule
    <k>
      #DefineFunctionReturnParameters
        I1:AstIdentifier
        (ListItem(AstTypedIdentifier(I2, TN)) TIL):AstTypedIdentifierList
      =>
      #DefineFunctionReturnParameters I1 TIL
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
      #Execute AstIdentifier(I) =>
      VV .ValueSequence
      ...
    </k>
    <cVariable>
      <cVariableName> AstIdentifier(I) </cVariableName>
      <cVariableValue> VV </cVariableValue>
      ...
    </cVariable>

  /**
   * If
   */

  rule
    <k>
      #Execute AstIf(E:AstExpression, B:AstBlock) =>
      #IfHeat E B
      ...
    </k>

  rule
    <k>
      #IfHeat E:AstExpression B:AstBlock =>
      #Execute E ~> #IfCool B
      ...
    </k>

  rule
    <k>
      (#ValueBool true) .ValueSequence ~> #IfCool B:AstBlock =>
      #Execute B
      ...
    </k>

  rule
    <k>
      (#ValueBool false) .ValueSequence ~> #IfCool B:AstBlock =>
      .
      ...
    </k>

  /**
   * Object
   */

  rule
    <k>
      #Execute AstObject(
        LS:AstLiteralString,
        C:AstCode,
        OODS:AstObjectOrDataSequence
      ) =>
      #Execute C ~> #ObjectOrDataSequenceSpread OODS
      ...
    </k>

  rule
    <k>
      #ObjectOrDataSequenceSpread .List =>
      .
      ...
    </k>

  rule
    <k>
      #ObjectOrDataSequenceSpread (ListItem(OOD) OODS):AstObjectOrDataSequence =>
      #Execute OOD ~> #ObjectOrDataSequenceSpread OODS
      ...
    </k>

  /**
   * ObjectOrData
   */

  rule
    <k>
      #Execute AstObjectOrData(D:AstData) =>
      .
      ...
    </k>

  rule
    <k>
      #Execute AstObjectOrData(O:AstObject) =>
      .
      ...
    </k>

  /**
   * StatementSequence
   */

  rule
    <k>
      #StatementSequenceHoist SS:AstStatementSequence =>
      #StatementSequenceHoistRecursive SS .List .List
      ...
    </k>

  rule
    <k>
      #StatementSequenceHoistRecursive .List L1:List L2:List =>
      #StatementSequenceHoistSpread reverseList(reverseList(L1) reverseList(L2))
      ...
    </k>

  rule
    <k>
      #StatementSequenceHoistRecursive (ListItem(S) SS):AstStatementSequence L1:List L2:List =>
      #StatementSequenceHoistRecursiveHeat S SS L1 L2
      ...
    </k>

  rule
    <k>
      #StatementSequenceHoistRecursiveHeat S:AstStatement SS:AstStatementSequence L1:List L2:List =>
      #IsFunctionDefinition S ~> #StatementSequenceHoistRecursiveCool S SS L1 L2
      ...
    </k>

  rule
    <k>
      true ~> #StatementSequenceHoistRecursiveCool S:AstStatement SS:AstStatementSequence L1:List L2:List =>
      #StatementSequenceHoistRecursive SS (ListItem(S) L1) L2
      ...
    </k>

  rule
    <k>
      false ~> #StatementSequenceHoistRecursiveCool S:AstStatement SS:AstStatementSequence L1:List L2:List =>
      #StatementSequenceHoistRecursive SS L1 (ListItem(S) L2)
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
      #StatementSequenceHoistSpread (ListItem(S) SS):AstStatementSequence =>
      #StatementSequenceHoistSpread SS ~> #Execute S
      ...
    </k>

  /**
   * Program
   */

  rule
    <k>
      #Execute AstProgram(B:AstBlock) =>
      #Execute B
      ...
    </k>

  rule
    <k>
      #Execute AstProgram(O:AstObject) =>
      #Execute O
      ...
    </k>

  /**
   * Statement
   */

  rule
    <k>
      #Execute AstStatement(A:AstAssignment) =>
      #Execute A
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(B:AstBlock) =>
      #Execute B
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(B:AstBreak) =>
      #Execute B
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(C:AstContinue) =>
      #Execute C
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(D:AstDebug) =>
      #Execute D
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(E:AstExpression) =>
      #Execute E
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(F:AstFor) =>
      #Execute F
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(FD:AstFunctionDefinition) =>
      #Execute FD
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(I:AstIf) =>
      #Execute I
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(S:AstSwitch) =>
      #Execute S
      ...
    </k>

  rule
    <k>
      #Execute AstStatement(VD:AstVariableDeclaration) =>
      #Execute VD
      ...
    </k>

  /**
   * Switch
   */

  rule
    <k>
      #Execute AstSwitch(E:AstExpression, CS:AstCaseSequence, D:AstDefault) =>
      #SwitchHeat E CS D
      ...
    </k>

  rule
    <k>
      #SwitchHeat E:AstExpression CS:AstCaseSequence D:AstDefault =>
      #Execute E ~> #SwitchCool CS D
      ...
    </k>

  rule
    <k>
      (V .ValueSequence) ~> #SwitchCool CS:AstCaseSequence D:AstDefault =>
      #SwitchRecursive V CS D
      ...
    </k>

  rule
    <k>
      #SwitchRecursive V:Value .List .AstDefault =>
      .
      ...
    </k>

  rule
    <k>
      #SwitchRecursive V:Value .List (AstDefault(B:AstBlock)) =>
      #Execute B
      ...
    </k>

  rule
    <k>
      #SwitchRecursive V:Value (ListItem (AstCase(TL, B)) CS):AstCaseSequence D:AstDefault =>
      #SwitchRecursiveHeat TL V B CS D
      ...
    </k>

  rule
    <k>
      #SwitchRecursiveHeat
        TL:AstTypedLiteral
        V:Value
        B:AstBlock
        CS:AstCaseSequence
        D:AstDefault
      =>
      #Execute TL ~> #SwitchRecursiveCool V B CS D
      ...
    </k>

  rule
    <k>
      (V1 .ValueSequence) ~>
        #SwitchRecursiveCool
          V2:Value
          B:AstBlock
          CS:AstCaseSequence
          D:AstDefault
      =>
      (
        #if V1 ==K V2
        #then
          #Execute B
        #else
          #SwitchRecursive V2 CS D
        #fi
      )
      ...
    </k>

  /**
   * TypedLiteral
   */

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralBool(B)),
          AstTypeName(AstTypeNameBuiltIn(bool))
        )
      ) =>
      (#ValueBool B) .ValueSequence
      ...
    </k>

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(u8))
        )
      ) =>
      (#ValueU8 I) .ValueSequence
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 8)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(u32))
        )
      ) =>
      (#ValueU32 I) .ValueSequence
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 32)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(u64))
        )
      ) =>
      (#ValueU64 I) .ValueSequence
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 64)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(u128))
        )
      ) =>
      (#ValueU128 I) .ValueSequence
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 128)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(u256))
        )
      ) =>
      (#ValueU256 I) .ValueSequence
      ...
    </k>
    requires (0 <=Int I) andBool (I <Int (2 ^Int 256)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(s8))
        )
      ) =>
      (#ValueS8 I) .ValueSequence
      ...
    </k>
    requires ((0 -Int (2 ^Int 7)) <=Int I) andBool (I <Int (2 ^Int 7)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(s32))
        )
      ) =>
      (#ValueS32 I) .ValueSequence
      ...
    </k>
    requires ((0 -Int (2 ^Int 31)) <=Int I) andBool (I <Int (2 ^Int 31)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(s64))
        )
      ) =>
      (#ValueS64 I) .ValueSequence
      ...
    </k>
    requires ((0 -Int (2 ^Int 63)) <=Int I) andBool (I <Int (2 ^Int 63)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(s128))
        )
      ) =>
      (#ValueS128 I) .ValueSequence
      ...
    </k>
    requires ((0 -Int (2 ^Int 127)) <=Int I) andBool (I <Int (2 ^Int 127)) // >

  rule
    <k>
      #Execute (
        AstTypedLiteral(
          AstLiteral(AstLiteralNumber(AstLiteralNumberInt(I))),
          AstTypeName(AstTypeNameBuiltIn(s256))
        )
      ) =>
      (#ValueS256 I) .ValueSequence
      ...
    </k>
    requires ((0 -Int (2 ^Int 255)) <=Int I) andBool (I <Int (2 ^Int 255)) // >

  /**
   * VariableDeclaration
   */

  rule
    <k>
      #Execute AstVariableDeclaration(TIL:AstTypedIdentifierList) =>
      #VariableDeclarationDefault TIL
      ...
    </k>

  rule
    <k>
      #VariableDeclarationDefault .List =>
      .
      ...
    </k>

  rule
    <k>
      #VariableDeclarationDefault
        (ListItem(AstTypedIdentifier(I, TN)) TIL):AstTypedIdentifierList
      =>
      (
        #DefaultValue TN ~> #VariableDeclarationOne I TN ~>
        #VariableDeclarationDefault TIL
      )
      ...
    </k>

  rule
    <k>
      V:Value ~> #VariableDeclarationOne I:AstIdentifier TN:AstTypeName =>
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
      #Execute AstVariableDeclaration(TIL:AstTypedIdentifierList, E:AstExpression) =>
      #VariableDeclarationHeat E TIL
      ...
    </k>

  rule
    <k>
      #VariableDeclarationHeat E:AstExpression TIL:AstTypedIdentifierList =>
      #Execute E ~> #VariableDeclarationCool TIL
      ...
    </k>

  rule
    <k>
      VS:ValueSequence ~> #VariableDeclarationCool TIL =>
      #VariableDeclarationMany TIL VS
      ...
    </k>

  rule
    <k>
      #VariableDeclarationMany .List .ValueSequence =>
      .
      ...
    </k>

  rule
    <k>
      #VariableDeclarationMany
        (ListItem(AstTypedIdentifier(I, TN)) TIL):AstTypedIdentifierList
        (V VS):ValueSequence
      =>
      (
        V ~> #VariableDeclarationOne I TN ~>
        #VariableDeclarationMany TIL VS
      )
      ...
    </k>

endmodule

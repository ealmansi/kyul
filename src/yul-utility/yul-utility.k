require "../yul-configuration/yul-configuration.k"
require "../yul-syntax/yul-syntax.k"
require "../yul-value/yul-value.k"

module YUL-UTILITY
  imports DOMAINS
  imports YUL-CONFIGURATION
  imports YUL-SYNTAX
  imports YUL-VALUE

  /**
   * Configuration
   */

  syntax KItem ::=
    "#EnvironmentPop" |
    "#EnvironmentPush" |
    "#EnvironmentReplace" |
    "#EnvironmentRestore" |
    "#SymbolTablePop" |
    "#SymbolTablePush"

  rule
    <k>
      #EnvironmentPop =>
      .
      ...
    </k>
    <cEnvironmentStack>
      <cEnvironmentStackSize> ESS:Int => ESS -Int 1 </cEnvironmentStackSize>
      (
        (
          <cEnvironment>
            <cEnvironmentIndex> ESS -Int 1 </cEnvironmentIndex>
            ...
          </cEnvironment>
        ) =>
        .Bag
      )
      ...
    </cEnvironmentStack>

  rule
    <k>
      #EnvironmentPush =>
      .
      ...
    </k>
    <cEnvironmentStack>
      <cEnvironmentStackSize> ESS:Int => ESS +Int 1 </cEnvironmentStackSize>
      (
        .Bag =>
        (
          <cEnvironment>
            <cEnvironmentIndex> ESS </cEnvironmentIndex>
            ...
          </cEnvironment>
        )
      )
      ...
    </cEnvironmentStack>

  rule
    <k>
      #EnvironmentReplace =>
      .
      ...
    </k>
    <cEnvironmentStack>
      ES:Bag =>
      <cEnvironmentStackSize> 0 </cEnvironmentStackSize>
    </cEnvironmentStack>
    <cEnvironmentStackCopies>
      .List =>
      ListItem(<cEnvironmentStack> ES </cEnvironmentStack>)
      ...
    </cEnvironmentStackCopies>

  rule
    <k>
      #EnvironmentRestore =>
      .
      ...
    </k>
    <cEnvironmentStack>
      _:Bag =>
      ES
    </cEnvironmentStack>
    <cEnvironmentStackCopies>
      ListItem(<cEnvironmentStack> ES:Bag </cEnvironmentStack>) =>
      .List
      ...
    </cEnvironmentStackCopies>

  rule
    <k>
      #SymbolTablePop =>
      .
      ...
    </k>
    <cSymbolTableStack>
      <cSymbolTableStackSize> STSS:Int => STSS -Int 1 </cSymbolTableStackSize>
      (
        (
          <cSymbolTable>
            <cSymbolTableIndex> STSS -Int 1 </cSymbolTableIndex>
            ...
          </cSymbolTable>
        ) =>
        .Bag
      )
      ...
    </cSymbolTableStack>

  rule
    <k>
      #SymbolTablePush =>
      .
      ...
    </k>
    <cSymbolTableStack>
      <cSymbolTableStackSize> STSS:Int => STSS +Int 1 </cSymbolTableStackSize>
      (
        .Bag =>
        (
          <cSymbolTable>
            <cSymbolTableIndex> STSS </cSymbolTableIndex>
            ...
          </cSymbolTable>
        )
      )
      ...
    </cSymbolTableStack>

  /**
   * IsFunctionDefinition
   */

  syntax KItem ::=
    "#IsFunctionDefinition" Statement

  rule
    <k>
      #IsFunctionDefinition A:Assignment =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition B:Block =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition B:Break =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition C:Continue =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition D:Debug =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition E:Expression =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition F:For =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition FD:FunctionDefinition =>
      true
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition I:If =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition S:Switch =>
      false
      ...
    </k>

  rule
    <k>
      #IsFunctionDefinition VD:VariableDeclaration =>
      false
      ...
    </k>

  /**
   * toBuiltInList
   */

  syntax List ::=
    toBuiltInList(CaseSequence) [function]

  rule toBuiltInList(C:Case) =>
    ListItem(C)

  rule toBuiltInList(`CaseSequence`(CS:CaseSequence, C:Case)) =>
    toBuiltInList(CS) ListItem(C)

  syntax List ::=
    toBuiltInList(ExpressionList) [function]

  rule toBuiltInList(E:Expression) =>
    ListItem(E)

  rule toBuiltInList(`ExpressionList`(EL:ExpressionList, E:Expression)) =>
    toBuiltInList(EL) ListItem(E)

  syntax List ::=
    toBuiltInList(IdentifierList) [function]

  rule toBuiltInList(I:Identifier) =>
    ListItem(I)

  rule toBuiltInList(`IdentifierList`(IL:IdentifierList, I:Identifier)) =>
    toBuiltInList(IL) ListItem(I)

  syntax List ::=
    toBuiltInList(StatementSequence) [function]

  rule toBuiltInList(S:Statement) =>
    ListItem(S)

  rule toBuiltInList(`StatementSequence`(SS:StatementSequence, S:Statement)) =>
    toBuiltInList(SS) ListItem(S)

  syntax List ::=
    toBuiltInList(TypedIdentifierList) [function]

  rule toBuiltInList(TI:TypedIdentifier) =>
    ListItem(TI)

  rule toBuiltInList(`TypedIdentifierList`(TIL:TypedIdentifierList, TI:TypedIdentifier)) =>
    toBuiltInList(TIL) ListItem(TI)

  /**
   * reverseList
   */

  syntax List ::=
    reverseList(List) [function]

  rule reverseList(.List) =>
    .List

  rule reverseList((ListItem(E:Expression) EL:List):List) =>
    reverseList(EL) ListItem(E)
  
  rule reverseList((ListItem(V:Value) VL:List):List) =>
    reverseList(VL) ListItem(V)

  rule reverseList((ListItem(S:Statement) SS:List):List) =>
    reverseList(SS) ListItem(S)

endmodule

requires "../yul-ast/yul-ast.k"
requires "../yul-syntax/yul-syntax.k"
requires "../yul-type/yul-type.k"

module YUL-UTILITY
  imports DOMAINS
  imports YUL-AST
  imports YUL-SYNTAX
  imports YUL-TYPE

  /**
   * Hole
   */

  syntax Hole ::=
    "HOLE"

  /**
   * Maybe
   */

  syntax Maybe ::=
    Just(KItem) |
    Nothing()

  /**
   * isAstFunctionDefinition [BUILT-IN]
   */

  syntax Bool ::=
    isAstFunctionDefinition(AstStatement)

  /**
   * getFunctionDefinitionName
   */

  syntax Identifier ::=
    getFunctionDefinitionName(AstFunctionDefinition) [function]

  rule
    getFunctionDefinitionName(AstFunctionDefinition(I:Identifier, _:List, _:List, _:AstBlock)) =>
    I

  /**
   * getFunctionDefinitionType
   */

  syntax Type ::=
    getFunctionDefinitionType(AstFunctionDefinition) [function]

  rule
    getFunctionDefinitionType(
      AstFunctionDefinition(_:Identifier, TIL1:List, TIL2:List, _:AstBlock)
    ) =>
    TypeFunction(getTypedIdentifierListTypeTuple(TIL1), getTypedIdentifierListTypeTuple(TIL2))

  /**
   * getTypedIdentifierListTypeTuple
   */

  syntax TypeTuple ::=
    getTypedIdentifierListTypeTuple(List) [function]

  rule
    getTypedIdentifierListTypeTuple(.List) =>
    makeTypeTuple()

  rule
    getTypedIdentifierListTypeTuple(
      ListItem(AstTypedIdentifier(I:Identifier, TN:TypeName)) TIL:List
    ) =>
    mergeTypeTuples(makeTypeTuple(TN), getTypedIdentifierListTypeTuple(TIL))

endmodule

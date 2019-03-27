requires "../yul-syntax/yul-syntax.k"

module YUL-TYPE
  imports DOMAINS
  imports YUL-SYNTAX

  /**
   * Type
   */

  syntax Type ::=
    TypeFunction |
    TypeName |
    TypeTuple

  /**
   * TypeFunction
   */

  syntax TypeFunction ::=
    TypeFunction(TypeTuple, TypeTuple)

  /**
   * TypeTuple
   */

  syntax TypeTuple ::=
    TypeTuple(Int, List)

  /**
   * makeTypeTuple
   */

  syntax TypeTuple ::=
    makeTypeTuple() [function] |
    makeTypeTuple(Type) [function] |
    makeTypeTuple(Type, Type) [function] |
    makeTypeTuple(Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type, Type, Type, Type) [function] |
    makeTypeTuple(Type, Type, Type, Type, Type, Type, Type, Type) [function]

  rule
    makeTypeTuple() =>
    TypeTuple(0, .List)

  rule
    makeTypeTuple(T1:Type) =>
    TypeTuple(1, ListItem(T1))

  rule
    makeTypeTuple(T1:Type, T2:Type) =>
    TypeTuple(2, ListItem(T1) ListItem(T2))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type) =>
    TypeTuple(3, ListItem(T1) ListItem(T2) ListItem(T3))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type, T4:Type) =>
    TypeTuple(4, ListItem(T1) ListItem(T2) ListItem(T3) ListItem(T4))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type, T4:Type, T5:Type) =>
    TypeTuple(5, ListItem(T1) ListItem(T2) ListItem(T3) ListItem(T4) ListItem(T5))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type, T4:Type, T5:Type, T6:Type) =>
    TypeTuple(6, ListItem(T1) ListItem(T2) ListItem(T3) ListItem(T4) ListItem(T5) ListItem(T6))

  rule
    makeTypeTuple(T1:Type, T2:Type, T3:Type, T4:Type, T5:Type, T6:Type, T7:Type) =>
    TypeTuple(
      7,
      ListItem(T1) ListItem(T2) ListItem(T3) ListItem(T4) ListItem(T5) ListItem(T6) ListItem(T7)
    )

  /**
   * mergeTypeTuples
   */

  syntax TypeTuple ::=
    mergeTypeTuples(TypeTuple, TypeTuple) [function]

  rule
    mergeTypeTuples(TypeTuple(I1:Int, L1:List), TypeTuple(I2:Int, L2:List)) =>
    TypeTuple(I1 +Int I2, L1 L2)

endmodule

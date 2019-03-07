module FOO-SYNTAX
  imports DOMAINS-SYNTAX

  syntax Pgm ::=
    Foo Bar [klabel(Pgm1)] |
    Foo Bar Pgm [klabel(Pgm2)] |
    Foo Pgm Bar [klabel(Pgm3)] |
    Foo Pgm Bar Pgm [klabel(Pgm4)]

  syntax Foo ::=
    "foo" [klabel(Foo), token]

  syntax Bar ::=
    "bar" [klabel(Bar), token]
  
  syntax FooBar ::=
    Foo |
    Bar |
    FooBar Foo [left, klabel(FooBar3)] |
    FooBar Bar [left, klabel(FooBar4)]

endmodule

module FOO
  imports DOMAINS
  imports FOO-SYNTAX

  configuration
    <T>
      <k> $PGM:FooBar </k>
      <stack>
        <count> 0 </count>
        <item multiplicity="*">
          <index> -1 </index>
        </item>
      </stack>
    </T>

  rule `Pgm1`(F:Foo, B:Bar) => F ~> B
  rule `Pgm2`(F:Foo, B:Bar, P:Pgm) => F ~> B ~> P
  rule `Pgm3`(F:Foo, P:Pgm, B:Bar) => F ~> P ~> B
  rule `Pgm4`(F:Foo, P1:Pgm, B:Bar, P2:Pgm) => F ~> P1 ~> B ~> P2

  rule
    <k> foo => . ... </k>
    <stack>
      <count> C => C +Int 1 </count>
      (
        .Bag =>
        <item>
          <index> C </index>
        </item>
      )
      ...
    </stack>

  rule
    <k> bar => . ... </k>
    <stack>
      <count> C => C -Int 1 </count>
      (
        <item>
          <index> C -Int 1 </index>
        </item> =>
        .Bag
      )
      ...
    </stack>
  
endmodule

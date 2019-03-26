module BLA-SYNTAX
  imports DOMAINS-SYNTAX

  syntax Pp ::= "do" Bb [klabel(Pp)]
  syntax Bb ::= "{" Aa "}" [klabel(Bb)]
  syntax Aa ::= Vv "=" Vv [klabel(Aa)]
  syntax Vv ::= "x" [token] | "y" [token]

endmodule

module BLA
  imports DOMAINS
  imports BLA-SYNTAX

  configuration
    <T>
      <k>
        $PGM:Pp
      </k>
    </T>

  rule P:Pp => tCPp(P)

  syntax Hole ::= "HOLE"

  syntax KResult ::= Rr
  syntax Rr ::= RrOk() | RrErr()

  rule RrErr() ~> KI:KItem => RrErr() [structural]

  syntax KItem ::= tCPp(Pp)
  rule tCPp(`Pp`(B:Bb)) => tCBb(B) ~> tCPp(`Pp`(HOLE))
  rule RrOk() ~> tCPp(`Pp`(HOLE)) => RrOk()

  syntax KItem ::= tCBb(Bb)
  rule tCBb(`Bb`(A:Aa)) => tCAa(A) ~> tCBb(`Bb`(HOLE))
  rule RrOk() ~> tCBb(`Bb`(HOLE)) => RrOk()

  syntax KItem ::= tCAa(Aa)
  rule tCAa(`Aa`(V1:Vv, V2:Vv)) => RrOk() requires V1 ==K V2
  rule tCAa(`Aa`(V1:Vv, V2:Vv)) => RrErr() requires V1 =/=K V2

endmodule

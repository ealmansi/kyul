# KYUL: K Semantics of Yul
Yul, the intermediate language for Ethereum, implemented in [K Framework](https://github.com/kframework/k)

# TODO
- Syntax: hex literals.
- Syntax: check [grammar restrictions](https://solidity.readthedocs.io/en/v0.5.5/yul.html#restrictions-on-the-grammar).
- Type checking.
- Semantics: [Yul object](https://solidity.readthedocs.io/en/v0.5.5/yul.html#specification-of-yul-object).
- [Low-level functions](https://solidity.readthedocs.io/en/v0.5.5/yul.html#low-level-functions):
  - Arithmetic bitwise operations.
  - Memory and storage.
  - Execution control.
  - Miscellaneous ("Others").
- Verification:
  - Use concrete syntax instead of AST for `kprove` specs.
  - Correctness proof for sum of natural numbers program.

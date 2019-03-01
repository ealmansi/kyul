module.exports = {
  title: 'Built-In Functions',
  testCases: [
    {
      description: 'Type conversion from "bool" should work correctly.',
      sourceFile: 'built-in/type-conversion/bool.yul',
      success: (assert, { T: { k: [k] } }) => assert.equal(k, '.')
    },
    {
      description: 'Type conversion from "u32" should work correctly.',
      sourceFile: 'built-in/type-conversion/u32.yul',
      success: (assert, { T: { k: [k] } }) => assert.equal(k, '.')
    },
    {
      description: 'Type conversion from "u64" should work correctly.',
      sourceFile: 'built-in/type-conversion/u64.yul',
      success: (assert, { T: { k: [k] } }) => assert.equal(k, '.')
    },
    {
      description: 'Type conversion from "u256" should work correctly.',
      sourceFile: 'built-in/type-conversion/u256.yul',
      success: (assert, { T: { k: [k] } }) => assert.equal(k, '.')
    },
    {
      description: 'Type conversion from "s256" should work correctly.',
      sourceFile: 'built-in/type-conversion/s256.yul',
      success: (assert, { T: { k: [k] } }) => assert.equal(k, '.')
    },
    {
      description: 'Boolean logic functions should work correctly.',
      sourceFile: 'built-in/logic.yul',
      success: (assert, { T: { k: [k] } }) => assert.equal(k, '.')
    },
    {
      description: 'Arithmetic functions should work correctly.',
      sourceFile: 'built-in/arithmetic.yul',
      success: (assert, { T: { k: [k] } }) => assert.equal(k, '.')
    }
  ]
}

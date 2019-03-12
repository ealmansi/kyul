module.exports = {
  title: 'Scope',
  testCases: [
    {
      description: 'Functions should be visible in nested blocks.',
      sourceFile: 'scope/function-nested-blocks.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      description: 'Variables should be visible in nested blocks.',
      sourceFile: 'scope/variable-nested-blocks.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      description: 'Functions should go out of scope at the end of a block.',
      sourceFile: 'scope/function-out-of-scope-end-of-block.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      description: 'Variables should go out of scope at the end of a block.',
      sourceFile: 'scope/variable-out-of-scope-end-of-block.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      description: 'Functions should be visible before being defined (hoisting).',
      sourceFile: 'scope/function-hoisting.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    }
  ]
}

module.exports = {
  title: 'Syntax',
  testCases: [
    {
      description: 'Every syntactical construction should be parseable and have some semantics.',
      sourceFile: 'syntax/exhaustive.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    }
  ]
}

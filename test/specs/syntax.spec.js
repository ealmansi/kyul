module.exports = {
  title: 'Syntax',
  testCases: [
    {
      suites: ['light', 'full'],
      description: 'Every block construction should be parsed correctly. (1)',
      sourceFile: 'syntax/block-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every block construction should be parsed correctly. (2)',
      sourceFile: 'syntax/block-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every expression construction should be parsed correctly. (1)',
      sourceFile: 'syntax/expression-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every expression construction should be parsed correctly. (2)',
      sourceFile: 'syntax/expression-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every for construction should be parsed correctly. (1)',
      sourceFile: 'syntax/for-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every for construction should be parsed correctly. (2)',
      sourceFile: 'syntax/for-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every function definition construction should be parsed correctly. (1)',
      sourceFile: 'syntax/function-definition-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every function definition construction should be parsed correctly. (2)',
      sourceFile: 'syntax/function-definition-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every if construction should be parsed correctly. (1)',
      sourceFile: 'syntax/if-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every if construction should be parsed correctly. (2)',
      sourceFile: 'syntax/if-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every literal construction should be parsed correctly. (1)',
      sourceFile: 'syntax/literal-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every literal construction should be parsed correctly. (2)',
      sourceFile: 'syntax/literal-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every object construction should be parsed correctly. (1)',
      sourceFile: 'syntax/object-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every object construction should be parsed correctly. (2)',
      sourceFile: 'syntax/object-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every program construction should be parsed correctly. (1)',
      sourceFile: 'syntax/program-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every program construction should be parsed correctly. (2)',
      sourceFile: 'syntax/program-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every switch construction should be parsed correctly. (1)',
      sourceFile: 'syntax/switch-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every switch construction should be parsed correctly. (2)',
      sourceFile: 'syntax/switch-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Every variable decl. & assgn. construction should be parsed correctly. (1)',
      sourceFile: 'syntax/variable-declaration-assignment-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Every variable decl. & assgn. construction should be parsed correctly. (2)',
      sourceFile: 'syntax/variable-declaration-assignment-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    }
  ]
}

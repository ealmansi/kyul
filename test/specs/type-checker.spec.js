module.exports = {
  title: 'Type Checker',
  testCases: [
    {
      suites: ['full'],
      description: 'Every valid construction should be successfully typechecked.',
      sourceFile: 'type-checker/valid-exhaustive.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Type check should fail if an expression has the wrong type (1).',
      sourceFile: 'type-checker/expression-has-wrong-type-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorExpressionHasWrongType"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if an expression has the wrong type (2).',
      sourceFile: 'type-checker/expression-has-wrong-type-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorExpressionHasWrongType"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if an expression has the wrong type (3).',
      sourceFile: 'type-checker/expression-has-wrong-type-3.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorExpressionHasWrongType"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if an expression has the wrong type (4).',
      sourceFile: 'type-checker/expression-has-wrong-type-4.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorExpressionHasWrongType"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if an expression has the wrong type (5).',
      sourceFile: 'type-checker/expression-has-wrong-type-5.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorExpressionHasWrongType"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if an expression has the wrong type (6).',
      sourceFile: 'type-checker/expression-has-wrong-type-6.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorExpressionHasWrongType"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if an expression has the wrong type (7).',
      sourceFile: 'type-checker/expression-has-wrong-type-7.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorExpressionHasWrongType"))
    },
    {
      suites: ['light', 'full'],
      description: 'Type check should fail if a function is redefined (1).',
      sourceFile: 'type-checker/function-already-defined-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorFunctionAlreadyDefined"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a function is redefined (2).',
      sourceFile: 'type-checker/function-already-defined-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorFunctionAlreadyDefined"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a function is redefined (3).',
      sourceFile: 'type-checker/function-already-defined-3.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorFunctionAlreadyDefined"))
    },
    {
      suites: ['light', 'full'],
      description: 'Type check should fail if a function is used when undefined (1).',
      sourceFile: 'type-checker/function-is-undefined-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorFunctionIsUndefined"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a function is used when undefined (2).',
      sourceFile: 'type-checker/function-is-undefined-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorFunctionIsUndefined"))
    },
    {
      suites: ['light', 'full'],
      description: 'Type check should fail if there\'s an invalid function call (1).',
      sourceFile: 'type-checker/invalid-function-call-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorInvalidFunctionCall"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if there\'s an invalid function call (2).',
      sourceFile: 'type-checker/invalid-function-call-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorInvalidFunctionCall"))
    },
    {
      suites: ['light', 'full'],
      description: 'Type check should fail if a variable is redefined (1).',
      sourceFile: 'type-checker/variable-already-defined-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableAlreadyDefined"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a variable is redefined (2).',
      sourceFile: 'type-checker/variable-already-defined-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableAlreadyDefined"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a variable is redefined (3).',
      sourceFile: 'type-checker/variable-already-defined-3.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableAlreadyDefined"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a variable is redefined (4).',
      sourceFile: 'type-checker/variable-already-defined-4.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableAlreadyDefined"))
    },
    {
      suites: ['light', 'full'],
      description: 'Type check should fail if a variable is used when not accessible (1).',
      sourceFile: 'type-checker/variable-is-not-accessible-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableIsNotAccessible"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a variable is used when not accessible (2).',
      sourceFile: 'type-checker/variable-is-not-accessible-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableIsNotAccessible"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a variable is used when not accessible (3).',
      sourceFile: 'type-checker/variable-is-not-accessible-3.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableIsNotAccessible"))
    },
    {
      suites: ['light', 'full'],
      description: 'Type check should fail if a variable is used when undefined (1).',
      sourceFile: 'type-checker/variable-is-undefined-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableIsUndefined"))
    },
    {
      suites: ['full'],
      description: 'Type check should fail if a variable is used when undefined (2).',
      sourceFile: 'type-checker/variable-is-undefined-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.ok(k.startsWith("TypeCheckErrorVariableIsUndefined"))
    }
  ]
}

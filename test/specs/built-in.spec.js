module.exports = {
  title: 'Built-In Functions',
  testCases: [
    {
      suites: ['light', 'full'],
      description: 'Type conversion from "bool" should work correctly (1).',
      sourceFile: 'built-in/type-conversion/bool-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Type conversion from "bool" should work correctly (2).',
      sourceFile: 'built-in/type-conversion/bool-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Type conversion from "u32" should work correctly (1).',
      sourceFile: 'built-in/type-conversion/u32-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Type conversion from "u32" should work correctly (2).',
      sourceFile: 'built-in/type-conversion/u32-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Type conversion from "u64" should work correctly (1).',
      sourceFile: 'built-in/type-conversion/u64-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Type conversion from "u64" should work correctly (2).',
      sourceFile: 'built-in/type-conversion/u64-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Type conversion from "u256" should work correctly (1).',
      sourceFile: 'built-in/type-conversion/u256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Type conversion from "u256" should work correctly (2).',
      sourceFile: 'built-in/type-conversion/u256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Type conversion from "s256" should work correctly (1).',
      sourceFile: 'built-in/type-conversion/s256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Type conversion from "s256" should work correctly (2).',
      sourceFile: 'built-in/type-conversion/s256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Boolean logic functions should work correctly.',
      sourceFile: 'built-in/logic.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function addmodu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/addmodu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function addmodu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/addmodu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function addu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/addu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function addu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/addu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function byte should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/byte-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function byte should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/byte-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function divs256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/divs256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function divs256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/divs256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function divu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/divu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function divu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/divu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function equ256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/equ256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function equ256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/equ256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function expu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/expu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function expu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/expu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function gts256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/gts256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function gts256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/gts256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function gtu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/gtu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function gtu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/gtu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function iszerou256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/iszerou256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function iszerou256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/iszerou256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function lts256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/lts256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function lts256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/lts256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function ltu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/ltu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function ltu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/ltu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function mods256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/mods256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function mods256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/mods256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function modu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/modu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function modu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/modu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function mulmodu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/mulmodu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function mulmodu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/mulmodu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function mulu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/mulu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function mulu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/mulu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function notu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/notu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function notu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/notu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['light', 'full'],
      description: 'Arithmetic: function subu256 should work correctly. (1)',
      sourceFile: 'built-in/arithmetic/subu256-1.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    },
    {
      suites: ['full'],
      description: 'Arithmetic: function subu256 should work correctly. (2)',
      sourceFile: 'built-in/arithmetic/subu256-2.yul',
      success: (assert, { T: { k: [k] } }) =>
        assert.equal(k, '.')
    }
  ]
}

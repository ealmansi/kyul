const { krun } = require('./lib/krun')
const assert = require('assert')
const fs = require('fs')
const glob = require('glob')
const path = require('path')

const YUL_TEST_SUITE = process.env.YUL_TEST_SUITE || 'full'

describe('Yul Language', async () => {
  const specFilesPath = path.resolve(__dirname, 'specs', '**', '*.spec.js')
  const specFiles = glob.sync(specFilesPath)
  for (const specFile of specFiles) {
    const spec = require(specFile)
    describe(spec.title, async () => {
      for (const test of spec.testCases) {
        if (test.suites.indexOf(YUL_TEST_SUITE) !== -1) {
          it(test.description, async () => {
            const sourceFilePath = path.resolve(specFile, '..', test.sourceFile)
            const source = fs.readFileSync(sourceFilePath).toString()
            const result = await krun(source)
            test.success(assert, result)
          })
        }
      }
    })
  }
})

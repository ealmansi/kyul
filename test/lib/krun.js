const { parseString } = require('xml2js')
const { promisify } = require('util')
const assert = require('assert')
const fs = require('fs')
const path = require('path')
const shell = require('shelljs')
const tmp = require('tmp')

const parseXml = promisify(parseString)

const TEMP_DIR = path.relative(
  path.resolve(__dirname, '..'),
  path.resolve(__dirname, '..', '.tmp')
)

const YUL_DEFINITION_DIR = path.relative(
  path.resolve(__dirname, '..'),
  path.resolve(__dirname, '..', 'src', 'yul')
)

async function krun (yul) {
  shell.mkdir('-p', TEMP_DIR)
  const file = tmp.fileSync({ dir: TEMP_DIR })
  fs.writeFileSync(file.name, yul.trim())
  const { code, stdout, stderr } = shell.exec(
    `krun --output pretty --directory ${YUL_DEFINITION_DIR}/ ${file.name}`,
    { silent:true }
  )
  assert.deepEqual(code, 0, stdout || stderr)
  const res = await parseXml(stdout, { trim: true })
  return res
}

module.exports = {
  krun
}

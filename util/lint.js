const fs = require('fs')
const path = require('path')

const FILE_EXTENSION_K = '.k'

const args = process.argv
if (args.length !== 3) {
  console.error('Expected one, and only one argument: <src directory>.')
  process.exit(1)
}
else {
  visit(args[2])
}

function visit (somePath) {
  if (fs.lstatSync(somePath).isDirectory()) {
    for (const someSubPath of fs.readdirSync(somePath)) {
      visit(path.resolve(somePath, someSubPath))
    }
  }
  else {
    if (path.extname(somePath) === FILE_EXTENSION_K) {
      lint(somePath, fs.readFileSync(somePath).toString())
    }
  }
}

function lint (somePath, contents) {
  const lines = contents.split('\n')
  let enabled = true
  let ok = true
  for (const [index, line] of lines.entries()) {
    if (line.trim() === '/* lint:enable */') {
      enabled = true
    }
    else if (line.trim() === '/* lint:disable */') {
      enabled = false
    }
    else if (enabled) {
      if (line.length > 100) {
        console.error(somePath + ':' + (index + 1) + ' | Error: Line exceeds 100 characters.')
        ok = false
      }
      if (/ +$/.test(line)) {
        console.error(somePath + ':' + (index + 1) + ' | Error: Whitespace found before newline.')
        ok = false
      }
    }
  }
  if (!ok) {
    process.exit(1)
  }
}

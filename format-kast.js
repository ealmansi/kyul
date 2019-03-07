const fs = require('fs')

const NEWLINE = '\n'
const TAB = '  '

let data = fs.readFileSync(0, 'utf-8')
let spaces = 0
for (let c of data) {
  switch (c) {
    case '(':
      process.stdout.write(c)
      process.stdout.write(NEWLINE)
      spaces = spaces + 1
      for (let i = 0; i < spaces; ++i) {
        process.stdout.write(TAB)
      }
      break
    case ')':
      process.stdout.write(NEWLINE)
      spaces = spaces - 1
      for (let i = 0; i < spaces; ++i) {
        process.stdout.write(TAB)
      }
      process.stdout.write(c)
      break
    case ',':
      process.stdout.write(c)
      process.stdout.write(NEWLINE)
      for (let i = 0; i < spaces; ++i) {
        process.stdout.write(TAB)
      }
      break
    default:
      process.stdout.write(c)
      break
  }
}

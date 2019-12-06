const { execSync } = require('child_process')

const str = execSync('pwd')
console.log(str.toString())

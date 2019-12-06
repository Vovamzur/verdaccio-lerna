const { readFileSync, writeFileSync} = require('fs')
const { resolve } = require('path')
const { execSync } = require('child_process')

const packagePath = execSync('pwd').toString()
const { version } = require(resolve(packagePath, 'package.json'))
const filePath = resolve(packagePath, './CHANGELOG.md')
const unreleasedLine = '## [Unreleased]'
const unreleasedSection = `${unreleasedLine}\n\n`
const fileLines = readFileSync(filePath, 'utf-8').split('\n')
let doGitAdd = false   
const newFileLines = fileLines.map((line, index) => {
    if (line === unreleasedLine && fileLines[index+1].startsWith('###')) {
        doGitAdd = true
        const currentDateInFormat = new Date().toISOString().slice(0, 10)
        const lineToReplace = `${unreleasedSection}## [${version}] - ${currentDateInFormat}`
        return lineToReplace
    }
    return line
})
writeFileSync(filePath, newFileLines.join('\n'))

if (doGitAdd) {
    execSync(`git add ${filePath}`)
}

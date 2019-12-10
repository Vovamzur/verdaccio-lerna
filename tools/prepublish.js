const { readFileSync, writeFileSync } = require('fs')

const filename = 'CHANGELOG.md'
const version = process.env.npm_package_version;
const unreleasedLine = '## [Unreleased]'
const unreleasedSection = `${unreleasedLine}\n\n`
const fileLines = readFileSync(filename).split('\n')
const newFileLines = fileLines.map((line, index) => {
    if (line === unreleasedLine && fileLines[index + 1] !== '') {
        const currentDateInFormat = new Date().toISOString().slice(0, 10)
        const lineToReplace = `${unreleasedSection}## [${version}] - ${currentDateInFormat}`
        return lineToReplace
    }
    return line
})
writeFileSync(filename, newFileLines.join('\n'))

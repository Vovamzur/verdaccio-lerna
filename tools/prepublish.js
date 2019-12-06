const { readFileSync, writeFileSync} = require('fs');
const { resolve } = require('path');

const packagePath = process.argv[2] || __dirname; 
const { version } = require(resolve(packagePath, 'package.json'));
const filePath = resolve(packagePath, './CHANGELOG.md');
const unreleasedLine = '## [Unreleased]'
const unreleasedSection = `${unreleasedLine}\n\n`;
const fileLines = readFileSync(filePath, 'utf-8').split('\n');
const newFileLines = fileLines.map((line, index) => {
    if (line === unreleasedLine && fileLines[index+1].startsWith('###')) {
        const currentDateInFormat = new Date().toISOString().slice(0, 10);
        const lineToReplace = `${unreleasedSection}## [${version}] - ${currentDateInFormat}`; 
        return lineToReplace;
    }
    return line
})
writeFileSync(filePath, newFileLines.join('\n'))

```
npm install --global verdaccio
npm set registry http://localhost:4873/
NPM_CONFIG_REGISTRY=http://localhost:4873 npm i
npm adduser --registry http://localhost:4873

verdaccio

mkdir package1
cd package1
npm init -y
chnage version in package.json
npm publish --registry http://localhost:4873

mkdir package2
cd package2
npm init -y
chnage version in package.json
npm publish --registry http://localhost:4873

cd ..
npx lerna init
npm publish --registry http://localhost:4873
```

add script to package.json
    "prepublishOnly": "npm version patch && echo 'test' >> file.txt"

create ./script.sh
chmod +x ./script.sh
    "prepublishOnly": "./script.sh && npm version patch && echo 'test' >> file.txt"

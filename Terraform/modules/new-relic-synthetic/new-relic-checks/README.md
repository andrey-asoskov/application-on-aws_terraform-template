# New Relic login check

## Local test

```commandline
npm install
export USER_PASSWORD='password'
node -c ./login-check.js
node ./login-check.js
```

## To generate Terraform Teplate file

```commandline
sed -e 's/ENV_TO_REPLACE/\$\{env2\}/g' ./login-check.js > ./login-check.js.tftpl
```

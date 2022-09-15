# Lambdas

## Install dependencies for aws_ips_update,aws_ips_update_CF

```commandline
cd python_packages
pip3 install --target . -r ../requirements.txt
```

## Test function locally

```commandline
python3 ./ipwl_update.py
```

## Test function on AWS

```commandline
aws lambda invoke --function-name app-ipwl_update_lambda \
--cli-binary-format raw-in-base64-out \
--invocation-type Event \
--payload file://payload.json response.json

aws lambda invoke --function-name app-aws_ips_update_lambda \
--cli-binary-format raw-in-base64-out \
--invocation-type Event \
--payload file://payload.json response.json

aws lambda invoke --function-name app-aws_ips_update_CF_lambda \
--cli-binary-format raw-in-base64-out \
--invocation-type Event \
--payload file://payload.json response.json
```

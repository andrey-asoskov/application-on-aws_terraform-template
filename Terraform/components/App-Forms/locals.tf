locals {
  wafv2_web_acl_alb = {
    "us-east-1" : data.terraform_remote_state.pre-envs.outputs.us-east-1_wafv2_web_acl_alb_us-east-1_arn
    "eu-west-2" : data.terraform_remote_state.pre-envs.outputs.eu-west-2_wafv2_web_acl_alb_eu-west-2_arn
  }
}

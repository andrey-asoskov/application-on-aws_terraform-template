module "pre-envs-global" {
  source = "../../modules/pre-envs-global"

  solution         = var.solution
  solution_short   = var.solution_short
  aws_account_type = var.aws_account_type
  aws_regions      = ["us-east-1", "eu-west-2"]
  providers = {
    aws = aws.useast1
  }
}

module "pre-envs-us-east-1" {
  source = "../../modules/pre-envs-region"

  solution                     = var.solution
  solution_short               = var.solution_short
  aws_account_type             = var.aws_account_type
  backup_role_arn              = module.pre-envs-global.backup_role_arn
  new_relic_api_key_ciphertext = lookup(var.new_relic_api_key_ciphertext, "${var.aws_account_type}_us-east-1")

  providers = {
    aws = aws.useast1
  }
}

module "pre-envs-eu-west-2" {
  source = "../../modules/pre-envs-region"

  solution                     = var.solution
  solution_short               = var.solution_short
  aws_account_type             = var.aws_account_type
  backup_role_arn              = module.pre-envs-global.backup_role_arn
  new_relic_api_key_ciphertext = lookup(var.new_relic_api_key_ciphertext, "${var.aws_account_type}_eu-west-2")

  providers = {
    aws = aws.euwest2
  }
}

module "pre-envs-eu-central-1" {
  source = "../../modules/pre-envs-region"

  solution                     = var.solution
  solution_short               = var.solution_short
  aws_account_type             = var.aws_account_type
  backup_role_arn              = module.pre-envs-global.backup_role_arn
  new_relic_api_key_ciphertext = lookup(var.new_relic_api_key_ciphertext, "${var.aws_account_type}_eu-central-1")

  providers = {
    aws = aws.eucentral1
  }
}

config {
  plugin_dir = "~/.tflint.d/plugins"

  module = true
  #force = false
  #disabled_by_default = false

#  ignore_module = {
#    "terraform-aws-modules/vpc/aws"            = true
#    "terraform-aws-modules/security-group/aws" = true
#  }

  #varfile = ["example1.tfvars", "example2.tfvars"]
  #variables = ["foo=bar", "bar=[\"baz\"]"]
}

plugin "aws" {
  enabled = true
  version = "0.13.3"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

#rule "aws_instance_invalid_type" {
#  enabled = false
#}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = false
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

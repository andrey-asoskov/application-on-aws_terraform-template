packer {
  required_plugins {
    amazon = {
      version = "1.0.9"
      source  = "github.com/hashicorp/amazon"
    }
  }
  required_version = ">= 1.7.0"
}

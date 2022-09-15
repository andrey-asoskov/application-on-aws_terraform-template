variable "access_key" {
  description = "AWS Access key"
  type        = string
}

variable "secret_key" {
  description = "AWS Secret key"
  type        = string
  sensitive   = true
}

variable "aws_account_type" {
  description = "Type of AWS account"
  type        = string
}

variable "solution" {
  description = "Name of a solution"
  type        = string
}

variable "solution_short" {
  description = "Short name of a solution"
  type        = string
}

variable "product_id" {
  description = "Product ID of a solution"
  type        = string
}

variable "new_relic_api_key_ciphertext" {
  description = "NR API key (Encrypted)"
  type        = map(string)
  default = {
    #"npn"  = "AQICAHgp3OsaPAj8cSKgiU4eU4DNjS51vWa8VWZ+3ZRO0psOWQEt+xOnbOP+wfHXzqdZswmTAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDHcFbyfBYjVAKi9fYgIBEIBDXs+hA2Hu4B2aLzEwlRn1HO8vj+p3yL+mspY/2Jdr/99R8fT/oB7/sgQeK1SXv49CX+l6LiafQMm0npQmzarpmJNCUQ=="
    "npn_us-east-1"     = "AQICAHj9hKxW+A6ZdZgo5sez+VGmQH5tykwB1lqJ8jgBNUAFdAE75EMDxFrzYxAROSp4xZzAAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDMgbi1oh8Lt5XUjAzwIBEIBDQPwmOsYBXi4h2HeGLYBA/uelEMMO/4SFCsFe310c4FfSJQugkfWw2UXhFfVnLFJLnf1/7RQ6mktLbn8AXwz/vrxRxg=="
    "npn_eu-west-2"     = "AQICAHhXURYd9bwGgzVJqbvmM2ATF3UIOTysALMOpKfbRQczFwGsVQqw7gzH80Zu2eVnlC+7AAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDHxy0owPYumu4DNcDgIBEIBDFDsYYqmwyKdqmIkcm0LYeMjF3G5whYweL4u3RFe9O0lAfzflWjSysIC2qJyEh9MlT0Np90ALnA4lJamVcRFR2znjKw=="
    "npn_eu-central-1"  = "AQICAHiKvpkgml9WDpCk0RXh+QvAJdkD8LFmVd6gwFaO5SF+XwFXzPyq1RZ7DJLJuLFNzO+PAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDLgSbNA1V3o85TnDcAIBEIBDe6hiQD+PT4bQUVX+wBV5PZkM/LNPghySdM7XquE12W7p2Z5L7LTAg++OEjFBIrTkT3lNCw1cWyy3nK2dxQZSn8k+jw=="
    "prod"              = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQHqqr4Q7zMw7kchGTYAb1Q/AAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDKxP0uuUCMiWFaYPkQIBEIBDWFYKfJA/G0yGhmAyJOv7Gb3qhy5dWRZC4dSFDah83rG89bGL7H3yKzMvJ4ST5+zdMEXKx2vQa5e1wXzt1iTp1X9orA=="
    "prod_us-east-1"    = "AQICAHil3Lwx1A9DQJDXqLSecqMfnJy04jIVIaBEWrg+/9oH7gF8xqD1iNmWEdZzACeVF18UAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDKokLBSPL9VfGC3sTwIBEIBDUUxjgiUdHqotRxln7mTRyrhI8PQlgsuOhXTwEz5hhmQr2ChWOQAVt2lIB/xZBBKPAWGC0PlHQK8kJT0/cuejCGAdBg=="
    "prod_eu-west-2"    = "AQICAHjf7oBbQjo9PEm/SmPbM49EzSOhu2Xc+0a+W27WlK01TgGj0ybDT7zSa/Af6OLA1uJXAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDPf7WKFCO2Is+QqcJAIBEIBD2Oyav4hnVCh853IaSKqDp7aM2j+ibXZ8QEeDoMQT6ZIOOZooZIy979IMjNi14mMYigD+veFt1U7MPqIvQuPnjUt/rQ=="
    "prod_eu-central-1" = "AQICAHgL0+LYSxiNtfUyiKOOqrk3/H4AhuZrOUkTOwdW1BlxugHLrgyhqXZsfVyTlo4r/H9pAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDOgQPAE2AGLEtxM4CQIBEIBDUuyXRo0qiYaa+0YjmZvtWJOC7DqeQJ0/D7I9wN/PCTkOURUOprEaPRv8qL3GBuASdOoJtjGfNKm4SaM4pBLLbggZqA=="
  }
}

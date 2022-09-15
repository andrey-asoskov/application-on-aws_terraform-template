variable "aws_region" {
  description = "AWS region to spin up the infra"
  type        = map(string)
  default = {
    "dev"     = "us-east-1"
    "staging" = "us-east-1"
    "prod"    = "us-east-1"
    "prod-uk" = "eu-west-2"
  }
}

variable "aws_account_type" {
  description = "Type of AWS account"
  type        = string
}

variable "env" {
  description = "Name of an environment"
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

variable "db_backup_retention_period" {
  description = "DB Backup retention period"
  type        = map(number)
  default = {
    "dev"     = 1
    "staging" = 1
    "prod"    = 35
    "prod-uk" = 35
  }
}

variable "db_enabled_cloudwatch_logs_exports" {
  description = "DB enabled cloudwatch logs exports"
  type        = list(any)
}

variable "db_instance_class" {
  description = "DB instance class"
  type        = string
}

variable "db_name" {
  description = "DB name"
  type        = string
}

variable "db_password_ciphertext" {
  description = "DB password (encrypted)"
  type        = map(string)
  default = {
    "dev"     = "AQICAHifpz0ldpjSWZ7GJaIxwasV8tScmhmrVPDEAYqXsuntcgGHoCVzDvr8amjw139QtBEzAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM04udVqE8uJa1tc2gAgEQgCuo1z9AHwijStpWjcLWyWioJUNbtnO5sBZBjhqUMYiSN3EaR1PN9NwXVVms"
    "staging" = "AQICAHjq9WNI6DeOzHIBWkvWEmZ664zXEep8XaIhTw8OLCw7oQHR3B5sNufTvtGyXm4MT6GfAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMnE4rW7U6EUcu30HIAgEQgCtwRIYvGDAlFIzvUZs8tSda6FMyxwBcXobMNThQ+L2T22vihKFg7xaHWY7R"
    "prod"    = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQFAIEXNcMMVqxomBOV+WUFFAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMsTXVk1E3Ba4/GVs4AgEQgCteqiOeOy8sBnGbgW+OedN44o3uY5Y0SN73JMf48izg7aHQKBSAePTp2FKo"
    "prod-uk" = "AQICAHjRRJgip2HtozZV0xVPRr9HRek0+FGOgkk68bCWjuR2VgEWhq+imnoYOkd/tm51LN3yAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMDmijFyukpAf6H27fAgEQgCukcxQ5y9IhpH1ABpq8H0GALIcDE2cGLUbAydUnI2lKZ1hpM3W5/IK9v20U"
  }
}

variable "db_shutoff" {
  description = "IF there is a need to shut DB off via automation"
  type        = map(string)
  default = {
    "dev"     = "false"
    "staging" = "false"
    "prod"    = "false"
    "prod-uk" = "false"
  }
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
}

variable "db_username" {
  description = "username for db connection used by the app"
  type        = string
}

/*variable "db_snapshot" {
  description = "DB snapshot to create the DB"
  type        = string
}*/

variable "db_deletion_protection" {
  description = "Should deletion protection be set"
  type        = map(bool)
  default = {
    "dev"     = false
    "staging" = false
    "prod"    = true
    "prod-uk" = true
  }
}

variable "db_engine_version" {
  description = "DB Engine version"
  type        = string
}

variable "sec_inventory_bucket" {
  description = "S3 Bucket for sending inventory to SOC"
  type        = string
}

variable "sec_inventory_prefix" {
  description = "S3 prefix for sending inventory to SOC"
  type        = string
}

variable "rds_insights_enabled" {
  type        = map(bool)
  description = "Use or not perf insights"
  default = {
    "dev"     = true
    "staging" = true
    "prod"    = true
    "prod-uk" = true
  }
}

variable "rds_insights_retention_period" {
  type        = map(number)
  description = "Perf Insights retention period"
  default = {
    "dev"     = 7
    "staging" = 7
    "prod"    = 731
    "prod-uk" = 731
  }
}

variable "hs_password_ciphertext" {
  description = "HS user password (encrypted base64)"
  type        = map(string)
  default = {
    "dev"     = "AQICAHifpz0ldpjSWZ7GJaIxwasV8tScmhmrVPDEAYqXsuntcgG5Bk3GImsk8Vs2X8BU2SKxAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMBhVXP0NaTJl6ElL4AgEQgCvv+g++jMJ0+6MfFQwU4X4SzpkL8LNtC1PExgMoQTRlokJGym1psGdW1qmY"
    "staging" = "AQICAHjq9WNI6DeOzHIBWkvWEmZ664zXEep8XaIhTw8OLCw7oQGCpb1HRfpv5OiUjcdJYUYoAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMvaaowiUgkzf6HXTSAgEQgCtaUF2ip9fRuXwzoj5d3vPndr4SHJIZAM1gAe8IuwRkoqPgQVpmMwRJWRVr"
    "prod"    = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQHAxmV9XIY1TdroHHOCXgb8AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMlqTL6hb0oJBUjRP/AgEQgCv4MarK4Ea6x1ZH8MSrODngtd3ikwfBv376EEg24JAzeZjrg+jhW7kITN2V"
    "prod-uk" = "AQICAHjRRJgip2HtozZV0xVPRr9HRek0+FGOgkk68bCWjuR2VgGqEqSSe+55nUuqQ6u9m3YSAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMER6Kb+7/Qrlepk9hAgEQgCu+sUdvf+0eR0pMPlQmkJ/aHjCATll1j1endkvK9zmNafAbXU+CeFgsmJai"
  }
}

variable "HS_OIDC_RP_CLIENT_SECRET_ciphertext" {
  description = "OIDC client secret (encrypted base64)"
  type        = map(string)
  default = {
    "dev"     = "AQICAHifpz0ldpjSWZ7GJaIxwasV8tScmhmrVPDEAYqXsuntcgGWqX7DyD49BxoWDeM8ziVbAAAAgzCBgAYJKoZIhvcNAQcGoHMwcQIBADBsBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDIXeVKEtQdIq4mnOugIBEIA/p/T/ZKZLG8NvJec/mNfo78pavjmoU8xl8BqN6Vnd6PCoFFZftIiZgmu4b1hqPYAMX0OEQW57DtvoLvEnlETC"
    "staging" = "AQICAHjq9WNI6DeOzHIBWkvWEmZ664zXEep8XaIhTw8OLCw7oQFty4425Dz+W6CgFBE16o0gAAAAgzCBgAYJKoZIhvcNAQcGoHMwcQIBADBsBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDOS8Ee9lvXJoPzVSdQIBEIA/fFpCTudUjvlWVR2kl1cfDZa4K2R1RpqTU2EeFgeBZQhu87O6nkchFQSDHok3tyk3C9H5KwbIKCCgO6k039+V"
    "prod"    = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQE0st7zAQ2Glt8yQR8VHECyAAAAgzCBgAYJKoZIhvcNAQcGoHMwcQIBADBsBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDCtuU3I03IDL+f9T9QIBEIA/XlRwjfrjcqToQoz9+3kIbmkTGXT0S797+86GvTVxBOG2EY0C/4acO2BZn8Bpzntr6PJ5uDUK8aU4TTRYjs9P"
    "prod-uk" = "AQICAHjRRJgip2HtozZV0xVPRr9HRek0+FGOgkk68bCWjuR2VgGFAYjmmUNCRafvPMDM9BeYAAAAgzCBgAYJKoZIhvcNAQcGoHMwcQIBADBsBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDIaRCo4k0Vd8xyDWBAIBEIA/0nINJEddcEaRdT3XRjpzRi+Hmb1gl3wnh+7/JFUU3mfCDmFKTckpjPRDXggQQxT+mnpbSziHv8yjfZ39Vjwm"
  }
}

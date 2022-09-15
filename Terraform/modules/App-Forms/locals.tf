locals {
  user_data_file = {
    dev     = "${path.module}/templates/user_data_mcid.sh.tftpl"
    staging = "${path.module}/templates/user_data_mcid.sh.tftpl"
    prod    = "${path.module}/templates/user_data_mcid.sh.tftpl"
    prod-uk = "${path.module}/templates/user_data_mcid.sh.tftpl"
  }

  userdata = templatefile(lookup(local.user_data_file, var.env), {
    FILE_STORE_S3_BUCKET              = var.s3_storage_bucket_id
    FILE_STORE_S3_REGION              = data.aws_region.current.name
    SECRET_MANAGER_NAME               = var.secretmanager_name
    FORMS_DB_HOST                     = var.db_address_r53_dns_name
    FORMS_DB_NAME                     = var.db_name
    FORMS_DB_PORT                     = "5432"
    FORMS_DB_TYPE                     = "postgres"
    FORMS_DB_USER                     = var.db_username
    FORMS_STORAGE_MODE                = "S3"
    FORMS_USER                        = "hsuser"
    HS_OIDC_ADMIN_GROUP               = var.HS_OIDC_ADMIN_GROUP
    HS_OIDC_LOGGER_LEVEL              = var.HS_OIDC_LOGGER_LEVEL
    HS_OIDC_RP_CLIENT_ID              = var.HS_OIDC_RP_CLIENT_ID
    HS_OIDC_OP_AUTHORIZATION_ENDPOINT = (var.env_type == "prod" ? "https://auth.company.id/auth/realms/r/protocol/openid-connect/auth" : "https://auth.int.company.id/auth/realms/r/protocol/openid-connect/auth")
    HS_OIDC_OP_TOKEN_ENDPOINT         = (var.env_type == "prod" ? "https://auth.company.id/auth/realms/r/protocol/openid-connect/token" : "https://auth.int.company.id/auth/realms/r/protocol/openid-connect/token")
    HS_OIDC_OP_USER_ENDPOINT          = (var.env_type == "prod" ? "https://auth.company.id/auth/realms/r/protocol/openid-connect/userinfo" : "https://auth.int.company.id/auth/realms/r/protocol/openid-connect/userinfo")
    HS_OIDC_OP_JWKS_ENDPOINT          = (var.env_type == "prod" ? "https://auth.company.id/auth/realms/r/protocol/openid-connect/certs" : "https://auth.int.company.id/auth/realms/r/protocol/openid-connect/certs")
    HS_PATH                           = "/mnt/hs"
    NESSUS_KEY_CIPHERTEXT             = var.nessus_key_ciphertext
    NEWRELIC_KEY_CIPHERTEXT           = var.newrelic_key_ciphertext
    REGION                            = data.aws_region.current.name
    splunk_lb                         = var.splunk_lb
    splunk_lb_port                    = var.splunk_lb_port
    }
  )
}

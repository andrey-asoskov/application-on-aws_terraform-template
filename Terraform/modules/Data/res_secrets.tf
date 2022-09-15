data "aws_kms_secrets" "secrets" {
  secret {
    name    = "FORMS_DB_PASS"
    payload = var.db_password_ciphertext
  }
  secret {
    name    = "FORMS_PASS"
    payload = var.hs_password_ciphertext
  }
  secret {
    name    = "HS_OIDC_RP_CLIENT_SECRET"
    payload = var.HS_OIDC_RP_CLIENT_SECRET_ciphertext
  }
}

resource "aws_secretsmanager_secret" "secret" {
  name        = "${var.solution_short}-${var.env}"
  description = "Secret Manager for ${var.solution_short} - ${var.env}"
  kms_key_id  = var.kms_alias_arn

  tags = {
    Name = "${var.solution_short}-${var.env}"
  }
}

resource "aws_secretsmanager_secret_version" "secret-version" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(
    {
      FORMS_DB_PASS            = data.aws_kms_secrets.secrets.plaintext["FORMS_DB_PASS"]
      FORMS_PASS               = data.aws_kms_secrets.secrets.plaintext["FORMS_PASS"]
      HS_OIDC_RP_CLIENT_SECRET = data.aws_kms_secrets.secrets.plaintext["HS_OIDC_RP_CLIENT_SECRET"] // guardrails-disable-line
      HS_LOGIN_ENABLE_OPENID   = "True"
    }
  )
}

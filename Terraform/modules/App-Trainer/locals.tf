locals {
  userdata = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    HS_PATH                    = "/mnt/hs"
    NESSUS_KEY_CIPHERTEXT      = var.nessus_key_ciphertext
    NEWRELIC_KEY_CIPHERTEXT    = var.newrelic_key_ciphertext
    splunk_lb                  = var.splunk_lb
    splunk_lb_port             = var.splunk_lb_port
    APP_FORMS_URL              = var.app-int-alb_r53_url
    APP_FORMS_TOKEN_CIPHERTEXT = var.app_forms_token_ciphertext
    REGION                     = data.aws_region.current.name
    }
  )
}

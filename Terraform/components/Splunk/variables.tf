variable "aws_region" {
  description = "AWS region to launch servers."
  type        = string
}


variable "env" {
  description = "Name of an environment"
  type        = string
}

variable "env_type" {
  description = "Type of an environment"
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

variable "asg_splunk_instance_type" {
  description = "Desired instance type for ASG"
  type        = string
}

variable "asg_splunk_DesiredSize" {
  description = "Desired size for ASG"
  type        = number
}

variable "asg_splunk_ImageID" {
  description = "Image ID for the Splunk`"
  type        = map(string)
  default = {
    "dev"     = "ami-022b6b75fa216594b" #~26.07.2021
    "staging" = "ami-022b6b75fa216594b"
    "prod"    = "ami-071039ccbb3338859" #~26.07.2021
  }
}

variable "asg_splunk_MaxSize" {
  description = "Max size for ASG"
  type        = number
}

variable "asg_splunk_MinSize" {
  description = "Min size for ASG"
  type        = number
}

variable "asg_splunk_shutoff" {
  description = "IF there is a need to shut EC2 off via automation"
  type        = map(string)
  default = {
    "dev"     = "true"
    "staging" = "false"
    "prod"    = "false"
  }
}

variable "nessus_key_ciphertext" {
  description = "Nessus key (encrypted)"
  type        = map(string)
  default = {
    "dev"     = "AQICAHifpz0ldpjSWZ7GJaIxwasV8tScmhmrVPDEAYqXsuntcgGvOkgsaH7+PSCuQGcuuZwHAAAAjzCBjAYJKoZIhvcNAQcGoH8wfQIBADB4BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDJZ8EZBlCqMFOOQKMgIBEIBLS5Rlc8H4vBO6LE0MxNki95dZEXQApqJqVbskUzweRjwIMs2C7pbZfoZKVZjqYIjk+xh6IKkd8hY8xVE3/PZyTVVZnk9OWIRhnIt7"
    "staging" = "AQICAHjq9WNI6DeOzHIBWkvWEmZ664zXEep8XaIhTw8OLCw7oQG/ABdLOTlS8A/oLojbNADKAAAAjzCBjAYJKoZIhvcNAQcGoH8wfQIBADB4BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDNTnqWoUikQbLaZJ0wIBEIBLqhYowbaB4oUe0TcbnbjHzOzeUE/d6v9V3otoyLRToYPJVKECXiJeb/fVg61olF2S32D0Eg093finBWHgNXnNgtdUVY5PBveHUnAo"
    "prod"    = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQEz36iA+zShcmFGhOT+lop/AAAAjzCBjAYJKoZIhvcNAQcGoH8wfQIBADB4BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDB94LTLsKa7YhweG+gIBEIBL0iaBjwQVxwvgtZuLVl+el9ho5lHtEiTI5snKFkVhkeR5PY7J2TOeY7LNW8+8WUREONpA3Nvs9gBzj0sCxuaRvo9kyzWWA7yu9KT3"
  }
}

variable "newrelic_key_ciphertext" {
  description = "New Relic (encrypted)"
  type        = map(string)
  default = {
    "dev"     = "AQICAHifpz0ldpjSWZ7GJaIxwasV8tScmhmrVPDEAYqXsuntcgHp0I6wXi/UrtQ63N8nMEDQAAAAfDB6BgkqhkiG9w0BBwagbTBrAgEAMGYGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMLBWBs/WSYik6/G9SAgEQgDlnuCfAYMhwKUWSvYhuMTohl/oJ0sg6UVOodPD9/BN9MZmqooZfPFPqDtjnbrJKE+ridqCTr6kb3Pw="
    "staging" = "AQICAHjq9WNI6DeOzHIBWkvWEmZ664zXEep8XaIhTw8OLCw7oQHTDSttbIChVFY8G85nfrRrAAAAfDB6BgkqhkiG9w0BBwagbTBrAgEAMGYGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMAwOnqkGcL08asjX0AgEQgDlqs9vno/zcrDflzqhy9JXcOLsJTsTuhMaOgILm8uc/3CBA2J4DWF11V6zHHenPXSvW6SRKoA9JGjU="
    "prod"    = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQE6PiJTMqG5GlBE3ojPuxtjAAAAfDB6BgkqhkiG9w0BBwagbTBrAgEAMGYGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMEON4oR/zy6T1zakmAgEQgDkOhNM54zJaJIbnHRdLNAbAEkM1bcrFhJbdjadd1qznP4R/9PsLqiCCBD22a5JhPc/L4opFHOIkx/k="
  }
}

variable "splunk_index_name" {
  description = "Splunk index name"
  type        = map(string)
  default = {
    "dev"     = "ctdev_red_0"
    "staging" = "ctstg_red_0"
    "prod"    = "ctprod_red_0"
  }
}

/*variable "splunk_admin_password_ciphertext" {
  description = "NSplunk Admin PW (encrypted)"
  type        = map(string)
  default = {
    "dev"      = ""
    "staging"  = ""
    "prod"     = ""
  }
}*/

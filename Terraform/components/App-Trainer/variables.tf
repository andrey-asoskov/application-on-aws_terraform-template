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

variable "asg_app_trainer_instance_types" {
  description = "Desired instance types for ASG"
  type        = list(string)
  default     = ["m5.4xlarge"]
}

variable "asg_app_trainer_Image_Owner" {
  description = "Account Owner for Forms Image"
  type        = map(string)
  default = {
    "dev"     = "925851635913"
    "staging" = "925851635913"
    "prod"    = "925851635913"
    "prod-uk" = "552667997578"
  }
}

variable "asg_app_trainer_ImageName" {
  description = "Image Name for the Trainer"
  type        = map(string)
  default = {
    "dev"     = "app-trainer-32.0.20-2022-07-07T15:13:29.767Z"
    "staging" = "app-trainer-32.0.20-2022-07-07T15:13:29.767Z"
    "prod"    = "app-trainer-32.0.20-2022-07-07T15:13:29.767Z"
    "prod-uk" = "app-trainer-32.0.20-2022-07-07T15:13:29.767Z"
  }
}

variable "asg_app_trainer_MinSize" {
  description = "Min size for ASG"
  type        = map(number)
  default = {
    "dev"     = 1
    "staging" = 2
    "prod"    = 2
    "prod-uk" = 2
  }
}

variable "asg_app_trainer_MaxSize" {
  description = "Max size for ASG"
  type        = map(number)
  default = {
    "dev"     = 1
    "staging" = 5
    "prod"    = 5
    "prod-uk" = 5
  }
}

variable "asg_app_trainer_DesiredSize" {
  description = "Desired size for ASG"
  type        = map(number)
  default = {
    "dev"     = 1
    "staging" = 2
    "prod"    = 2
    "prod-uk" = 2
  }
}

variable "asg_app_trainer_shutoff" {
  description = "IF there is a need to shut EC2 off via automation"
  type        = map(string)
  default = {
    "dev"     = "false"
    "staging" = "false"
    "prod"    = "false"
    "prod-uk" = "false"
  }
}

variable "asg_app_trainer_backup" {
  description = "IF there is a need to backup EC2 via automation"
  type        = map(string)
  default = {
    "dev"     = "false"
    "staging" = "false"
    "prod"    = "false"
    "prod-uk" = "false"
  }
}

variable "app_forms_token_ciphertext" {
  description = "App Forms Token (encrypted base64)"
  type        = map(string)
  default = {
    "dev"     = "AQICAHifpz0ldpjSWZ7GJaIxwasV8tScmhmrVPDEAYqXsuntcgE4EV6MajmVDn1zz/+F2JlHAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDLeGpKSGrmLGwA4aNQIBEIBDeeLMp9y2dFZGQDH1PLiznEK3mZi1pt2bLXq7ukzGRWpIq0j9J0GYlzpxd9Q0donIZvUGI1iQw7cMdhPNjIbk9LEW0Q=="
    "staging" = "AQICAHjq9WNI6DeOzHIBWkvWEmZ664zXEep8XaIhTw8OLCw7oQHZFv2obiZVTCFnvsfLWosFAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDKJxR2TOdAW6zJzcqAIBEIBD9qcfMTTW22oKHJAE19FT41doP01BXQDrzQU032wJ1xKR/LEd+xg3kG4+FE5mzzwLDdv/qMJ1kSLOt7u+fLZ1ADRkag=="
    "prod"    = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQHqIhgV+10yB36Z/n9Wk3b9AAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDN1Qpa0mz54hHjfC5gIBEIBDpUMwdWGXydrpYLsTUbeAIT8PcKOWR/VZuqGaJ0MRRzwOvp2rAsbAO2DxamIdHO8qOpPQ9VGdRDUIXBOggONjpCdeig=="
    "prod-uk" = "AQICAHjRRJgip2HtozZV0xVPRr9HRek0+FGOgkk68bCWjuR2VgEAgqzQUoEB55eoZVqnXlNIAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDHymhdCqrPiAF0m70AIBEIBDLuymA289D2KwHi8X7GCuUMDZhkt+urd3gfO2grBLwJ9dtFHWkZwMAJkFx1QP9t4t+qQ/M4vQntdVjd4aWFPHkcnZUA=="
  }
}

variable "nessus_key_ciphertext" {
  description = "Nessus key (encrypted base64)"
  type        = map(string)
  default = {
    "dev"     = "AQICAHifpz0ldpjSWZ7GJaIxwasV8tScmhmrVPDEAYqXsuntcgEsR1J0XAajwxUR1WCYwe0JAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDNCX97U+BL9wcGyDHQIBEIBbKa/iYBTYXhyXfxSVX4V++rcxk78lPiF5AffLsgBptIP9yvdctAEp2HP2xGZWlzYvnT2G6Q1F7ejPXH+WN+s/NGfxj4aGHGWGr38NyEaWW+0LAVvaGVXKV2nuAQ=="
    "staging" = "AQICAHjq9WNI6DeOzHIBWkvWEmZ664zXEep8XaIhTw8OLCw7oQGLeAah/FYmcusVIqMmwQUXAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDCa/zZo9gJEhPjKc6gIBEIBbDfnIAJ/tV8PiaeBmSBL1Q/T9TI6QiBsHb3MgjsrK6EEuXmQNM5nwJ68OmVg5y/qpaNOWwFDw6NQsOYbuzHR3lFN0k+K01iCxCVu2szPGIHDT0Gz1WIn+ii4avw=="
    "prod"    = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQE/ViR5lJSLMzpj2PLzOSduAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDO6m1OeOzB2/eNK+6QIBEIBbZXbDpYkgtqZZosPC3/hQ8Zt1xR5ddlzAZ0Mh24xxZwynZJ5zSVmaCA4zyyG3ItFpTct4vHSUTWi2bUt1N1CDkOLKTqo0NB/16maJfYW+jrjjIZLkmC4pXPhH8w=="
    "prod-uk" = "AQICAHjRRJgip2HtozZV0xVPRr9HRek0+FGOgkk68bCWjuR2VgGgQxQVkPQSRRhaL7qcomSOAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDMgyZKR0DVI2zhGDQAIBEIBbotV035cSn/bN6jA32kgivAn3dlBOqqM3qzHkewnLpoa+D7c05H8pVpHWV6L69uz+AWEJU5W6k7sGfHhrven/hh0mZ2W/aNVBKhs+H21a59H7OMONacPz1kQQjA=="
  }
}

variable "newrelic_key_ciphertext" {
  description = "New Relic (encrypted base64)"
  type        = map(string)
  default = {
    "dev"     = "AQICAHifpz0ldpjSWZ7GJaIxwasV8tScmhmrVPDEAYqXsuntcgFyLq3c18I2FEe/JL/beZOEAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDMxdliBXQjehf47x4wIBEIBDpSjYNflwVF6cGI9S18BEyHH3Hcrt0B48nZ/Joby9aNOjpbK5vNJKgJABMpatmVmQVdpowQJrCitntPrOGRIYtb3BRA=="
    "staging" = "AQICAHjq9WNI6DeOzHIBWkvWEmZ664zXEep8XaIhTw8OLCw7oQHdpQkHTP31GzQ+pZitmybRAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDOh5QbeIQahzcdDT+QIBEIBDA+XMu4gYbKFNz8i53pXwJ0KuD2+0eT2vPycvow5822x/zgUuUD2VdeHGQZhPcVcJ5LbKoa3t6pHoVP4op6lK4Z7Z/Q=="
    "prod"    = "AQICAHhgdTTP+ax2LV0K7Joegz8iXESpmqRIeWAwNNSCxyWpWQFOQdXFj6jUAWE8f7+kmyUOAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDBeJV9ijtWzxsBbnfwIBEIBDmqODuNeXN8sL0ayXpd3rq5nNp6ZB2+247VpdNySk7khUR2Ke+OEuIr5Am+ePEkthW/6qCqXYJbyWy2pBh8bNZNpbTg=="
    "prod-uk" = "AQICAHjRRJgip2HtozZV0xVPRr9HRek0+FGOgkk68bCWjuR2VgHTpeT6IjZcKcij0Be0lVIzAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDAEropy+Ia6QUUQQoQIBEIBDgWUPHQxcEVYUUY3zFsk2QSRQs08AD7dhou+m1dFFZh7iFkCKdikhupXbC6V6gR2bQnLO8uTg8mYu7rHh2Gzd03C4fg=="
  }
}

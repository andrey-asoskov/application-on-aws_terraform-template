terraform {
  required_version = "~> 1.1"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.45"
    }
  }
}

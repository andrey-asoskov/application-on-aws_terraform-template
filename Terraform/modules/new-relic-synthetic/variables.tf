variable "solution" {
  description = "Name of a solution"
  type        = string
}

variable "solution_short" {
  description = "Short name of a solution"
  type        = string
}

variable "env" {
  description = "Name of an environment"
  type        = string
}

variable "uri" {
  description = "URI to check"
  type        = string
}

variable "locations" {
  description = "List of locations"
  type        = list(string)
}

variable "newrelic_alert_policy_id" {
  description = "New Relic Alert policy IF"
  type        = string
}

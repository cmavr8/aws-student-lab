# Setup billing and budgeting alerts

variable "notifemail" {
 type = string
 description = "Email address to send billing notifications to."
}
variable "budget" {
 type = number
 description = "The amount of money that we plan to spend per month, in US Dollars"
}

# Billing alert for when the forecast is over the budget
resource "aws_budgets_budget" "predictive" {
  name              = "budget-predictive-alerting"
  budget_type       = "COST"
  limit_amount      = tonumber(var.budget)
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2010-07-01_00:00"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 5
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.notifemail]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.notifemail]
  }
}

# Billing alerts based on actual charges
resource "aws_budgets_budget" "actual" {
  name              = "budget-actual-cost-alerting"
  budget_type       = "COST"
  limit_amount      = var.budget
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2010-07-01_00:00"

  # Alert at a few key percentages of budget: 10, 25, 50, 75 and 100%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 10
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notifemail]
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 25
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notifemail]
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notifemail]
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 75
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notifemail]
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notifemail]
  }
}
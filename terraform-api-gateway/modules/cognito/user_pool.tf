resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

}
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                = var.user_pool_client_name
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  supported_identity_providers = [
    "COGNITO",
  ]
  callback_urls                        = var.identity_provider_callback_urls
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = [
    "email",
    "openid",
  ]
}
variable "identity_provider_callback_urls" {
  type        = list(any)
  description = "List of allowed callback URLs for the identity providers"
  default     = ["http://localhost:8000/logged_in.html"]
}
resource "aws_cognito_user_pool_domain" "main" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  domain       = "mycogndomain"
}



  # explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
# }






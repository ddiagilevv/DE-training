terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
    }
  }
}

provider "snowflake" {
  username = "your_username"
  password = "your_password"
  role     = "ACCOUNTADMIN"
  region   = "your_region"
  account  = "your_account"
}

resource "snowflake_role" "example_role" {
  name = "example_role"
}

resource "snowflake_user" "example_user" {
  name     = "example_user"
  password = "a_strong_password"
  default_role = snowflake_role.example_role.name
  must_change_password = false
}

resource "snowflake_warehouse" "example_warehouse" {
  name           = "example_warehouse"
  warehouse_size = "X-SMALL"
  auto_suspend   = 120
  auto_resume    = true
  initially_suspended = true
}



resource "snowflake_stage" "example_stage" {
  name          = "example_stage"
  database      = "your_database"
  schema        = "your_schema"
  url           = "s3://your_s3_bucket/path"
  storage_integration = snowflake_storage_integration.example_integration.name
}

resource "snowflake_storage_integration" "example_integration" {
  name               = "example_integration"
  storage_provider   = "S3"
  storage_aws_role_arn = "arn:aws:iam::123456789012:role/your_snowflake_role"
  enabled            = true
}

resource "snowflake_pipe" "example_pipe" {
  name          = "example_pipe"
  database      = "your_database"
  schema        = "your_schema"
  statement     = "COPY INTO your_database.your_schema.your_table FROM @your_database.your_schema.example_stage"
  auto_ingest   = true
  comment       = "An example Snowpipe loading data from S3"
}

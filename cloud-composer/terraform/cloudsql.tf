module "sql-db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mssql"
  version = "11.0.0"

  # instance settings
  name   = "mssql-instance-01"
  region = var.region

  # db settings
  db_name   = "my-database"
  user_name = "user1"

  deletion_protection = false # not recommended for PROD
}

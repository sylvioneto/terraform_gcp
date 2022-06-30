output "db_initial_password" {
  value     = random_password.db_initial_password.result
  sensitive = true
}

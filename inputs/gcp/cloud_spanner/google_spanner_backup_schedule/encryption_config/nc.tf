resource "google_spanner_backup_schedule" "nc1" {
  name               = "nc1"
  instance           = "example-instance"
  database           = "example-database"
  retention_duration = "172800s"
  spec {
    cron_spec {
      text = "0 12 * * *"
    }
  }
  full_backup_spec {}
  encryption_config {
    encryption_type = "GOOGLE_DEFAULT_ENCRYPTION"
  }
}

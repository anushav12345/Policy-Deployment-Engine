resource "google_spanner_backup_schedule" "c1" {
  name               = "c1"
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
    encryption_type = "CUSTOMER_MANAGED_ENCRYPTION"
    kms_key_name    = "projects/fake-project/locations/us-central1/keyRings/fake-ring/cryptoKeys/fake-key"
  }
}

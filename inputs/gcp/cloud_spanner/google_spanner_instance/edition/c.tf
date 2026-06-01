resource "google_spanner_instance" "c" {
  name                         = "c1"
  config                       = "regional-australia-southeast1"
  display_name                 = "compliant-instance"
  num_nodes                    = 1
  edition                      = "ENTERPRISE"
  force_destroy                = false
  default_backup_schedule_type = "AUTOMATIC"
}

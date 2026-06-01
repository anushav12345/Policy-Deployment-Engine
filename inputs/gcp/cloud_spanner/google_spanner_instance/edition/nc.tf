resource "google_spanner_instance" "nc" {
  name                         = "nc1"
  config                       = "regional-australia-southeast1"
  display_name                 = "non-compliant-instance"
  num_nodes                    = 1
  edition                      = "EDITION_UNSPECIFIED"
  force_destroy                = false
  default_backup_schedule_type = "AUTOMATIC"
}

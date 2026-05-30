resource "google_spanner_instance" "c1" {
  name          = "c1"
  config        = "regional-us-central1"
  display_name  = "compliant-instance"
  num_nodes     = 1
  force_destroy = false
}

resource "google_spanner_instance" "nc1" {
  name          = "nc1"
  config        = "regional-us-central1"
  display_name  = "noncompliant-instance"
  num_nodes     = 1
  force_destroy = true
}

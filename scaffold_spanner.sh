#!/usr/bin/env bash
set -euo pipefail
[[ -d "policies/gcp/cloud_spanner/google_spanner_database" ]] || { echo "run from repo root on gcp/service/cloud_spanner"; exit 1; }
POL="policies/gcp/cloud_spanner"; INP="inputs/gcp/cloud_spanner"
CFG='terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.11.0"
    }
  }
}

provider "google" {
  project = "fake-project"
  region  = "us-central1"
}'
cfg() { mkdir -p "$1"; printf '%s\n' "$CFG" > "$1/config.tf"; }

mkdir -p "$POL/google_spanner_instance"
cat > "$POL/google_spanner_instance/vars.rego" <<'EOF'
package terraform.gcp.security.cloud_spanner.google_spanner_instance.vars

variables := {
    "friendly_resource_name": "Cloud Spanner Instance",
    "resource_type": "google_spanner_instance",
    "resource_value_name": "name"
}
EOF

mkdir -p "$POL/google_spanner_instance/force_destroy"
cat > "$POL/google_spanner_instance/force_destroy/policy.r#!/usr/bin/env bash
set -euo pipefail
[[ -d "policies/gcp/cloud_spanner/_instance.force_destroy
import data.terraform.helpers
import data.terraform.gcp.security.cloud_spanner.google_spanner_instance.vars

conditions := [
    [
        {"situation_description": "Spanner instance permits forced destruction, risking accidental data loss",
         "remedies": ["Set force_destroy to false"]},
        {"condition": "Check force_destroy is disabled", "attribute_path": ["force_destroy"], "values": [false], "policy_type": "whitelist"}
    ]
]

message := helpers.get_multi_summary(conditions, vars.variables).message
details := helpers.get_multi_summary(conditions, vars.variables).details
EOF
cfg "$INP/google_spanner_instance/force_destroy"
cat > "$INP/google_spanner_instance/force_destroy/c.tf" <<'EOF'
resource "google_spanner_instance" "c1" {
  name          = "c1"
  config        = "regional-us-central1"
  display_name  = "compliant-instance"
  num_nodes     = 1
  force_destroy = false
}
EOF
cat > "$INP/google_spanner_instance/force_destroy/nc.tf" <<'EOF'
resource "google_spanner_instance" "nc1" {
  name          = "nc1"
  config        = "regional-us-central1"
  display_name  = "noncompliant-instance"
  num_nodes     = 1
  force_destroy = true
}
EOF

mkdir -p "$POL/google_spanner_instance/default_backup_schedule_type"
cat > "$POL/google_spanner_instance/default_backup_schedule_type/policy.rego" <<'EOF'
package terraform.gcp.security.cloud_spanner.google_spanner_instance.default_backup_schedule_type
import data.terraform.helpers
import data.terraform.gcp.security.cloud_spanner.google_spanner_instance.vars

conditions := [
    [
        {"situation_description": "Spanner instance does not enforce automatic backups",
         "remedies": ["Set default_backup_schedule_type to AUTOMATIC"]},
        {"condition": "Check default_backup_schedule_type is AUTOMATIC", "attribute_path": ["default_backup_schedule_type"], "values": ["AUTOMATIC"], "policy_type": "whitelist"}
    ]
]

message := helpers.get_multi_summary(conditions, vars.variables).message
details := helpers.get_multi_summary(conditions, vars.variables).details
EOF
cfg "$INP/google_spanner_instance/default_backup_schedule_type"
cat > "$INP/google_spanner_instance/default_backup_schedule_type/c.tf" <<'EOF'
resource "google_spanner_instance" "c1" {
  name                         = "c1"
  config                       = "regional-us-central1"
  display_name                 = "compliant-instance"
  num_nodes                    = 1
  default_backup_schedule_type = "AUTOMATIC"
}
EOF
cat > "$INP/google_spanner_instance/default_backup_schedule_type/nc.tf" <<'EOF'
resource "google_spanner_instance" "nc1" {
  name                         = "nc1"
  config                       = "regional-us-central1"
  display_name                 = "noncompliant-instance"
  num_nodes                    = 1
  default_backup_schedule_type = "NONE"
}
EOF

mkdir -p "$POL/google_spanner_instance/data_residency"
cat > "$POL/google_spanner_instance/data_residency/policy.rego" <<'EOF'
package terraform.gcp.security.cloud_spanner.google_spanner_instance.data_residency
import data.terraform.helpers
import data.terraform.gcp.security.cloud_spanner.google_spanner_instance.vars

conditions := [
    [
        {"situation_description": "Spanner instance is provisioned outside approved data-residency regions",
         "remedies": ["Set config to an approved regional configuration"]},
        {"condition": "Check instance config is within approved regions", "attribute_path": ["config"], "values": ["regional-australia-southeast1", "regional-australia-southeast2"], "policy_type": "whitelist"}
    ]
]

message := helpers.get_multi_summary(conditions, vars.variables).message
details := helpers.get_multi_summary(conditions, vars.variables).details
EOF
cfg "$INP/google_spanner_instance/data_residency"
cat > "$INP/google_spanner_instance/data_residency/c.tf" <<'EOF'
resource "google_spanner_instance" "c1" {
  name         = "c1"
  config       = "regional-australia-southeast1"
  display_name = "compliant-instance"
  num_nodes    = 1
}
EOF
cat > "$INP/google_spanner_instance/data_residency/nc.tf" <<'EOF'
resource "google_spanner_instance" "nc1" {
  name         = "nc1"
  config       = "regional-us-central1"
  display_name = "noncompliant-instance"
  num_nodes    = 1
}
EOF

mkdir -p "$POL/google_spanner_backup_schedule"
cat > "$POL/google_spanner_backup_schedule/vars.rego" <<'EOF'
package terraform.gcp.security.cloud_spanner.google_spanner_backup_schedule.vars

variables := {
    "friendly_resource_name": "Cloud Spanner Backup Schedule",
    "resource_type": "google_spanner_backup_schedule",
    "resource_value_name": "name"
}
EOF
mkdir -p "$POL/google_spanner_backup_schedule/encryption_config"
cat > "$POL/google_spanner_backup_schedule/encryption_config/policy.rego" <<'EOF'
package terraform.gcp.security.cloud_spanner.google_spanner_backup_schedule.encryption_config
import data.terraform.helpers
import data.terraform.gcp.security.cloud_spanner.google_spanner_backup_schedule.vars

conditions := [
    [
        {"situation_description": "Spanner backup schedule does not use customer-managed encryption",
         "remedies": ["Set encryption_config.encryption_type to CUSTOMER_MANAGED_ENCRYPTION with a kms_key_name"]},
        {"condition": "Check backup encryption uses CMEK", "attribute_path": ["encryption_config", "encryption_type"], "values": ["CUSTOMER_MANAGED_ENCRYPTION"], "policy_type": "whitelist"}
    ]
]

message := helpers.get_multi_summary(conditions, vars.variables).message
details := helpers.get_multi_summary(conditions, vars.variables).details
EOF
cfg "$INP/google_spanner_backup_schedule/encryption_config"
cat > "$INP/google_spanner_backup_schedule/encryption_config/c.tf" <<'EOF'
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
EOF
cat > "$INP/google_spanner_backup_schedule/encryption_config/nc.tf" <<'EOF'
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
EOF
echo "Done. Files created:"
find "$POL/google_spanner_instance" "$POL/google_spanner_backup_schedule" "$INP/google_spanner_instance" "$INP/google_spanner_backup_schedule" -type f | sort

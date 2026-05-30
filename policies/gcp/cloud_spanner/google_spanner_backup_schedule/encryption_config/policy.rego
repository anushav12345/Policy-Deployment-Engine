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

package terraform.gcp.security.cloud_spanner.google_spanner_backup_schedule.kms_key_name
import data.terraform.helpers
import data.terraform.gcp.security.cloud_spanner.google_spanner_backup_schedule.vars

conditions := [
    [
        {"situation_description": "Cloud Spanner backup schedule does not specify a customer-managed KMS key, meaning backups are not protected with CMEK.",
         "remedies": ["Set encryption_config.kms_key_name to a valid Cloud KMS key resource path."]},
        {
            "condition": "Check kms_key_name is set",
            "attribute_path": ["encryption_config", "kms_key_name"],
            "values": [null],
            "policy_type": "blacklist"
        }
    ]
]

result := helpers.get_multi_summary(conditions, vars.variables)
message := result.message
details := result.details

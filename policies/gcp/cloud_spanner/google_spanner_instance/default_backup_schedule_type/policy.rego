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

result := helpers.get_multi_summary(conditions, vars.variables)
message := result.message
details := result.details

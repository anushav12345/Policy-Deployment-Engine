package terraform.gcp.security.cloud_spanner.google_spanner_backup_schedule.retention_duration
import data.terraform.helpers
import data.terraform.gcp.security.cloud_spanner.google_spanner_backup_schedule.vars

conditions := [
    [
        {"situation_description": "Cloud Spanner backup schedule has an insufficient retention duration, risking data loss if recovery is needed beyond the retention window.",
         "remedies": ["Set retention_duration to at least 604800s (7 days)."]},
        {
            "condition": "Check retention_duration is at least 7 days",
            "attribute_path": ["retention_duration"],
            "values": ["604800s", "1209600s", "2592000s", "31536000s"],
            "policy_type": "whitelist"
        }
    ]
]

result := helpers.get_multi_summary(conditions, vars.variables)
message := result.message
details := result.details

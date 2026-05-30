package terraform.gcp.security.cloud_spanner.google_spanner_instance.force_destroy
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

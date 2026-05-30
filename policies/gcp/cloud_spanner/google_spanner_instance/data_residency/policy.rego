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

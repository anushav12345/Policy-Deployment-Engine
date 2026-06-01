package terraform.gcp.security.cloud_spanner.google_spanner_instance.edition
import data.terraform.helpers
import data.terraform.gcp.security.cloud_spanner.google_spanner_instance.vars

conditions := [
    [
        {"situation_description": "Cloud Spanner instance has edition set to EDITION_UNSPECIFIED, meaning engineers have not explicitly selected a SKU. This can lead to unexpected behaviour and makes security posture unclear.",
         "remedies": ["Set edition to an explicit value: STANDARD, ENTERPRISE, or ENTERPRISE_PLUS."]},
        {
            "condition": "Check edition is not EDITION_UNSPECIFIED",
            "attribute_path": ["edition"],
            "values": ["EDITION_UNSPECIFIED"],
            "policy_type": "blacklist"
        }
    ]
]

result := helpers.get_multi_summary(conditions, vars.variables)
message := result.message
details := result.details

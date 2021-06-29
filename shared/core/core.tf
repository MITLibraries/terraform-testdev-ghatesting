# This module is always included to provide consistent naming
# IMPORTANT: The name value must be updated to match the app name
module "label" {
  source = "github.com/mitlibraries/tf-mod-name?ref=0.12"
  name   = "core"

}

# This creates a simple EC2 instance.
# This should trigger tf-validate
# tf-gcp-infra


# API's enabled for IAC
- Google Compute Engine

# Terraform commands used.
This command initializes terraform and downloads the required binaries for the providers.
- ```terraform init```

To check if the config is valid we run the following command
- ```terraform validate```

To review the changes being made by our terraform config we run the following.
- ```terraform plan```

To apply changes done locally to GCP/AWS we run the following command
- ```terraform apply```
  
This also runs terraform plan and requires approval before creating/modifying any resourcers


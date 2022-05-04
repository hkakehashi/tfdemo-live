# Fastly - Terraform Demo<br>Example Repository for Live Environments

This repo includes:

- Terraform code to deploy prod/stage Fastly VCL services
- Terraform code to deploy certificates for the prod/stage domains
- GitHub Actions workflows to manage the deployment tasks

The two live services hosted in this repo both use the Terraform modules from [the modules repo](https://github.com/hkakehashi/tfdemo-modules), but in different versions using the module source `ref` argument.

**Image of the file structure**

```
├── live                      <------------------ This repository
│   ├── cert
│   │   ├── main.tf
│   │   └── provider.tf
│   └── service
│       ├── prod              <------------------ Using v1.0.0 (Minimal configuration)
│       │   ├── main.tf
│       │   └── provider.tf
│       └── stage             <------------------ Using v1.1.0 (Additional features enabled)
│           ├── main.tf
│           └── provider.tf
└── modules
    ├── cert
    │   ├── main.tf
    │   ├── output.tf
    │   ├── provider.tf
    │   └── variables.tf
    └── service
        ├── main.tf
        ├── output.tf
        ├── provider.tf
        ├── variables.tf
        └── vcl
            ├── main.vcl
            └── snippet.vcl
```

## Github Actions workflow

### Triggers and actions

- Pull Requests to the main branch

  - Run `terraform plan`
  - Add the results of the plan to the PR. The template is borrowed from [here](https://learn.hashicorp.com/tutorials/terraform/github-actions).

- Push/Merge on the main branch

  - Run `terraform apply` to update the target Fastly service

- Workflow dispatch

  - Run `terraform plan` when the workflow is manually triggered on a non-main branch
  - Run `terraform apply` when the workflow is manually triggered on the main branch

### Working directory

The set of Terraform commands are executed in one or a combination of the following directories, depending on where the changes were made:

- `cert/`
- `service/prod/`
- `service/stage/`

## Environment variables

The workflow requires the following environment variables.
Each value is stored as a Secret in this repo.

| Var Name              | Description                                                                          |
| --------------------- | ------------------------------------------------------------------------------------ |
| AWS_ACCESS_KEY_ID     |                                                                                      |
| AWS_SECRET_ACCESS_KEY |                                                                                      |
| BACKEND_BUCKET        | Name of the S3 bucket                                                                |
| BACKEND_DYNAMO_DB     | Name of the DynamoDB table                                                           |
| BACKEND_ROLE_ARN      | ARN of the role to update the state file                                             |
| FASTLY_API_KEY        | [Fastly API token](https://docs.fastly.com/en/guides/using-api-tokens?_fsi=fmEGPI4g) |

## Backend

In this example, an S3 backend is used to store the Terraform state file.

The S3 backend has been deployed separately from this repository with the following Terraform code. Some of the output of the deployment is set in the environment variables of this repository.

### Deploying the S3 backend

```
provider "aws" {
    region = "ap-northeast-1"
}

module "s3backend" {
    source = "github.com/hrmsk66/terraform-aws-s3backend"
}

output "s3backend_config" {
    value = module.s3backend.config
}
```

### Example output from the S3 backend deployment

```
s3backend_config = {
    bucket         = "s3backend-XXXXX-state-bucket"
    dynamodb_table = "s3backend-XXXXX-state-lock"
    region         = "ap-northeast-1"
    role_arn       = "arn:aws:iam::YYYYY:role/s3backend-XXXXX-tf-assume-role"
}
```

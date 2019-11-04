provider "aws" {
  profile    = "default"
  region     = "eu-west-1"
}

terraform {
  backend "remote" {
    organization = "YOUR_TERRAFORM_CLOUD_ORG"

    workspaces {
      name = "project-students-eu-west-1"
    }
  }
}
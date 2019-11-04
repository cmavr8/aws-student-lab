# aws-student-lab

Basic setup of an AWS account, including some users (students of a lab, in this example). 

## What it does
* Sets up billing alerts to ensure we don't overspend,
* creates users (students) and encrypts their passwords using a keybase account,
  * uses proper user group, with inline policy,
  * users can only use micro and nano EC2 instances, 
* massively decrypts passwords and prints them (to be used with care!).

## Background
This was initially used during an information security course I volunteered at. I setup a small lab for Ghana students to learn cloud security on.

## How to use
First you need to edit `setup.tf` and `terraform.auto.tfvars` to suit your needs.

Then you need to setup a few prerequisites:
* [Setup terraform and AWS CLI](https://learn.hashicorp.com/terraform/getting-started/install)
* [Setup terraform remote state](https://learn.hashicorp.com/terraform/getting-started/remote)

Setup python etc. E.g. on Ubuntu, it's something along these lines:

    virtualenv -p python3 venv
    source venv/bin/activate
    pip install --upgrade awscli

Then just go for it:

    terraform init
    terraform apply
    
It will fail the first time. Make sure to set environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in Terraform cloud and retry the `apply`.

After successful execution, to get the user credentials (very dangerous, use with care!) try:

    terraform output passwords > SUPERSECRET
    python3 decrypt.py

For a more full walkthrough, see [this post on Chris's security notes](https://chrissecnotes.blogspot.com/2019/10/practical-aws-security-setup.html
).
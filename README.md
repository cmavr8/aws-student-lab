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
First you need to setup a few prerequisites:
* Make an account on [Terraform Cloud](https://app.terraform.io/),
* [install terraform locally](https://learn.hashicorp.com/terraform/getting-started/install),
* [add your Terraform Cloud API key in a file on your system](https://learn.hashicorp.com/terraform/getting-started/remote),
* protect the key by running `chmod 600 ~/.terraformrc` (this is not in the instructions but I think is a good idea since the home dir on some systems is world readable),
* copy `terraform.auto.tfvars.example` to `terraform.auto.tfvars`,
* then, edit `setup.tf` and `terraform.auto.tfvars` to suit your needs.

Finally just go for it:

    terraform init
    terraform apply
    
It will fail the first time. Make sure to set environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in Terraform cloud and retry the `terraform apply` command.

After successful execution, to get the user credentials (very dangerous, use with care!) try:

    terraform output passwords > SUPERSECRET
    python3 decrypt.py

For a more full walkthrough, see [this post on Chris's security notes](https://chrissecnotes.blogspot.com/2019/11/practical-aws-security-setup.html).

## Alternative setup
If you don't want to use Terraform Cloud, you'll have to have aws-cli and store terraform state locally. You'll need to tweak the config files and follow most steps of [the terraform guide](https://learn.hashicorp.com/terraform/getting-started/install).

Also, setup python etc. E.g. on Ubuntu, it's something along these lines:

    virtualenv -p python3 venv
    source venv/bin/activate
    pip install --upgrade awscli

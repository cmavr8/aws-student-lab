# WARNING: .tfstate is sensitive, due to IAM user passwords being in there. Handle it with care.

# Variables
variable "howmanystudents" {
 type = number
 description = "Number of students to provision accounts for."
}

variable "keybaseuser" {
 type = string
 description = "The Keybase user that will be used to encrypt passwords."
}

# Make a policy
# TODO: Remove the hardcoded eu-west-1 region. You'll probably have to switch to aws_iam_policy_document to achieve this
resource "aws_iam_policy" "student-policy" {
  name        = "student-policy"
  description = "A policy to be used by students of the workshop"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:Region": "eu-west-1"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": [
            "autoscaling.amazonaws.com",
            "ec2scheduled.amazonaws.com",
            "elasticloadbalancing.amazonaws.com",
            "spot.amazonaws.com",
            "spotfleet.amazonaws.com",
            "transitgateway.amazonaws.com"
          ]
        }
      }
    },
    {
      "Sid": "limitedSize",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "ForAnyValue:StringNotLike": {
          "ec2:InstanceType": [
            "t2.micro",
            "t2.nano"
          ]
        }
      }
    }
  ]
}
EOF
}

# Make a group
resource "aws_iam_group" "students" {
  name = "students"
}

# Make a few users
resource "aws_iam_user" "multi-students" {
  count = var.howmanystudents
  name = "student.${count.index}"
}

# Assign users to group
resource "aws_iam_user_group_membership" "student-to-grp" {
  count = var.howmanystudents
  user = "${element(aws_iam_user.multi-students.*.name,count.index )}"

  groups = [
    "${aws_iam_group.students.name}",
  ]
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "student-group-attach" {
  group      = "${aws_iam_group.students.name}"
  policy_arn = "${aws_iam_policy.student-policy.arn}"
}

# Setup and output passwords for users
resource "aws_iam_user_login_profile" "student-profile" {
  count = var.howmanystudents
  user = "${element(aws_iam_user.multi-students.*.name,count.index )}"
  pgp_key = var.keybaseuser
  password_reset_required = "true"
}


output "usernames" {
  value = "${aws_iam_user_login_profile.student-profile.*.user}"
}

output "passwords" {
  value = "${aws_iam_user_login_profile.student-profile.*.encrypted_password}"
}

# Dummy S3 bucket, which should cause a checkov check to fail
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "dummybucket"
  acl = "private"

 server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       sse_algorithm = "AES256"
     }
   }
 }

  versioning {
    enabled = true
  }

  mfa_delete {
    enabled = true
  }

  logging {
    target_bucket = "a-nonexistent-bucket"
  }
}
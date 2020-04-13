#!/usr/bin/env python
import base64
from subprocess import Popen, PIPE, STDOUT

# This script decodes AWS IAM passwords for users created by terraform.
# Obviously, VERY DANGEROUS, so use properly, only on test accounts etc.

# First, run this:
# terraform output passwords > SUPERSECRET

lines = []
with open("SUPERSECRET") as file:
    lines = [line.strip() for line in file]

del lines[0] # Delete first element
del lines[-1] # And last

print("Usernames and passwords (no spaces):")

for i, line in lines:
    # Strip extra stuff and decode base64
    strippedline = line.strip(',').strip('"')
    decodedline = base64.b64decode(strippedline)

    # Pass the decoded line to keybase, for decryption
    p = Popen(["keybase", "pgp", "decrypt"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
    stdout_data = p.communicate(input=decodedline)[0]

    print("student.{}".format(i), stdout_data.decode())
# pm_dot_net

Packer scripts and chef cookbook to install IIS on a Windows AMI

#### Run Packer with DEBUG info

This uses the base Windows AMI in us-west-2.  Packer should pull AWS credentials from the usual sources if they're not specified as arguments like below.

packer.json provides user-data.ps1 to EC2 to execute on image boot.  This powershell script enables WinRM for remote use by packer.

`PACKER_LOG=1 /path/to/packer build --var "base_ami=ami-4dbcb67d" --var "region=us-west-2" --var "aws_access_key=AKIAJCTESTTEST" --var "aws_secret_key=UvTytesttest" packer.json`
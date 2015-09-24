# pm_dot_net

Packer scripts and chef cookbook to install IIS on a Windows AMI

#### Download cookbook dependencies

`berks install`
`berks vendor`

This instructs berkshelf to download all necessary cookbooks and install them in the berks-cookbooks directory

#### Run with Packer

This example uses the base Windows AMI in us-west-2.

packer.json provides ec2-user-data.ps1 to EC2 to execute on image boot.  This powershell script enables WinRM for remote use by packer.

`/path/to/packer build --var "base_ami=ami-4dbcb67d" --var "region=us-west-2" packer.json`

#### Run with builder.py

A python script is provided to parse AMI IDs from the previous step in the build process (in the form of a file called ami_ids.json, placed in the build directory by Jenkins)

`python builder.py us-west-2`
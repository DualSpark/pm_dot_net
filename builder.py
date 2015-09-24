import subprocess
import re
import json
from sys import argv
from pprint import pprint

script, region = argv

with open('ami_ids.json') as data_file:    
    data = json.load(data_file)

ami_id = data[region]['HVM64']

p = subprocess.Popen("/usr/share/packer/packer build -var 'region=" + region + "' -var 'base_ami=" + ami_id + "' packer.json", stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)

output = ""
while True:
	line = p.stdout.readline()

	if line:
		print line,
		output = output + line
	else:
		break

f = open('dot_net_stack_ami_ids.json', 'w')

m = re.search(r"AMIs were created:\n\n([^:]*): ([^\n]*)\n", output)
if m:
    	f.write('{ "' + region + '": { "dot_net_stack": "' + m.group(2) + '" } }')

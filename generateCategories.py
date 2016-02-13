import json
import sys
from pprint import pprint

with open('categories.json') as data_file:    
    data = json.load(data_file)

dict = {}

sys.stdout.write("[")
for i in xrange(0, len(data)):
	if data[i]["alias"] not in dict:
		if not data[i]["parents"]:
			dict[data[i]["alias"]] = "root"
		else:
			dict[data[i]["alias"]] = data[i]["parents"][0]

for i in xrange(0, len(data)):
	if not data[i]["parents"]:
		continue
	parent = data[i]["parents"][0]
	while parent != "restaurants" and parent != "root":
		if dict[parent] == "root":
			break
		parent = dict[parent]

	if parent != "restaurants":
		continue
	sys.stdout.write("[\"name\":\"{0}\", \"code\":\"{1}\"],".format(data[i]["title"], data[i]["alias"]))
sys.stdout.write("]")


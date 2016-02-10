import json
from pprint import pprint

with open('categories.json') as data_file:    
    data = json.load(data_file)

# pprint(data)
for i in xrange(0, len(data)):
	print data[i]
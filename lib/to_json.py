import os
import sys
import numpy as np
import simplejson as json

def to_json(content,filename,indent=2):
  #Convert numpy array to list, store it in a Json
  with open(filename, 'w') as output:
    json.dump(content, output, 
              indent=indent, sort_keys=False)
  print "json conversion complete."

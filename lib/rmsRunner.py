import sys
import os
from rmsIterator import rmsIterator
from rmsMaster import rmsMaster
from datetime import datetime

import thread
timer = datetime.now()

#Check to be sure command line arguments are present. Format is: fileinput, fileoutput, chunksize, numberofchunks
print "<br>You supplied " + str(len(sys.argv)-1) + " command line arguments.\nThey are: " + str(sys.argv[1]) + " " + str(sys.argv[2]) + " " + str(sys.argv[3]) + " " + str(sys.argv[4]) + "\n"

#is the file too big?
fileStat = os.stat(sys.argv[1])
fileSize = fileStat.st_size

if int(fileSize)/4128 > int(sys.argv[3])*int(sys.argv[4]):
  rmsMaker = rmsMaster(str(sys.argv[1]), str(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]))

  print "<br>Init complete."
  print "<br>Processing " + str(sys.argv[4]) + " chunks of " + str(sys.argv[3]) + " frames each."
  print 'Beginning compute method'
  rmsMaker.compute()
  print "<br>Command line arguments were: \n" + str(sys.argv[0]) + " " + str(sys.argv[1]) + " " + str(sys.argv[2]) + " " + str(sys.argv[3]) + " " + str(sys.argv[4]) + "\n"
  print "<br>Processing complete in " + str(datetime.now()-timer) + "\n"
else:
  print "<br>You asked for more data than are available. Max frames: " + str(fileSize/4128) + ". You asked for " + str(int(sys.argv[3])*int(sys.argv[4])) + " frames."


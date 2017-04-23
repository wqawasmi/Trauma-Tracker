from pymongo import *
import os
import sys

fileName = sys.argv[1] #file where data is written

file = open(fileName, 'w')

client = MongoClient('localhost', 27017)
db = client.accelDatabase

dbLength = db.accelDatabase.count()

if(dbLength <= 0 ):
	file.write(str(0))
	sys.exit()
	
for data in db.accelDatabase.find().skip(dbLength -1):
			print data['eventNum']
			file.write(str(data['eventNum']))

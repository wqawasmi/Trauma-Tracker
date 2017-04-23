from pymongo import *
import os
import sys

client = MongoClient('localhost', 27017)
db = client.accelDatabase

fileName= sys.argv[1]  #caller inputs data file to be read

with open(fileName, "r") as file:
    accel = []
    for line in file:
        accel.append(line.strip('\n'))    #strip \n and store in accel array


dbLength = db.accelDatabase.count()

if dbLength == 0:  #calculate event number for next data set
	lastEvent = 0
else:
	for data in db.accelDatabase.find().skip(dbLength -1):
			lastEvent = data['eventNum']

for x in range(0,len(accel)):		#post data to database
	results = db.accelDatabase.insert_one(
		{
			"eventNum" : int(lastEvent + 1),
			"accel" : accel[x]
		}
	)
	dbLength = dbLength + 1

from pymongo import *
import os
import sys

client = MongoClient('localhost', 27017)
db = client.eegDatabase

eeg = sys.argv[1:]

dbLength = db.eegDatabase.count()

for x in range(0,len(eeg)):
	results = db.eegDatabase.insert_one(
		{	
			str(dbLength): eeg[x]
		}
	)
	dbLength = dbLength + 1
	
	
	"""
	eeg = sys.argv[1]
	accel = sys.argv[2]

for x in data:
	results = db.eegDatabase.insert_one(
		{	
			str(i): x
		}
	)
	

	
	
	"""
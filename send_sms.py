import os
from twilio.rest import Client

def send_sms(data, userPhone):
	account_sid = "ACf5228c8f7c3e6ae961f98604a717380e"
	auth_token  = "4ef51d16456da350c5def9506dc71f56"

	client = Client(account_sid, auth_token)

	message = client.messages.create(
		to="+1" + userPhone, 
		from_="+18622197472",
		body=data)
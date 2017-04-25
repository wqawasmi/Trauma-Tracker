## How to Run
Run concuss.pde in Processing

## Inspiration
There has been extensive medical research correlating changes in EEG with concussions and trauma. These monitors have been limited to researchers until recent developments in commercial EEG monitors. Today we bring you a portable concussion/trauma monitor that utilizes the Muse headband and can be placed in any helmet belonging to you or your children.

## What it does
You can place the band in any helmet and track you or your child's impacts to the head. If a hard impact is detected, an automatic SMS message is sent to you that will notify you to be wary of concussion symptoms. In addition, the EEG and accelerometer data moments before and after the impact is saved so it can be analyzed by a medical professional if need be. 

## How we built it
The Muse headband was used to gather EEG and accelerometer data. Processing was used to interface with Muse and build a GUI. Python was used for connecting to a MongoDB database for saving and retrieving impact event data. The Twilio API was used to send SMS messages via Python. 

## Challenges we ran into
Detecting significant changes in the data that was not random noise was a challenge. There was also difficulties in deciding the most efficient way to store and retrieve data specific to an event in a MongoDB database. Displaying the data in a presentable fashion using GUI's was also difficult.

## Accomplishments that we're proud of
A pretty GUI. We managed to create a software package that utilizes both Java and Python, along with a number of API's.

## What we learned
We had never used the Muse headband, Twilio API or MongoDB API before, so that was a learning experience.
We also learned a lot about the correlations between EEG and  concussions. 

## What's next for Trauma Tracker
Gather real-world data to better train the algorithm to detect significant impacts.

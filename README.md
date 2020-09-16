# LectureRusher
An app that will remove filler words, silences and speed up videos for an online learning experience that is constricted by the time we have for school

### I will be tracking my progress using this readme file.

# 9:00am

Cloned the github repo and Initialized the environment.

# 10:42 am

fumbling around aws lambda is taking precious time, it isn't as intiuitive as it was made to be.

# 4:00pm

Here's what I did during this time:

######    1. Experimented with AWS lambda, even more... but it turns out I need more.

######    2. Started an EC2 instance... but that was too overboard.

######    3. Ahhhh LightSail what a service. Simple, Elegant, and what I need. So I started an AWS LightSail instance got it loaded with Ubuntu 20.04LTS and setup the evironment

######    4. Installed apache2, python and flask and setup a basic website to upload files to the server from anywhere.

######    5. Began the actual work of getting the silences detected and cut.

# 7:15pm

I think I've mainly constructed the basic functionality of the app, for now the script uses the prebuilt model through the praat file to extract the silent parts (including filler words).

###### Drawbacks I have uncovered during my testing:

######      1. Sometimes filler words slip by due to misaligned pitches but this is rare and could be related to the specific audio file.
######      2. If a file is big(>=5-6 mb) the model takes a bunch of time to churn through it, this could be solved with a machine with better oomph than my laptop and the feeble free tier aws ec2 instance I am going to run this script >_>

----------------------------
# Day2

# 2:15pm

Woot woot. The Flutter app is taking shape, just finished the recording functionality.

To use the recording functionality here is what you can do:
######      Tap the Record Button once to start recording.
######      Double tap the record button to pause.
######      Long press the record button to stop and save the recording.

Note: I still have to do the following for the recoding functionality:
######      1. Provide a better way to let the user that there is a recording going on.
######      2. Fix the naming of the recording (for now everything is saved as a file with same name to /sdcard/)

# TIME TO WORK ON THE UPLOADING FUNCTIONALITY HOHOHO

# 6:00pm

# ANDDDDDDDDDDDDDDDDDDDDD it's done UPLOADDDDING IZZZZZ DONE BAAABY, there are a few caviats though:

######      1. I am using flask to handel the requests to the aws lightSail server instance.
######      2. There is literally not a signle bit of error handling XD it could all crash an die and burn but no errors will be generated (hakathon kids be like: u cnt hv wrkng app ECKS DEE ECKS DEE)
######      3. The files I am send are encoded as base64 strings and sent with the json response (I wanted something simple and quick, this should suffice for the hackathon)
######      4. Getting more worried about the lightsail server, it turns out I am not getting the aws credit in time to expand it's capabilities. Hope it works out tommorow.

# 8:42pm

###### Big ooooof wasted a bunch of time on getting the app to play a sound with flutter_sound but it is bugged beyond hell so I scraped the idea ehhhh.

----------
# Day 3

###### Didn't have much time to log today, but it was a beautiful ride. I gave it my best, next time around I am for sure getting meself a team mate!
###### Hot damn the server took alllllllllllllllllllllllot of time to setup, most tutorials on the internet on how setup flask are as outdated as a my granny. I might set a tutroial myself.

###### Man I wish this covid things ends tommorow. Stay Safe Wear A Mask PEACE!
----------

# Work flow of the lighsail server.

######  1. File gets picked by user.
######  2. File gets encoded to base64 string.
######  3. File is packaged as json and sent as an http post request.
######  4. The script gets triggered and the model is run producing aa .TextGrid file. the .TextGrid file contains the data on how to cut the audio, so a bunch of commads are issued to extract the data, format it and send it back as a json respone file to the user.

---------
# Work flow of the live transcribe/text analysis functionality

###### 1. User presses the record button.
###### 2. The devices microphones are polled for input, and the framework takes care of the rest.
###### 3. When the user hits the text analysis button the following takes place:
######      a. The request is sent to AWS Api gateway
######      b. The request gets forwarded to AWS lambda
######      c. Lambda calls amazon boto and then AWS Comperehend is called upon for analysis
######      d. The data is formatted and sent back a json response.

---------

# How to build the flutter app(requires flutter to be installed on the system).
######  1. Clone the repo
######  2. cd lectureruhser
######  3. flutter clean
######  4. flutter build apk --split-per-abi

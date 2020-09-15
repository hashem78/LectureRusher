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

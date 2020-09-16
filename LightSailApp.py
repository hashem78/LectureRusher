from flask import Flask, render_template, request, jsonify
from werkzeug.utils import secure_filename

import base64
import os

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = '/home/ubuntu/flaskapp/static'


from moviepy.editor import VideoFileClip, AudioFileClip, concatenate_videoclips, concatenate_audioclips
import parselmouth
from parselmouth.praat import call, run_file
import subprocess


def audio_cut_at(filename, cuts):
    """Cuts audio based on (start,end) tuples

    Args:
        filename (string): the name of the file from which parts are to be cut
        cuts (list): list of (start,end) tuples, each tuple represents the parts to be cut, both start and end are float values

    Returns:
        moviepy.VideoClip
    """
    audio_to_cut = AudioFileClip(filename)
    final_audio = audio_to_cut.subclip(cuts[0][0], cuts[0][1])
    for i in range(1, len(cuts)):
        a = audio_to_cut.subclip(
            cuts[i][0], cuts[i][1])
        final_audio = concatenate_audioclips([final_audio, a])
    final_audio.write_audiofile('done_proc.wav')
    return final_audio


def extract_silences_audio_ml(file_name):
    """This function is much better than ffmpeg for finding silences in audio as it uses a Machine learnig model trained specifically for this purpose.
    Also, this function depends on praat/parselmouth.

    Args:
        file_name (string): the name of the file from which silences are to be extracted. NOTE: MAKE SURE THE FILENAME IS WITHOUT ITS EXTENSION

    Returns:
        list: a list of tuples (start,end) where 'start' and 'end' are the start of the detected silence and the end of the silence part respectively
    """

    sound = file_name + ".wav"

    # This file contains the machine learning model as a praat script
    sourcerun = "myspsolution.praat"

    path = os.getcwd() + "/"

    try:
        objects = run_file(sourcerun, -20, 2, 0.3, "yes",
                           sound, path, 80, 400, 0.01, capture_output=True)  # Analize the audio based on the model using parselmouth
    except Exception as e:
        z3 = 0
        print("Try again the sound of the audio was not clear", e)
        return

    cmd = "grep -n 'intervals ' {}.TextGrid | sed -e 's/:.*//g'".format(
        file_name)  # This command is used to extract the beginning of the data

    first_line = subprocess.run(
        cmd, stdout=subprocess.PIPE, shell=True).stdout.decode('utf-8').split('\n')[0]
    first_line = int(first_line)

    """
        Praat scripts product textgrid files as organized output for applications to digest.
        Here, I use the interval data it generates to create a list of places in the audio where there is silence
    """
    cmd = "sed -n '{},$p' {}.TextGrid".format(first_line, file_name)
    intervals = subprocess.run(cmd, stdout=subprocess.PIPE,
                               shell=True).stdout.decode('utf-8').split('\n')

    intervalsn = []
    for interval in intervals:
        intervalsn.append(interval.strip())
    silent = []
    for i in range(1, len(intervalsn) - 1, 4):

        # Xmin represnts the lower bound of silence part
        xmin = intervalsn[i].split(' ')[2]

        # Xmax represents the upper bound of silencepart
        xmax = intervalsn[i + 1].split(' ')[2]

        # This extraneous piece of data paart generates helps to distinguish between silences and sounding parts of the audio, here we take the silent parts.
        text = intervalsn[i + 2].split(' ')[2].strip('"')

        if text == "sounding":
            silent.append((float(xmin), float(xmax)))

    return silent


def video_cut_at(filename, cuts):
    """Cuts video based on (start,end) tuples

    Args:
        filename (string): the name of the file from which parts are to be cut
        cuts (list): list of (start,end) tuples, each tuple represents the parts to be cut, both start and end are float values

    Returns:
        moviepy.VideoClip
    """
    video_to_cut = VideoFileClip(filename)
    final_video = video_to_cut.subclip(0, cuts[0][0])

    for i in range(0, len(cuts)):
        if not i == (len(cuts) - 1):
            a = video_to_cut.subclip(
                cuts[i][1], cuts[i + 1][0])
            final_video = concatenate_videoclips([final_video, a])
    return final_video


@app.route('/upload')
def upload_file():
    return render_template('upload.html')


@app.route('/uploader', methods=['GET', 'POST'])
def upload2_file():
    if request.method == 'POST':
        f = request.files['file']
        f.save(os.path.join(app.config['UPLOAD_FOLDER'], f.filename))
        return 'file uploaded successfully'


@app.route('/uploadWAV', methods=['GET', 'POST'])
def uploadWAV():
    content = request.get_json(silent=True)

    wav_file = open("to_be_proc.wav", "wb+")
    decode_string = base64.b64decode(content['file'])
    wav_file.write(decode_string)
    wav_file.close()
    
    silences = extract_silences_audio_ml('to_be_proc')
    audio_cut_at('to_be_proc.wav',silences)
    
    encodedWAV = base64.b64encode(open("done_proc.wav",'rb').read())

    ### Encode the file
    return jsonify(
        file = encodedWAV,
        response = "HTTP 200"
    )


if __name__ == '__main__':
    app.run(debug=True, port=5555)

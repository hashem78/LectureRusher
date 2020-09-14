from moviepy.editor import VideoFileClip, AudioFileClip, concatenate_videoclips, concatenate_audioclips
import parselmouth
from parselmouth.praat import call, run_file
import os
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
    final_audio = audio_to_cut.subclip(0, cuts[0][0])
    for i in range(0, len(cuts)):
        if not i == (len(cuts) - 1):
            a = audio_to_cut.subclip(
                cuts[i][1], cuts[i + 1][0])
            final_audio = concatenate_audioclips([final_audio, a])

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

        if text == "silent":
            silent.append((xmin, xmax))

    return silent
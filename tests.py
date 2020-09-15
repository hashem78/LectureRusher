from flask import Flask, render_template, request, jsonify
from werkzeug.utils import secure_filename

import base64
import os

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = '/home/ubuntu/flaskapp/static'


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
    import script as sc
    
    silences = sc.extract_silences_audio_ml('to_be_proc')
    sc.audio_cut_at('to_be_proc.wav',silences)
    
    encodedWAV = base64.b64encode(open("done_proc.wav",'rb').read())

    ### Encode the file
    return jsonify(
        file = encodedWAV,
        response = "HTTP 200"
    )


if __name__ == '__main__':
    app.run(debug=True, port=5555)

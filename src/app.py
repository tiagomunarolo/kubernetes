from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():
    return "App is runnig"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=1000, debug=True)

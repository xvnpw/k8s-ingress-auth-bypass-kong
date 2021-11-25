from flask import Flask, request
import sys

app = Flask(__name__)

@app.route('/public')
def public():
    print(request.headers, file=sys.stderr)
    return {
        "data": "public data",
    }

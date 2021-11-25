from flask import Flask, Response, request
from http import HTTPStatus
import sys

app = Flask(__name__)

@app.route('/verify')
def verify():
    print(request.headers, file=sys.stderr)
    api_key = request.headers.get('X-Api-Key')
    uri = request.headers.get('X-Original-Uri')

    if uri and uri.startswith("/public-service/"):
        return Response(status = HTTPStatus.OK)

    if api_key == "secret-api-key":  
        return Response(status = HTTPStatus.OK)

    return Response(status = HTTPStatus.UNAUTHORIZED)

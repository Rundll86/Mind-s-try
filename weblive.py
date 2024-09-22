import flask

app = flask.Flask(__name__)


@app.route("/<path:page>")
def root(page):
    return flask.send_file("build/web/" + page)


app.run(host="0.0.0.0", port=8080)

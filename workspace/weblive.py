import flask

app = flask.Flask(__name__)


@app.route("/")
def rootroot():
    return flask.redirect("/index.html")


@app.route("/<path:page>")
def root(page):
    return flask.send_file("../build/web/" + page)


@app.route("/index.html")
def index():
    return flask.send_file("../build/web/Mind's try.html")


app.run(host="0.0.0.0", port=8080)

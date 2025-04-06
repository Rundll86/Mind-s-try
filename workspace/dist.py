import zipfile, os

os.chdir("..")
file = zipfile.ZipFile("build/web.zip", "w")
for root, dirs, files in os.walk("build/web"):
    for filename in files:
        abspath = os.path.join(root, filename)
        file.write(abspath, os.path.relpath(abspath, "."))

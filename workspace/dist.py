import zipfile, os

os.chdir("..")
outputname = "[RELEASE] Mind's try.zip"
file = zipfile.ZipFile(f"build/{outputname}", "w")
for root, dirs, files in os.walk("build"):
    for filename in files:
        if filename == outputname:
            continue
        abspath = os.path.join(root, filename)
        file.write(abspath, os.path.relpath(abspath, "."))

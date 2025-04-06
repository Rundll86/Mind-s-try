import os, shutil

os.chdir("..")
for root, dirs, files in os.walk("."):
    if [".godot", "build"].count(os.path.basename(root)) > 0:
        shutil.rmtree(root)
        continue
    for file in files:
        if file.endswith(".import"):
            os.remove(os.path.join(root, file))

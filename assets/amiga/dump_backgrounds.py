from PIL import Image
import pathlib

with open("ab03.6b","rb") as f:
    contents = f.read()

dumps_dir = pathlib.Path("dumps/background")

bg_tiles = {i:Image.open(dumps_dir / f"unknown_{i:03x}.png") for i in range(0,0xd)}
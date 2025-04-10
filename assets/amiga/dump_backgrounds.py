from PIL import Image
import pathlib,os

with open("ab03.6b","rb") as f:
    contents = f.read()

bgpic = pathlib.Path("../sheets/background.png")

bg_image = Image.open(bgpic)

bg_tiles = []
x = 0
for i in range(0,0xe):
    img = Image.new("RGB",(16,16))
    img.paste(bg_image,(-x,0))
    x += 16
    bg_tiles.append(img)

img = Image.new("RGB",(256,256))

icont = iter(contents)

pathlib.Path("dumps/maps").mkdir(exist_ok=True)

# there are 6 different level layouts
for lvl in range(0,6):
    y = 0
    for i in range(0,16):
        x = 0
        for j in range(0,16):
            c = next(icont)
            img.paste(bg_tiles[c],box=(x,y))
            x += 16
        y += 16

    img.save(f"dumps/maps/level_{lvl+1}.png")
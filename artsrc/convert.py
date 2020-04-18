import sys
from PIL import Image
import numpy as np
im = Image.open(sys.argv[1])
indexed = np.array(im)
indices = [str(num) for row in indexed for num in row]
# Use RLE so the image hopefully doesn't exceed code size limits
values = []
runs = []
for index in indices:
    if not values or index != values[-1]:
        values.append(index)
        runs.append(1)
    else:
        runs[-1] += 1
print(f"img_values = {{{','.join(values)}}}")
print(f"img_runs = {{{','.join(str(run) for run in runs)}}}")
palette = im.getpalette()
print(f"pal = {{{','.join(str(p) for p in palette[:16*3])}}}")
print(f"-- pal = {''.join(hex(p)[2:] for p in palette[:16*3])}")

# /usr/local/bin/python3
# -*- coding: utf-8 -*-

import os
import glob
import shutil
from PIL import Image


src_root = os.path.dirname(os.path.realpath(__file__))
output_dir = os.path.join(src_root, "logos")


def convertImage(imageFile, outdir, size, scale, is_iPhone=True):
    image = Image.open(imageFile)
    try:
        basename = os.path.basename(imageFile)
        name = os.path.splitext(basename)[0]
        scale_string = "" if scale == 1 else "@%dx" % scale
        suffix = "" if is_iPhone else "~ipad"
        new_name = "{name}{size}x{size}{scale_string}{suffix}.png".format(
            name=name,
            size=size,
            scale_string=scale_string,
            suffix=suffix,
        )
        size_of_scale = int(size*scale)
        resize = (size_of_scale, size_of_scale)
        new_image = image.resize(resize, Image.BILINEAR)
        new_image.save(os.path.join(output_dir, new_name))
    except Exception as e:
        print(e)


if __name__ == '__main__':
    if os.path.exists(output_dir):
        if os.path.isfile(output_dir):
            os.remove(output_dir)
        elif os.path.isdir(output_dir):
            shutil.rmtree(output_dir, ignore_errors=True)
    os.makedirs(output_dir, exist_ok=False)
    imageRe = os.path.join(src_root, "*.png")
    iPhone_size_scall = [
        (20, 2),
        (20, 3),
        (29, 2),
        (29, 3),
        (40, 2),
        (40, 3),
        (60, 2),
        (60, 3),
    ]
    iPad_size_scall = [
        (20, 1),
        (20, 2),
        (29, 1),
        (29, 2),
        (40, 1),
        (40, 2),
        (76, 1),
        (76, 2),
        (83.5, 2),
    ]
    for imageFile in glob.glob(imageRe):
        for (size, scale) in iPhone_size_scall:
            convertImage(imageFile, output_dir, size, scale, is_iPhone=True)
        for (size, scale) in iPad_size_scall:
            convertImage(imageFile, output_dir, size, scale, is_iPhone=False)

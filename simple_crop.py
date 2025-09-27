import os
import math
import json
import time
import base64
import subprocess
import configparser
import io
import re
import shutil
import uuid
import tempfile
from PIL import Image, ImageFilter
from multiprocessing import Pool





def to_bytes(file_or_bytes, resize=None):
    """
    Will convert into bytes and optionally resize an image that is a file or a base64 bytes object.
    Turns into PNG format in the process so that can be displayed by tkinter
    :param file_or_bytes: either a string filename or a bytes base64 image object
    :param resize:  optional new size
    :return: (bytes) a byte-string object
    """
    if isinstance(file_or_bytes, str):
        img = Image.open(file_or_bytes)
    else:
        try:
            img = Image.open(io.BytesIO(base64.b64decode(file_or_bytes)))
        except Exception as e:
            dataBytesIO = io.BytesIO(file_or_bytes)
            img = Image.open(dataBytesIO)

    cur_width, cur_height = img.size
    if resize:
        new_width, new_height = resize
        scale = min(new_height / cur_height, new_width / cur_width)
        img = img.resize(
            (int(cur_width * scale), int(cur_height * scale)), Image.Resampling.LANCZOS
        )
    bio = io.BytesIO()
    img.save(bio, format="PNG")
    del img
    return bio.getvalue()

def find_images(directory):
    images = []
    # Walk through directory structure
    for root, dirs, files in os.walk(directory):
        # Find all .png files in current directory
        for file in files:
            if file.lower().endswith('.png') or file.lower().endswith('.jpg') or  file.lower().endswith('.jpeg'):
                full_path = os.path.join(root, file)
                images.append(full_path)
    return images

def create_unique_temp_dir(prefix="temp_"):
    """
    Creates a unique directory in the system's temp directory.

    Args:
        prefix (str): Prefix for the directory name (default: 'temp_')

    Returns:
        str: Path to the created directory
    """
    unique_dir = os.path.join(tempfile.gettempdir(), f"{prefix}{uuid.uuid4().hex}")
    os.makedirs(unique_dir, exist_ok=True)
    return unique_dir

def the_cropper(args):
    image, tempdir, MaxDPI, BumpVibrance, InPlace = args
    with Image.open(image) as im:
        img_file = os.path.basename(image)
        w, h = im.size
        c = round(0.12 * min(w / 2.72, h / 3.7))
        dpi = c * (1 / 0.12)
        print(
            f"{img_file} - DPI calculated: {dpi}, cropping {c} pixels around frame"
        )
        crop_im = im.crop((c, c, w - c, h - c))
        if dpi > MaxDPI:
            crop_im = crop_im.resize(
                (
                    int(round(crop_im.size[0] * MaxDPI / dpi)),
                    int(round(crop_im.size[1] * MaxDPI / dpi)),
                ),
                Image.Resampling.BICUBIC,
            )
            crop_im = crop_im.filter(ImageFilter.UnsharpMask(1, 20, 8))
        if BumpVibrance:
            with open(os.path.join(os.path.dirname(__file__), "vibrance.CUBE")) as f:
                lut_raw = f.read().splitlines()[11:]
            lsize = round(len(lut_raw) ** (1 / 3))
            row2val = lambda row: tuple([float(val) for val in row.split(" ")])
            lut_table = [row2val(row) for row in lut_raw]
            lut = ImageFilter.Color3DLUT(lsize, lut_table)
            crop_im = crop_im.filter(lut)
        crop_filename = os.path.join(tempdir, img_file)
        crop_im.save(crop_filename, quality=100)
        print("Writing cropped file {}".format(crop_filename))
        return (image,crop_filename)



def my_cropper(images, tempdir, MaxDPI=1200, MultiThread=True, BumpVibrance=False, InPlace=False):
    data = []
    for image in images:
        data.append((image,tempdir,MaxDPI,BumpVibrance,InPlace))

    if MultiThread:
        with Pool() as pool:
            results = pool.map(the_cropper, data)
    else:
        results = []
        for d in data:
            results.append(the_cropper(d))

    if InPlace:
        os.system("sync")
        time.sleep(5)
        os.system("sync")
        failed_copies = []
        for image, crop_filename in results:
            print("Replacing file {} with cropped {}".format(image,crop_filename))
            try:
                shutil.copy(crop_filename, image)
            except:
                print("!!! Failed {}".format(image))
                failed_copies.append((image,crop_filename))
                continue

        # I think I was doing something weird and thought this was
        # neccesary, but it likely isn't.
        os.system("sync")
        time.sleep(5)
        os.system("sync")

        fucked_copies = []
        for image, crop_filename in failed_copies:
            try:
                # with Image.open(image) as dst:
                with Image.open(crop_filename) as src:
                    src.save(image, quality=100)
            except:
                fucked_copies.append((image,crop_filename))
                continue

        for image, crop_filename in fucked_copies:
            print("!!! BAD: {}".format(image))
            # shutil.move(crop_filename, image)



if __name__ == "__main__":

    # TEST_RUN=True
    # if TEST_RUN:
    #     found_files = find_images('../mana_rocks_normal')
    #     if found_files:
    #         for file_path in found_files:
    #             print(file_path)
    #             shutil.copy(file_path,os.path.join('images',os.path.basename(file_path)))

    search_dir = "."  # Current directory
    temp_dir = create_unique_temp_dir()
    found_files = find_images(search_dir)
    if found_files:
        print("Cropping files:")
        for file_path in found_files:
            print(file_path)
        my_cropper(found_files, temp_dir, InPlace=True)
    else:
        print("No files found")


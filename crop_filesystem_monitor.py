from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import os
import time
from PIL import Image, ImageFilter
from multiprocessing import Process, Queue
import multiprocessing

class NewFileHandler(FileSystemEventHandler):
    def __init__(self):
        self.queue = Queue()
        # Start the process pool
        self.pool = multiprocessing.Pool()

    def on_created(self, event):
        if event.is_directory:
            return
        
        # Get the path of the new file
        file_path = event.src_path
        print(f"New file detected: {file_path}")

        process = Process(target=self.process_new_file, args=(file_path,))
        process.start()

        #self.process_new_file(file_path)

    def process_new_file(self, file_path):
        file_size = os.path.getsize(file_path)
        if (file_path.lower().endswith('.png') or
            file_path.lower().endswith('.jpg') or
            file_path.lower().endswith('.jpeg')):
            print(f"Processing file: {file_path}")
            print(f"File size: {file_size} bytes")
            self.the_cropper(file_path)
        else:
            print(f"Skipping file: {file_path}")

    def the_formatter(self, image, destdir='/home/msnook/cards/trimmed_images/00AA_NEW', MaxDPI=1200, BumpVibrance=False):
        with Image.open(image) as im:
            base_filename = '{}.png'.format(os.path.splitext(image)[0])
            crop_filename = os.path.join(destdir, base_filename)
            if im.mode == 'CMYK':
                im = im.convert('RGB')
            im.save(crop_filename, quality=100, format="PNG")
            return image, crop_filename

    def the_cropper(self,image, destdir='/home/msnook/cards/trimmed_images/00AA_NEW', MaxDPI=1200, BumpVibrance=False):
        print(f"Cropping file: {image}")
        with Image.open(image) as im:
            img_file = os.path.basename(image)
            if im.mode == 'CMYK':
                im = im.convert('RGB')
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
            base_filename = '{}.png'.format(os.path.splitext(img_file)[0])
            crop_filename = os.path.join(destdir, base_filename)
            crop_im.save(crop_filename, quality=100,format="PNG" )
            print("Writing cropped file {}".format(crop_filename))
            return image,crop_filename

def monitor_directory(path):
    # Initialize event handler and observer
    event_handler = NewFileHandler()
    observer = Observer()

    # Schedule the observer to watch the specified directory
    observer.schedule(event_handler, path, recursive=False)
    
    # Start the observer
    observer.start()
    print(f"Started monitoring directory: {path}")
    
    try:
        # Keep the script running
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        print("\nMonitoring stopped")
    
    observer.join()

if __name__ == "__main__":
    # Specify the directory to monitor
    directory_to_monitor = "/home/msnook/cards/print-proxy-prep/images"  # Current directory
    monitor_directory(directory_to_monitor)
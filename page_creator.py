import numpy as np
from PIL import Image
import time
from typing import List

def resize_image(img_path):
    desired_dpi = 600
    chin = 88 / 25.4  # converting mm to inches
    desired_height_pixels = int(chin * desired_dpi)

    # Open and convert image to RGB
    img = Image.open(img_path).convert('RGB')

    # Calculate new width while maintaining aspect ratio
    ratio = desired_height_pixels / img.size[1]
    new_width = int(img.size[0] * ratio)

    # Resize using Lanczos resampling
    img_resized = img.resize((new_width, desired_height_pixels), Image.Resampling.LANCZOS)

    # Convert to numpy array for further processing
    rv = np.array(img_resized)

    if rv.shape[1] < 1490:
        # Pad the image if it's smaller than required width
        padding = ((0, 0), (0, 1490 - rv.shape[1]), (0, 0))
        rv = np.pad(rv, padding, mode='edge')
    elif rv.shape[1] > 1490:
        raise ValueError('You probably forgot to trim them dummy')

    return rv

def draw_line(img, start_pos, end_pos):
    start_x, start_y = start_pos
    end_x, end_y = end_pos

    # Draw black line
    img[start_y:end_y+1, start_x] = [0, 0, 0]
    img[start_y, start_x:end_x+1] = [0, 0, 0]

def draw_cutlines(full_card_page):
    cf = 20
    result = full_card_page.copy()

    # # Vertical lines
    # for e in [316, 1806, 3296, 4785]:
    #     draw_line(result, (e, 1), (e, 182-cf))
    #     draw_line(result, (e, 6419+cf), (e, full_card_page.shape[0]-1))
    #
    # # Horizontal lines
    # for e in [184, 2262, 4340, 6417]:
    #     draw_line(result, (1, e), (314-cf, e))
    #     draw_line(result, (4787+cf, e), (full_card_page.shape[1]-1, e))


    for e in [315, 1805, 3295, 4784]:
        draw_line(result, (e, 1), (e, 182-cf))
        draw_line(result, (e, 6418+cf), (e, full_card_page.shape[0]-1))

    # Horizontal lines
    for e in [183, 2261, 4339, 6416]:
        draw_line(result, (1, e), (314-cf, e))
        draw_line(result, (4786+cf, e), (full_card_page.shape[1]-1, e))

    return result

# def margin_cutlines(x):
#     x[:, 315]  = [0, 0, 0]
#     x[:, 1805] = [0, 0, 0]
#     x[:, 3295] = [0, 0, 0]
#     x[:, 4784] = [0, 0, 0]
#     x[183, :]  = [0, 0, 0]
#     x[2261, :] = [0, 0, 0]
#     x[4339, :] = [0, 0, 0]
#     x[6416, :] = [0, 0, 0]
#     return x

def alpha_cutlines(x):
    x[:, 315]  = 1
    x[:, 1805] = 1
    x[:, 3295] = 1
    x[:, 4784] = 1
    x[183, :]  = 1
    x[2261, :] = 1
    x[4339, :] = 1
    x[6416, :] = 1
    return x

def print_cards(filelist: List[str], outfilename: str):
    # Input validation
    assert isinstance(filelist, list)
    assert len(filelist) == 9
    assert all(isinstance(f, str) for f in filelist)
    assert isinstance(outfilename, str)

    # Read and resize images
    start_time = time.time()
    resize_cards = [resize_image(f) for f in filelist]
    print(f"Reading and resizing images: {time.time() - start_time:.2f} seconds")

    # Arrange into 3x3 grid
    cards_resized = [[None]*3 for _ in range(3)]
    for i in range(3):
        for j in range(3):
            cards_resized[i][j] = resize_cards[i*3 + j]

    # Combine into single image
    start_time = time.time()
    card_page = np.vstack([np.hstack(row) for row in cards_resized])
    print(f"Combining images: {time.time() - start_time:.2f} seconds")

    # Calculate margins and padding
    bleed_edge = 18
    dpi = 600
    paper_width = 8.5
    paper_height = 11
    pwidth = int(paper_width * dpi)
    pheight = int(paper_height * dpi)

    cps = card_page.shape
    wmargin = int((pwidth - cps[1])/2 - bleed_edge)
    hmargin = int((pheight - cps[0])/2 - bleed_edge)

    # Add padding
    full_card_page = np.pad(card_page, ((bleed_edge, bleed_edge),
                                        (bleed_edge, bleed_edge),
                                        (0, 0)), mode='edge')

    alpha_channel = np.ones((full_card_page.shape[0], full_card_page.shape[1]))


    alpha_channel = np.pad(alpha_channel, ((hmargin, hmargin),
                                           (wmargin, wmargin)),
                           constant_values=0)

    full_card_page = np.pad(full_card_page, ((hmargin, hmargin),
                                             (wmargin, wmargin),
                                             (0, 0)),
                            constant_values=255)

    # Draw cut lines
    start_time = time.time()
    full_card_page_with_cutlines = draw_cutlines(full_card_page)

    print(f"Drawing cut lines: {time.time() - start_time:.2f} seconds")

    start_time = time.time()
    alpha_channel_with_cutlines = alpha_cutlines(alpha_channel)
    print(f"Drawing alpha cut lines: {time.time() - start_time:.2f} seconds")

    # Save image

    img = Image.fromarray(full_card_page_with_cutlines)
    alpha = Image.fromarray((alpha_channel_with_cutlines * 255).astype('uint8'))

    img = img.convert('RGBA')
    # Apply the alpha channel
    r, g, b, _ = img.split()
    img = Image.merge('RGBA', (r, g, b, alpha))

    # Image.putalpha(alpha_channel_with_cutlines)
    # Image.fromarray(full_card_page_with_cutlines).save(outfilename,
    #                                                    format='PNG',
    #                                                    optimize=True)
    img.save(outfilename, format='PNG', optimize=True)
    start_time = time.time()


    print(f"Saving image: {time.time() - start_time:.2f} seconds")

    return 1

if __name__ == "__main__":
    filelist = [
        'good_spells/Force of Negation (Borderless Greg Hildebrandt) (1GWRR5cB7EYVulP6ZqzHGkqSJ-v5dGrHc).jpg',
        'good_spells/Fierce Guardianship (Borderless Randy Gallegos) (1Ya0sn7UH_tQjuY2AkKxzkITItPt5deMP).jpg',
        'good_spells/Force of Will (Borderless Matt Stewart) (1SIJ2Wq81KCQWOB6NvLKPCXyRpOLkpe5H).jpg',
        'good_spells/Commandeer [OTP] {9} (1gHghyAAArF7rCIWKD7aLqVPo8eLYyqiI).jpg',
        'good_spells/Mental Misstep (1sjj1xQiG2iR9O6rKVzf10IX0bgqb6zOm).png',
        'good_spells/Pongify (17zSEzaYBNUzL02_Toh0oLYYJvenyxXPE).jpg',
        'mana_rocks_again/Mox Diamond (Borderless Alt) [STH] {138} (1KQSf9RXtGSDK8DNGckDZdWo_L4eN4Ifa).jpg',
        'mana_rocks_again/Mana Vault (1iDgtmXV81507pA_dnjCOwV5LjseVDM1c).png',
        'mana_rocks_again/Lotus Petal (Borderless Slawomir Maniak) (1so5h5i4RTp924CUk6Q1_3-b3MYodswGE).jpg'
    ]

    filepaths = []
    for f in filelist:
        filepaths.append('../trimmed_images/{}'.format(f))

    print_cards(filepaths, 'test.png')

clc

filelist{1} = '/home/msnook/cards/trimmed_images/deadpool/Chaos Warp (STA) (104wkjtVNfgfiIDt2OvTKeUQQNIsnhA_E).jpg';
filelist{2} = '/home/msnook/cards/trimmed_images/deadpool/Braids, Arisen Nightmare (Midjourney) (1s34j7A_l2EqwhbBturTuCulKV59hd39m).jpg';
filelist{3} = '/home/msnook/cards/trimmed_images/deadpool/Cursed Mirror {226} (1Xz0pW2tYM8YWkgqhUatBsMWwYbTE1Ky8).jpg';
filelist{4} = '/home/msnook/cards/trimmed_images/deadpool/Delina, Wild Mage (1WvNl0VaX5CGfnjxUjAWCxRrw3wCvSTNI).png';
filelist{5} = '/home/msnook/cards/trimmed_images/deadpool/Flare of Duplication (1BtapdfXEzs2xzxUrG8PfInZJZfEazupE).png';
filelist{6} = '/home/msnook/cards/trimmed_images/deadpool/Dualcaster Mage (1upDTyLl-d8TdjW-da4kwXBgKHTjLVhJc).png';
filelist{7} = '/home/msnook/cards/trimmed_images/deadpool/Gamble {188} (17OcCZJS-ZL1ixIzzlrG_XVUT5uGbgxS_).png';
filelist{8} = '/home/msnook/cards/trimmed_images/deadpool/The Fire Crystal (11VPGn2Ej36SSc_ZY2W-5Nq6pQ3Ajl8yx).png';
filelist{9} = '/home/msnook/cards/trimmed_images/deadpool/Mayhem Devil {1715} (1zFw7Cg7ZU-3lRzHG-5poPBWcDpw3aDDp).png';

%/home/msnook/cards/trimmed_images/deadpool/The Fire Crystal (11VPGn2Ej36SSc_ZY2W-5Nq6pQ3Ajl8yx).png

cards = cell(3,3);
cards{1,1} = filelist{1};
cards{1,2} = filelist{2};
cards{1,3} = filelist{3};
cards{2,1} = filelist{4};
cards{2,2} = filelist{5};
cards{2,3} = filelist{6};
cards{3,1} = filelist{7};
cards{3,2} = filelist{8};
cards{3,3} = filelist{9};

card_images = cell(3,3);
for i=1:size(card_images,1)
    for j=1:size(card_images,2)
        card_images{i,j} = imread(cards{i,j});
    end
end

%%

x = card_images{1,1};

sz = size(x);

aspect_ratio = sz(1) / sz(2)
sz(2)/sz(1)

% c = round(0.12 * min(w / 2.72, h / 3.7))
% dpi = c * (1 / 0.12)

% 100 2800 2600 3800



x = insertShape(x, 'filled-rectangle',roi, 'Color', 'b');
imshow(x)


% full_card_page_with_cutlines = insertShape(full_card_page, 'rectangle', [e 1 e 182-cf], 'Color', 'k');

%%
ocrResults = ocr(x)

%%

roi = [100 2600 2800 1200];

x = card_images{1,1};

as = size(x);
ch = as(1);
cw = as(2);
card_height_pixels = ch;
card_width_pixels = cw;
card_width_mm = 63;
card_height_mm = 88;
mm_per_inch = 25.4;
card_height_inches = card_height_mm / mm_per_inch;
card_width_inches = card_width_mm / mm_per_inch;
card_height_dpi = card_height_pixels / card_height_inches;
card_width_dpi = card_width_pixels / card_width_inches;
card_current_dpi = fix(min(card_height_dpi,card_width_dpi));
desired_dpi = 600;
desired_height_pixels = fix(chin * desired_dpi);
desired_width_pixels = fix(cwin * desired_dpi);

roi_1200dpi = [100 2600 2700 1200];

ocrResults = ocr(x,roi_1200dpi)

%%
ocrResults.Text

ocrResults.TextLines
ocrResults.TextLineBoundingBoxes
x = card_images{1,1};

for k=1:size(ocrResults.TextLineBoundingBoxes,1)-1
    ocrResults.TextLineBoundingBoxes(k,:)
    x = insertShape(x, 'filled-rectangle',ocrResults.TextLineBoundingBoxes(k,:));
    imshow(x);
    pause

end

imshow(x)


%%

% Should probably just use smart sharpen... this kind of sucks.

bb = ocrResults.TextLineBoundingBoxes(2,:);


xmin = bb(1);
ymin = bb(2);
width = bb(3);
height = bb(4);
row_indices = ymin : (ymin + height - 1);
col_indices = xmin : (xmin + width - 1);

figure(1);
imshow(x(row_indices,col_indices))

figure(2);
sharpened_region = imsharpen(x(row_indices,col_indices))
imshow(sharpened_region)



% sharpened_region = imsharpen()


% imshow(x)

% x = insertShape(x, 'filled-rectangle',roi, 'Color', 'b');
% imshow(x)





%%
x = card_images{1,1};
resized_card = resize_image(x);
roi_dpi_ratio = desired_dpi / 1200;

resized_card = insertShape(resized_card, 'filled-rectangle',roi_dpi_ratio*roi, 'Color', 'b');
imshow(resized_card)



% recognizedText = ocrResults.Text;    
% figure
% imshow(x)



% current_

% chin = 88 / 25.4;
% desired_height_pixels = fix(chin * desired_dpi)
% cwin = 63 / 25.4; 

% text(600,150,recognizedText,BackgroundColor=[1 1 1]);


% desired_dpi = 600;
% chin = 88 / 25.4;
% desired_height_pixels = fix(chin * desired_dpi)
% cwin = 63 / 25.4; 
% as = size(x);
% ch = as(1);
% cw = as(2);
% card_height_pixels = ch;
% card_width_pixels = cw;
% desired_width_pixels = fix(cwin * desired_dpi);
% height_scale = card_height_pixels / desired_height_pixels;
% width_scale = card_width_pixels / desired_width_pixels;

%%


function [rv] = printCards(filelist,outfilename)


if length(filelist) ~= 9
    error('Need a full page dummy.')
end

cards = cell(3,3);
cards{1,1} = filelist{1};
cards{1,2} = filelist{2};
cards{1,3} = filelist{3};
cards{2,1} = filelist{4};
cards{2,2} = filelist{5};
cards{2,3} = filelist{6};
cards{3,1} = filelist{7};
cards{3,2} = filelist{8};
cards{3,3} = filelist{9};




card_images = cell(3,3);
for i=1:size(card_images,1)
    for j=1:size(card_images,2)
        card_images{i,j} = imread(cards{i,j});
    end
end

cards_resized = cell(3,3);
for i=1:size(card_images,1)
    for j=1:size(card_images,2)
        cards_resized{i,j} = resize_image(card_images{i,j});
    end
end

card_page = cell2mat(cards_resized);

bleed_edge = 18;
dpi = 600;
paper_width = 8.5;
paper_height = 11;
pwidth = paper_width * dpi;
pheight = paper_height * dpi;

cps = size(card_page);
wmargin = (pwidth - cps(2))/2  - bleed_edge;
hmargin = (pheight - cps(1))/2 - bleed_edge;
full_card_page = padarray(card_page,[bleed_edge, bleed_edge, 0],'replicate','both');
alpha_channel = ones(size(full_card_page,1),size(full_card_page,2));
alpha_channel = padarray(alpha_channel,[hmargin, wmargin, 0],0,'both');
full_card_page = padarray(full_card_page,[hmargin, wmargin, 0],255,'both');


full_card_page_with_cutlines = draw_cutlines(full_card_page);
alpha_channel_with_cutlines = alpha_cutlines(alpha_channel);


% after_shenanigans = full_card_page_with_cutlines(hmargin+bleed_edge+1:end-bleed_edge-hmargin,wmargin+bleed_edge+1:end-wmargin-bleed_edge,:);
% im_eq = after_shenanigans == card_page;
% if ~all(all(im_eq))
%     fprintf('Error in card generation!');
% end

% filename = sprintf('/home/msnook/sambashare/%s','card_page2.png');


imwrite(full_card_page_with_cutlines,outfilename, 'Alpha', alpha_channel_with_cutlines)


% fprintf('done')
% figure(2);
% imshow(full_card_page_with_cutlines)

rv = 1;


end

function [x] = alpha_cutlines(x)
    x(:,316) = 1;
    x(:,1806) = 1;    
    x(:,3296) = 1;
    x(:,4785) = 1;
    x(184,:) = 1;
    x(2262,:) = 1;
    x(4340,:) = 1;
    x(6417,:) = 1;
end

function [rv] = draw_cutlines(full_card_page)
    sz = size(full_card_page);
    % endx = min(sz(1), sz(2));
    cf = 20;
    e = 316;
    full_card_page_with_cutlines = insertShape(full_card_page, 'Line', [e 1 e 182-cf], 'Color', 'k');
    e = 1806;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182-cf], 'Color', 'k');
    e = 3296 ;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182-cf], 'Color', 'k');
    e = 4785 ;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182-cf], 'Color', 'k');
    
    e = 316;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419+cf e sz(1)], 'Color', 'k');
    e = 1806;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419+cf e sz(1)], 'Color', 'k');
    e = 3296 ;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419+cf e sz(1)], 'Color', 'k');
    e = 4785 ;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419+cf e sz(1)], 'Color', 'k');
    
    e = 184;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314-cf e], 'Color', 'k');
    e = 2262;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314-cf e], 'Color', 'k');
    e = 4340;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314-cf e], 'Color', 'k');
    e = 6417;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314-cf e], 'Color', 'k');

    e = 184;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787+cf e sz(1) e], 'Color', 'k');
    e = 2262;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787+cf e sz(1) e], 'Color', 'k');
    e = 4340;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787+cf e sz(1) e], 'Color', 'k');
    e = 6417;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787+cf e sz(1) e], 'Color', 'k');
    
    rv = full_card_page_with_cutlines;
end


function [rv] = resize_image(x)
    desired_dpi = 600;
    chin = 88 / 25.4;
    desired_height_pixels = fix(chin * desired_dpi)

    rv = imresize(x,'Method','lanczos3','OutputSize',[desired_height_pixels, NaN]);

    size(rv)
    if size(rv,2) < 1490
        rv = padarray(rv,[0, 1490 - size(rv,2), 0],'replicate','post');
    elseif size(rv,2) > 1490
        imshow(x)
        error('you probably forgot to trim them dummy')
    end
    % cwin = 63 / 25.4; 
    % as = size(x);
    % ch = as(1);
    % cw = as(2);
    % card_height_pixels = ch;
    % card_width_pixels = cw;
    % desired_width_pixels = fix(cwin * desired_dpi);
    % height_scale = card_height_pixels / desired_height_pixels;
    % width_scale = card_width_pixels / desired_width_pixels;
end

function [row_indices, col_indices] = bb_to_index(bb)
    xmin = bb(1);
    ymin = bb(2);
    width = bb(3);
    height = bb(4);
    row_indices = ymin : (ymin + height - 1);
    col_indices = xmin : (xmin + width - 1);
end
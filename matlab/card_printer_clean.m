
cards = cell(3,3);

cards{1,1} = 'good_spells/Force of Negation (Borderless Greg Hildebrandt) (1GWRR5cB7EYVulP6ZqzHGkqSJ-v5dGrHc).jpg';
cards{1,2} = 'good_spells/Fierce Guardianship (Borderless Randy Gallegos) (1Ya0sn7UH_tQjuY2AkKxzkITItPt5deMP).jpg';
cards{1,3} = 'good_spells/Force of Will (Borderless Matt Stewart) (1SIJ2Wq81KCQWOB6NvLKPCXyRpOLkpe5H).jpg';
cards{2,1} = 'good_spells/Commandeer [OTP] {9} (1gHghyAAArF7rCIWKD7aLqVPo8eLYyqiI).jpg';
cards{2,2} = 'good_spells/Mental Misstep (1sjj1xQiG2iR9O6rKVzf10IX0bgqb6zOm).png';
cards{2,3} = 'good_spells/Pongify (17zSEzaYBNUzL02_Toh0oLYYJvenyxXPE).jpg';
cards{3,1} = 'mana_rocks_again/Mox Diamond (Borderless Alt) [STH] {138} (1KQSf9RXtGSDK8DNGckDZdWo_L4eN4Ifa).jpg';
cards{3,2} = 'mana_rocks_again/Mana Vault (1iDgtmXV81507pA_dnjCOwV5LjseVDM1c).png';
cards{3,3} = 'mana_rocks_again/Lotus Petal (Borderless Slawomir Maniak) (1so5h5i4RTp924CUk6Q1_3-b3MYodswGE).jpg';


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
figure(1);
imshow(card_page)

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


% full_card_page_with_cutlines = full_card_page;



size(card_page)
size(after_shenanigans)


full_card_page_with_cutlines = draw_cutlines(full_card_page);
alpha_channel_with_cutlines = alpha_cutlines(alpha_channel);

after_shenanigans = full_card_page_with_cutlines(hmargin+bleed_edge+1:end-bleed_edge-hmargin,wmargin+bleed_edge+1:end-wmargin-bleed_edge,:);

im_eq = after_shenanigans == card_page;
all(all(im_eq))



filename = sprintf('/home/msnook/sambashare/%s','card_page2.png');
imwrite(full_card_page_with_cutlines,filename, 'Alpha', alpha_channel_with_cutlines)


fprintf('done')
figure(2);
imshow(full_card_page_with_cutlines)

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
    desired_height_pixels = fix(chin * desired_dpi); 
    rv = imresize(x,'Method','lanczos3','OutputSize',[desired_height_pixels, NaN]);
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
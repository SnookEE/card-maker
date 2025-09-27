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


imwrite(full_card_page_with_cutlines,outfilename, ...
    'Alpha', alpha_channel_with_cutlines,"Quality",100);

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
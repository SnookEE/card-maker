function [rv] = printCards1200(filelist,outfilename)

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

for j=1:size(card_images,2)
    cards_resized{2,j} = padarray(cards_resized{2,j},[1, 0, 0],'replicate','pre');
end
% for j=1:size(card_images,2)
%     cards_resized{3,j} = padarray(cards_resized{3,j},[1, 0, 0],'replicate','pre');
% end

card_page = cell2mat(cards_resized);

bleed_edge = 36;
dpi = 1200;
paper_width = 8.5;
paper_height = 11;
pwidth = paper_width * dpi;
pheight = paper_height * dpi;

cps = size(card_page);
wmargin = fix((pwidth - cps(2))/2  - bleed_edge);
hmargin = fix((pheight - cps(1))/2 - bleed_edge);

full_card_page = padarray(card_page,[bleed_edge, bleed_edge, 0],'replicate','both');

alpha_channel = ones(size(full_card_page,1),size(full_card_page,2));
alpha_channel = padarray(alpha_channel,[hmargin, wmargin, 0],0,'both');
full_card_page = padarray(full_card_page,[hmargin, wmargin, 0],255,'both');

full_card_page_with_cutlines = draw_cutlines(full_card_page);
alpha_channel_with_cutlines = alpha_cutlines(alpha_channel);

imwrite(full_card_page_with_cutlines,outfilename, ...
    'Alpha', alpha_channel_with_cutlines); %,'Quality',100);

rv = 1;

end

function [x] = alpha_cutlines(x)
    x(:,631) = 1;
    x(:,3610) = 1;    
    x(:,6590) = 1;
    x(:,9568) = 1;
    x(:,632) = 1;
    x(:,3611) = 1;    
    x(:,6591) = 1;
    x(:,9569) = 1;
    x(367,:) = 1;
    x(4521,:) = 1;
    x(8679,:) = 1;
    x(12833,:) = 1;
    x(368,:) = 1;
    x(4522,:) = 1;
    x(8680,:) = 1;
    x(12834,:) = 1;
end

function [rv] = draw_cutlines(full_card_page)
    sz = size(full_card_page);
    % endx = min(sz(1), sz(2));
    cf = 20*2;

    e = 631;
    full_card_page_with_cutlines = insertShape(full_card_page, 'Line', [e 1 e 182*2-cf], 'Color', 'k');
    e = 3610;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182*2-cf], 'Color', 'k');
    e = 6590;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182*2-cf], 'Color', 'k');
    e = 9568;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182*2-cf], 'Color', 'k');
    
    e = 632;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182*2-cf], 'Color', 'k');
    e = 3611;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182*2-cf], 'Color', 'k');
    e = 6591;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182*2-cf], 'Color', 'k');
    e = 9569;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 1 e 182*2-cf], 'Color', 'k');
    
    e = 631;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419*2+cf e sz(1)], 'Color', 'k');
    e = 3610;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419*2+cf e sz(1)], 'Color', 'k');
    e = 6590;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419*2+cf e sz(1)], 'Color', 'k');
    e = 9568;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419*2+cf e sz(1)], 'Color', 'k');

    e = 632;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419*2+cf e sz(1)], 'Color', 'k');
    e = 3611;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419*2+cf e sz(1)], 'Color', 'k');
    e = 6591;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419*2+cf e sz(1)], 'Color', 'k');
    e = 9569;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [e 6419*2+cf e sz(1)], 'Color', 'k');


    e = 367;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314*2-cf e], 'Color', 'k');
    e = 4521;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314*2-cf e], 'Color', 'k');
    e = 8679;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314*2-cf e], 'Color', 'k');
    e = 12833;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314*2-cf e], 'Color', 'k');


    e = 368;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314*2-cf e], 'Color', 'k');
    e = 4522;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314*2-cf e], 'Color', 'k');
    e = 8680;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314*2-cf e], 'Color', 'k');
    e = 12834;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [1 e 314*2-cf e], 'Color', 'k');


    e = 367;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787*2+cf e sz(1) e], 'Color', 'k');
    e = 4521;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787*2+cf e sz(1) e], 'Color', 'k');
    e = 8679;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787*2+cf e sz(1) e], 'Color', 'k');
    e = 12833;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787*2+cf e sz(1) e], 'Color', 'k');
    

    e = 368;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787*2+cf e sz(1) e], 'Color', 'k');
    e = 4522;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787*2+cf e sz(1) e], 'Color', 'k');
    e = 8680;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787*2+cf e sz(1) e], 'Color', 'k');
    e = 12834;
    full_card_page_with_cutlines = insertShape(full_card_page_with_cutlines, 'Line', [4787*2+cf e sz(1) e], 'Color', 'k');
    
    rv = full_card_page_with_cutlines;
end


function [rv] = resize_image(x)
    desired_dpi = 1200;
    chin = 88 / 25.4;
    desired_height_pixels = fix(chin * desired_dpi);
    rv = imresize(x,'Method','lanczos3','OutputSize',[desired_height_pixels, NaN]);

    size(rv)
    if size(rv,2) < 2980
        rv = padarray(rv,[0, 2980 - size(rv,2), 0],'replicate','post');
    elseif size(rv,2) > 2980
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
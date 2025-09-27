
filelist{1} = 'mana_rocks_again/Arcane Signet {1641} (1pAiGPAuIE00q4Vg8W-mZAUMHttgqsYXm).png';
filelist{2} = 'mana_rocks_again/Lion''s Eye Diamond [VMA] {271} (1tb1FbWMpW11Dx79qlOn5KzBlM9CaPIR2).jpg';
filelist{3} = 'mana_rocks_again/Sol Ring (Borderless Alt) [CMM] {703} (1_jbzpOYFBrb6HY5puo2g4bRhpE1ogk_m).jpg';

filelist{4} = 'mana_rocks_again/Mana Vault (Borderless Kirsten Zirngibl) (1olcrwrlxt1rFpu6revuclh8ULk0Lwgpy).jpg';
filelist{5} = 'mana_rocks_again/Lotus Petal (Borderless Slawomir Maniak) (1so5h5i4RTp924CUk6Q1_3-b3MYodswGE).jpg';
filelist{6} = 'mana_rocks_again/Mox Opal (Showcase Chris Rahn) (12D5v7J20CI0aNsS9cHuX20nZU1skvHNS).jpg';

filelist{7} = 'mana_rocks_again/Mox Diamond (Borderless Alt) [STH] {138} (1KQSf9RXtGSDK8DNGckDZdWo_L4eN4Ifa).jpg';
filelist{8} = 'mana_rocks_again/Mana Vault (Borderless Kirsten Zirngibl) (1olcrwrlxt1rFpu6revuclh8ULk0Lwgpy).jpg';
filelist{9} = 'mana_rocks_again/Lotus Petal (Borderless Slawomir Maniak) (1so5h5i4RTp924CUk6Q1_3-b3MYodswGE).jpg';

for i=1:length(filelist)
    filelist{i} = sprintf('%s/%s','/home/msnook/cards/trimmed_images/',filelist{i});
end

if length(filelist) ~= 9
    error('Need a full page dummy.')
end

% cards = cell(3,3);
% cards{1,1} = filelist{1};
% cards{1,2} = filelist{2};
% cards{1,3} = filelist{3};
% cards{2,1} = filelist{4};
% cards{2,2} = filelist{5};
% cards{2,3} = filelist{6};
% cards{3,1} = filelist{7};
% cards{3,2} = filelist{8};
% cards{3,3} = filelist{9};

fileIndex = 1;
card_images = cell(2,4);
for i=1:size(card_images,1)
    for j=1:size(card_images,2)
        card_images{i,j} = imread(filelist{fileIndex});
        fileIndex = fileIndex + 1;
    end
end
ct = imread('cutting_template.png');


for i=1:size(card_images,1)
    for j=1:size(card_images,2)
        card_images{i,j} = padarray(card_images{i,j},[30, 30, 0],'replicate','both');
    end
end


card_page = cell2mat(card_images);

long_edges = [246, 1286, 1296, 2336];
short_edges = [141,885,900,1644,1659,2403,2418,3162];
bleed_edge = 36;
dpi = 1200;
paper_width = 8.5;
paper_height = 11;
plong = paper_width * dpi;
pshort = paper_height * dpi;

ct1200 = imresize(ct,'Method','lanczos3','OutputSize',[pshort, plong],'Antialiasing',true);
ct1200 = imrotate90(ct1200);

rshift = 50;
cshift = 0;
rmargin = fix((size(ct1200,1) - size(card_page,1))/2);
cmargin = fix((size(ct1200,2) - size(card_page,2))/2);
full_card_page = padarray(card_page,[rmargin-rshift, cmargin-cshift, 0],255,'pre');
full_card_page = padarray(full_card_page,[rmargin+rshift, cmargin+cshift, 0],255,'post');
% full_card_page = padarray(card_page,[rmargin, cmargin, 0],255,'both');

alpha_channel = ones(size(card_page,1),size(card_page,2));
alpha_channel = padarray(alpha_channel,[rmargin-rshift, cmargin-cshift, 0],0,'pre');
alpha_channel = padarray(alpha_channel,[rmargin+rshift, cmargin+cshift, 0],0,'post');

gs_ct1200 = rgb2gray(ct1200);
mask = gs_ct1200;
mask = mask > 200;
mask = mask==0;
both = imblend(gs_ct1200,full_card_page,mask);
figure(3)
imshow(both)

% figure(1);
% imshow(full_card_page)
% 
% figure(2);
% imshow(gs_ct1200)

%%


% x = imhline(both,472);
% x = imhline(x,1416);
% x = imhline(x,8785);
% x = imhline(x,9728);

% x = imvline(x,473);
% x = imvline(x,1417);
% x = imvline(x,11785);
% x = imvline(x,12730);

% figure(3)
% imshow(x)

%%

% x = insertShape(both, 'Line', [472 11789  472 12730] , 'Color', 'r');
% x = insertShape(x, 'Line', [x 1 x size(im,1)] , 'Color', 'k');

% x = addRegistrationMarks(both);

alpha_channel_reg_marks = alpha_registration_marks(alpha_channel);

full_card_page_reg_marks = addRegistrationMarks(full_card_page);

figure(3)
imshow(alpha_channel_reg_marks)

%
filename = sprintf('/home/msnook/sambashare/%s','card_page2.png')

imwrite(full_card_page_reg_marks,filename, 'Alpha', alpha_channel_reg_marks)

fprintf('done\n');


function [x] = alpha_registration_marks(x)
    x(472-14:1416,473-14:473+14) = 1;
    x(472-14:1416,12730-14:12730+14) = 1;
    x(472-14:472+14,473:1417) = 1;
    x(472-14:472+14,11785:12730) = 1;
    x(8785:9728+14,473-14:473+14) = 1;
    x(8785:9728+14,12730-14:12730+14) = 1;
    x(9728-14:9728+14,473:1417) = 1;
    x(9728-14:9728+14,11785:12730) = 1;
end


function rv = addRegistrationMarks(x)
    x = insertShape(x, 'Line', [473 472 1417 472] , 'Color', 'k','LineWidth',28);
    x = insertShape(x, 'Line', [11785 472 12730 472] , 'Color', 'k','LineWidth',28);
    x = insertShape(x, 'Line', [473 472-14 473 1416] , 'Color', 'k','LineWidth',28);
    x = insertShape(x, 'Line', [473 8785 473 9728+14] , 'Color', 'k','LineWidth',28);
    x = insertShape(x, 'Line', [12730 472-14 12730 1416] , 'Color', 'k','LineWidth',28);
    x = insertShape(x, 'Line', [12730 8785 12730 9728+14] , 'Color', 'k','LineWidth',28);
    x = insertShape(x, 'Line', [473 9728 1417 9728] , 'Color', 'k','LineWidth',28);
    x = insertShape(x, 'Line', [11785 9728 12730 9728] , 'Color', 'k','LineWidth',28);
    rv = x;
end


function rv = imrotate90(im)
    rv = permute(im,[2 1 3]);
    rv = flipud(rv);
end

function rv = imhline(im,x)
rv = insertShape(im, 'Line', [1 x size(im,2) x] , 'Color', 'k','LineWidth',28);
end


function rv = imvline(im,x)
rv = insertShape(im, 'Line', [x 1 x size(im,1)] , 'Color', 'k','LineWidth',28);
end

card_height_pixels = 680;
card_width_pixels = 480;


desired_dpi = 600;
cwin = 63 / 25.4; 
chin = 88 / 25.4;

height_dpi = card_height_pixels / chin
width_dpi = card_width_pixels / cwin


    % desired_height_pixels = fix(chin * desired_dpi); 
    % rv = imresize(x,'Method','lanczos3','OutputSize',[desired_height_pixels, NaN]);
    % 
    % as = size(x);
    % ch = as(1);
    % cw = as(2);
    % card_height_pixels = ch;
    % card_width_pixels = cw;
    % desired_width_pixels = fix(cwin * desired_dpi);
    % height_scale = card_height_pixels / desired_height_pixels;
    % width_scale = card_width_pixels / desired_width_pixels;

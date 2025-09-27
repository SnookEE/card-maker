
clc
bleed_edge = 36;
dpi = 1200;
paper_width = 8.5;
paper_height = 11;
pwidth = paper_width * dpi
pheight = paper_height * dpi

card_width_in = 63 / 25.4
card_height_in = 88 / 25.4
% as = size(x);
% ch = as(1);
% cw = as(2);
% card_height_pixels = ch;
% card_width_pixels = cw;
desired_dpi = 1200
card_height_pixels = fix(card_height_in * desired_dpi)
card_width_pixels = fix(card_width_in * desired_dpi)



% height_scale = card_height_pixels / desired_height_pixels;
% width_scale = card_width_pixels / desired_width_pixels;

pwidth - card_width_pixels*3


%%


x = paper_height - card_width_in * 4
x / 2

x = paper_width - card_height_in * 2
x/2
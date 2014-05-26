img = imread('test_2.bmp');
grayimg = rgb2gray(img);
grayimg = imadjust(grayimg);
bw = edge(grayimg,'canny', 0.15, 2);
bw = imfill(bw,'holes');
se = strel('disk',1); 
bw = imopen(bw,se);
[B,L] = bwboundaries(bw);
stats = regionprops(L,'Centroid','EquivDiameter');
figure, imshow(img)
hold on
for k = 1:length(B)
 boundary = B{k};
 radius = stats(k).EquivDiameter/2;
 xc = stats(k).Centroid(1);
 yc = stats(k).Centroid(2);
 theta = 0:0.01:2*pi;
 Xfit = radius*cos(theta) + xc;
 Yfit = radius*sin(theta) + yc;
 plot(Xfit, Yfit, 'g');
 text(boundary(1,2)-15,boundary(1,1)+15, num2str(radius,3),'Color','y',...
  'FontSize',8);
end
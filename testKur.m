%% ������� �����������. 
RGB=imread('speed.jpg');
%imshow(RGB);
%% ��� 2: ��������� ��������� �����������.
I=rgb2gray(RGB);
I=imadjust(I);
I=imadjust(I);
bg=imclose(I,strel('disk',15));
I2=imsubtract(bg,I);
I2=imadjust(I2);
I2=imadjust(I2);
%figure, imshow(I2);
%��������� �������
%scaled = I2*1.8;
imshow(scaled);
%%
level=graythresh(I2);
bw=im2bw(I2, level);
figure, imshow(bw); %!!! �������� ��������� �������
%% ��� 3: ���������� ����.
% �������� ���� ��������, ���������� ������ ��� 100 ��������
bw=bwareaopen(bw,30);
% �������� ��������� ���������
bw=imclearborder(bw);
imshow(bw);
%% ���������� ������
se=strel('disk', 15);
bw=imclose(bw, se);
bw=imfill(bw,'holes');
% �������� ���� ��������, ���������� ������ ��� 100 ��������
%bw=bwareaopen(bw,500);
imshow(bw);
%% ��������
[labeled,numObjects] = bwlabel(bw,8);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];
%% ���������� ��� ���������� ��������
idxOfDefects = find(eccentricities < 0.6 & areas > 1500);
statsDefects = stats(idxOfDefects);
%% �������
%% ������� ����������� �� ����� � �������
panelimggray = rgb2gray(RGB);
%% ��������� �������
scaled = panelimggray * 1.3;
%imshow(scaled);
 
%% ��������� ������ ��� �������� ��������� �����������
level = 100;
binary = scaled < level;
%imshow(binary);
 
%% ���������� ������ ���������, ��������� �� ���������� ���������� �������� � %������, � ������� ��������������� �������� ��������
binary2 = bwareaopen(binary,3000);
%imshow(binary2);
 
%% �������� ��������� ���������
binary = binary2;
binary = imclearborder(binary);
%imshow(binary);
%% ����� ������� ��������
[B,L] = bwboundaries(binary,'noholes');
numRegions = max(L(:));
%imshow(label2rgb(L));
 
%% ���������� �����������
stats = regionprops(L,'all');
MajorAxisL = [stats.MajorAxisLength];
MinorAxisL = [stats.MinorAxisLength];
 
%% ����� ����� �� ����������� ���������
%���� ������� ������ �������
lanesIndex = find(MajorAxisL./MinorAxisL > 5);
lines = B(lanesIndex);
%% ����� �� �������
figure; imshow(RGB);
hold on;
for idx = 1 : length(statsDefects)
        h = rectangle('Position',statsDefects(idx).BoundingBox,'LineWidth',2);
        set(h,'EdgeColor',[.75 0 0]);
        hold on;
end
for K = 1:length(lanesIndex)
    plot(lines{K}(:,2),lines{K}(:,1),'g','LineWidth',2)
    text(lines{K}(1, 2)-35, lines{K}(1, 1)+13,...
         sprintf('%2.1f',-(stats(lanesIndex).Orientation + 180)/30+8),'Color', 'y',...
         'FontSize', 14, 'FontWeight', 'bold');
end

hold off;
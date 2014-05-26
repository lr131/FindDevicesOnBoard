%�� ������� ���������� ������� ��� �����
function []= FindDevices(filename) 
%% ������� �����������. 
RGB=imread(filename);
%% ��� 2: ��������� ��������� �����������.
I=rgb2gray(RGB);
I=imadjust(I);
I=imadjust(I);
bg=imclose(I,strel('disk',15));
I2=imsubtract(bg,I); 
I2=imadjust(I2);
I2=imadjust(I2);
level=graythresh(I2);
bw=im2bw(I2, level);
%% ��� 3: ���������� ����.
bw=bwareaopen(bw,30); % �������� ���� ��������, ���������� ������ ��� 30 ��������
bw=imclearborder(bw); % �������� ��������� ���������
%% ���������� ������
se=strel('disk', 15);
bw=imclose(bw, se);
bw=imfill(bw,'holes');
%% ���������� ������ ���������, ��������� �� ���������� ���������� �������� � %������, � ������� ��������������� �������� ��������
binary2 = bwareaopen(bw,10000); 
%% �������� ��������� ���������
binary = imclearborder(binary2);
%figure; imshow(binary);
%% ��������
[labeled,numObjects] = bwlabel(binary,8);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];
%% ���������� ��� ���������� ��������
idxOfDevice = find(eccentricities < 0.9 & areas > 1000);
statsDevices = stats(idxOfDevice);
%% ����� �� �������
figure; imshow(RGB);
hold on;
for idx = 1 : length(statsDevices)
        h = rectangle('Position',statsDevices(idx).BoundingBox,'LineWidth',2);
        set(h,'EdgeColor',[.75 0 0]);
        hold on;
end
hold off;
end
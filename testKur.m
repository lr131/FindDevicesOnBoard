%%������� �����������. 
RGB=imread('test_2.bmp');
imshow(RGB);
%%
%%��� 2: ��������� ��������� �����������.
I=rgb2gray(RGB);
%��������� �������
scaled = I*1.7;
imshow(scaled);
%%
level=graythresh(I);
%level=87;
%bw=scaled>level;
bw=im2bw(I, level);
imshow(bw); %!!! �������� ��������� �������
%%
%%��� 3: ���������� ����.
% �������� ���� ��������, ���������� ������ ��� 30 ��������
bw=bwareaopen(bw,100);
% �������� ��������� ���������
bw=imclearborder(bw);
imshow(bw);
%%
% ���������� ������
se=strel('disk', 2);
bw=imclose(bw, se);
bw=imfill(bw,'holes');
imshow(bw);
%%
%%��� 4: ����� ������ �������� �����������.
[B, L]=bwboundaries(bw, 'noholes');
% ����������� ������� ����� � ���������� ������
imshow(label2rgb(L, @jet, [.5 .5 .5]));
hold on;
for k=1:length(B)
  boundary=B{k};
  plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2)
end;
%%
%%��� 5: ����������� ���������� ��������.
%metric=4*pi*area/perimeter^2;
stats=regionprops(L, 'Area', 'Centroid');
threshold=0.94;
% ���������� ������
for k=1:length(B)
  % ��������� ��������� ������ (X, Y), ��������������� ����� 'k'
  boundary=B{k};
  % ���������� ��������� �� ������ ��������� ��������
  delta_sq=diff(boundary).^2;    
  perimeter=sum(sqrt(sum(delta_sq, 2)));
  % ��������� ����������� �������, ��������������� ����� 'k'
  area=stats(k).Area;
  % ���������� �������������� ���������� metric
  metric=4*pi*area/perimeter^2;
  % ����������� �����������
  metric_string=sprintf('%2.2f', metric);
  % ������������ ��������
  if metric>threshold
    centroid=stats(k).Centroid;
    plot(centroid(1), centroid(2), 'ko');
  end
  text(boundary(1, 2)-35, boundary(1, 1)+13, metric_string,'Color', 'y',...
       'FontSize', 14, 'FontWeight', 'bold');
end
title(['Metrics closer to 1 indicate that ',...
       'the object is approximately round']);

%%Считаем изображение. 
RGB=imread('test_2.bmp');
imshow(RGB);
%%
%%Шаг 2: Пороговая обработка изображения.
I=rgb2gray(RGB);
%Коррекция яркости
scaled = I*1.7;
imshow(scaled);
%%
level=graythresh(I);
%level=87;
%bw=scaled>level;
bw=im2bw(I, level);
imshow(bw); %!!! теряются маленькие приборы
%%
%%Шаг 3: Устранение шума.
% удаление всех объектов, содержащих меньше чем 30 пикселей
bw=bwareaopen(bw,100);
% удаление граничных элементов
bw=imclearborder(bw);
imshow(bw);
%%
% заполнение пустот
se=strel('disk', 2);
bw=imclose(bw, se);
bw=imfill(bw,'holes');
imshow(bw);
%%
%%Шаг 4: Поиск границ объектов изображения.
[B, L]=bwboundaries(bw, 'noholes');
% отображение матрицы меток и извлечение границ
imshow(label2rgb(L, @jet, [.5 .5 .5]));
hold on;
for k=1:length(B)
  boundary=B{k};
  plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2)
end;
%%
%%Шаг 5: Определение округлости объектов.
%metric=4*pi*area/perimeter^2;
stats=regionprops(L, 'Area', 'Centroid');
threshold=0.94;
% окружность границ
for k=1:length(B)
  % получение координат границ (X, Y), соответствующих метке 'k'
  boundary=B{k};
  % вычисление измерений на основе периметра объектов
  delta_sq=diff(boundary).^2;    
  perimeter=sum(sqrt(sum(delta_sq, 2)));
  % получение вычисленной площади, соответствующей метке 'k'
  area=stats(k).Area;
  % вычисление характеристики округлости metric
  metric=4*pi*area/perimeter^2;
  % отображение результатов
  metric_string=sprintf('%2.2f', metric);
  % маркирование объектов
  if metric>threshold
    centroid=stats(k).Centroid;
    plot(centroid(1), centroid(2), 'ko');
  end
  text(boundary(1, 2)-35, boundary(1, 1)+13, metric_string,'Color', 'y',...
       'FontSize', 14, 'FontWeight', 'bold');
end
title(['Metrics closer to 1 indicate that ',...
       'the object is approximately round']);

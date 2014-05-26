%% Считаем изображение. 
RGB=imread('speed.jpg');
%imshow(RGB);
%% Шаг 2: Пороговая обработка изображения.
I=rgb2gray(RGB);
I=imadjust(I);
I=imadjust(I);
bg=imclose(I,strel('disk',15));
I2=imsubtract(bg,I);
I2=imadjust(I2);
I2=imadjust(I2);
%figure, imshow(I2);
%Коррекция яркости
%scaled = I2*1.8;
imshow(scaled);
%%
level=graythresh(I2);
bw=im2bw(I2, level);
figure, imshow(bw); %!!! теряются маленькие приборы
%% Шаг 3: Устранение шума.
% удаление всех объектов, содержащих меньше чем 100 пикселей
bw=bwareaopen(bw,30);
% удаление граничных элементов
bw=imclearborder(bw);
imshow(bw);
%% заполнение пустот
se=strel('disk', 15);
bw=imclose(bw, se);
bw=imfill(bw,'holes');
% удаление всех объектов, содержащих меньше чем 100 пикселей
%bw=bwareaopen(bw,500);
imshow(bw);
%% Свойства
[labeled,numObjects] = bwlabel(bw,8);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];
%% используем для нахождения объектов
idxOfDefects = find(eccentricities < 0.6 & areas > 1500);
statsDefects = stats(idxOfDefects);
%% стрелка
%% Перевод изображения из цвета в полутон
panelimggray = rgb2gray(RGB);
%% Коррекция яркости
scaled = panelimggray * 1.3;
%imshow(scaled);
 
%% Выделение порога для создания бинарного изображения
level = 100;
binary = scaled < level;
%imshow(binary);
 
%% Фильтрация мелких элементов, состоящих из указанного количества пикселей и %меньше, с помощью морфологической операции открытия
binary2 = bwareaopen(binary,3000);
%imshow(binary2);
 
%% Удаление граничных элементов
binary = binary2;
binary = imclearborder(binary);
%imshow(binary);
%% Найдём границы объектов
[B,L] = bwboundaries(binary,'noholes');
numRegions = max(L(:));
%imshow(label2rgb(L));
 
%% Статистика изображения
stats = regionprops(L,'all');
MajorAxisL = [stats.MajorAxisLength];
MinorAxisL = [stats.MinorAxisLength];
 
%% Найдём линии по определённым критериям
%Ищем длинные тонкие объекты
lanesIndex = find(MajorAxisL./MinorAxisL > 5);
lines = B(lanesIndex);
%% вывод на рисунок
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
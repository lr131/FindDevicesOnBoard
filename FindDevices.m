%во входных параметрах укажите имя файла
function []= FindDevices(filename) 
%% Считаем изображение. 
RGB=imread(filename);
%% Шаг 2: Пороговая обработка изображения.
I=rgb2gray(RGB);
I=imadjust(I);
I=imadjust(I);
bg=imclose(I,strel('disk',15));
I2=imsubtract(bg,I); 
I2=imadjust(I2);
I2=imadjust(I2);
level=graythresh(I2);
bw=im2bw(I2, level);
%% Шаг 3: Устранение шума.
bw=bwareaopen(bw,30); % удаление всех объектов, содержащих меньше чем 30 пикселей
bw=imclearborder(bw); % удаление граничных элементов
%% заполнение пустот
se=strel('disk', 15);
bw=imclose(bw, se);
bw=imfill(bw,'holes');
%% Фильтрация мелких элементов, состоящих из указанного количества пикселей и %меньше, с помощью морфологической операции открытия
binary2 = bwareaopen(bw,10000); 
%% Удаление граничных элементов
binary = imclearborder(binary2);
%figure; imshow(binary);
%% Свойства
[labeled,numObjects] = bwlabel(binary,8);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];
%% используем для нахождения объектов
idxOfDevice = find(eccentricities < 0.9 & areas > 1000);
statsDevices = stats(idxOfDevice);
%% вывод на рисунок
figure; imshow(RGB);
hold on;
for idx = 1 : length(statsDevices)
        h = rectangle('Position',statsDevices(idx).BoundingBox,'LineWidth',2);
        set(h,'EdgeColor',[.75 0 0]);
        hold on;
end
hold off;
end
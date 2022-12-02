close all; clc;
% Viola Kones algoritmasýný kullanýr

faceDetector = vision.CascadeObjectDetector;
fileReader = vision.VideoFileReader('1.mp4');

%ilk frame'i alalým 
videoFrame = step(fileReader);

%facedetector nesnesiyle frame içerisinde yüzü arama
yuzCerceve = step(faceDetector,videoFrame);

cikisVideo = insertObjectAnnotation(videoFrame,'rectangle',yuzCerceve,'Yuz');
figure,imshow(cikisVideo),title('Yüz tespiti yapildi');

%goruntunun renk ozu degerini aliyoruz renk uzayini degistirioruz.Rengin
%dalga boyu ile alakalý renk uzayi

[hue,~,~] = rgb2hsv(videoFrame);

figure,imshow(hue),title('Hue kanalý');
rectangle('Position',yuzCerceve(1,:),'EdgeColor',[1 1 1],'LineWidt',2);

%burun tespiti yapip burnun nereye dondugu ile yuzu takip edicez
burunTespiti = vision.CascadeObjectDetector('Nose','UseROI',true);
burunCevresi = step(burunTespiti,videoFrame,yuzCerceve(1,:));

%CAMshift algoritmasi

tracker = vision.HistogramBasedTracker;
initializeObject(tracker,hue,burunCevresi(1,:));

videoBilgileri = info(fileReader);

videoPlayer = vision.VideoPlayer('Position',[300 300 videoBilgileri.VideoSize+30]);

while ~isDone(fileReader)
    videoFrame = step(fileReader);
    [hue,~,~] = rgb2hsv(videoFrame);
    
    yuzCevresi = step(tracker,hue);
    cikisVideosu = insertObjectAnnotation(videoFrame,'rectangle',yuzCevresi,'Yuz');
    step(videoPlayer,cikisVideosu)
    
end

release(fileReader);
release(videoPlayer);

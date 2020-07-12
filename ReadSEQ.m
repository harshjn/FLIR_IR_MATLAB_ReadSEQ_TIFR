% function [MatxOut_,StateMatrix,CycleIndexDiff,time]=seqTempMatParallel(videoFileName,CycleIndex,frameMat)
% 'U:\Storage2\Ext\BB30Storage2\harsh\Harsh_Rubber\July20\Rec-000047.seq'
atPath = getenv('FLIR_Atlas_MATLAB');
atImage = strcat(atPath,'Flir.Atlas.Image.dll');
asmInfo = NET.addAssembly(atImage);
file = Flir.Atlas.Image.ThermalImageFile(videoFileName);
seq = file.ThermalSequencePlayer();
%%
seq.SelectedIndex=240;
img = double(seq.ThermalImage.ImageProcessing.GetPixelsArray);
im = double(img);
imshow(im,[])

%%
xStart=230;xEnd=330;
yStart=365;yEnd=366;

MatXY=zeros(xEnd-xStart+1,yEnd-yStart+1,700);

time=zeros(1,700);

for ii= 1:700
    seq.SelectedIndex=ii
    img = double(seq.ThermalImage.ImageProcessing.GetPixelsArray);
%     imshow(img,[])
    for i=xStart:xEnd
        for j=yStart:yEnd
            MatXY(i-xStart+1,j-yStart+1,ii)=seq.ThermalImage.GetValueFromSignal(img(j,i));
        end 
    end

    ms=double(seq.ThermalImage.DateTime.Millisecond)*0.001;
    s=double(seq.ThermalImage.DateTime.Second);
    m=double(seq.ThermalImage.DateTime.Minute)*60;
    h=double(seq.ThermalImage.DateTime.Hour)*3600;
    time(ii)=h+m+s+ms;
end

%%
AA=mean(mean(MatXY));
Temps=zeros(1,700)
for i = 1:700
Temps(i)=AA(:,:,i)
end
figure(2)
plot(Temps)

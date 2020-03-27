clear;
musics=["Warriors1","Warriors2","Warriors3","dan1","dan2","dan3","fly1","fly2", "fly3","fish1","fish2","fish3","Fractures1","Fractures2","Fractures3","hai1", "hai2","hai3",    "Hero1","Hero2","Hero3","lucky1", "lucky2","lucky3","shijian1","shijian2",    "shijian3","Silver_Scrapes1","Silver_Scrapes2","Silver_Scrapes3","1","2","3","4","5","6","7","8","9","10"];
for i=1:40
    musicname=musics(i);
    mfc=".mfc";
    out=".txt";
    mfcName=strcat(musicname,mfc)
    outName=strcat(musicname,out)
    [data, frate, feakind] = htkread(mfcName);
    
    data(:,i) = data(:,i)*10 / norm(data(:,i), 1);
    gaussNum=200;%高斯模型个数
    [dimention,dotNum]=size(data);%模型维数,采样点集大小
    
    distances=zeros(gaussNum,dotNum);%每个采样点到上次迭代中每个聚类中心的距离
    shortcuts=zeros(1,dotNum);%每个采样点到最近的聚类中心的距离
    nearCenters=zeros(1,dotNum);%距离每个采样点最近的聚类中心编号
    
    kMeans=importdata("example.txt");
    
    for i=1:dotNum
        for j=1:gaussNum
            dis=0;
            for k=1:dimention
                dis=dis+(data(k,i)-kMeans(k,j))^2;
            end
            distances(j,i)=sqrt(dis);
        end
        shortcuts(i)=min(distances(:,i));
        for j=1:gaussNum
            if shortcuts(i)==distances(j,i)
                nearCenters(i)=j;
            end
        end
    end
    
    
    fid1=fopen(outName,'w');                                                         %需要改文件名称的地方
    for i=1:dotNum
        count=fprintf(fid1,'%d\t',nearCenters(i));
    end
end

function [data, frate, feakind] = htkread(filename)
% reads features with HTK format
%
% Omid Sadjadi <s.omid.sadjadi@gmail.com>
% Microsoft Research, Conversational Systems Research Center

fid = fopen(filename, 'rb', 'ieee-be');
nframes = fread(fid, 1, 'int32'); % number of frames
frate   = fread(fid, 1, 'int32'); % frame rate in 100 nano-seconds unit
nbytes  = fread(fid, 1, 'short'); % number of bytes per feature value
feakind = fread(fid, 1, 'short'); % 9 is USER
ndim = nbytes / 4; % feature dimension (4 bytes per value)
data = fread(fid, [ndim, nframes], 'float');
fclose(fid);
end
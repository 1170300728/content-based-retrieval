clear;

mfc='.mfc';
outName='example.txt';
start=1;
for musicname=1:10
    mfcName=strcat(num2str(musicname),mfc);
    [data0, frate, feakind] = htkread(mfcName);
    for i =1:size(data0,2)
    data0(:,i) = data0(:,i)*10 / norm(data0(:,i), 1);
    end
    data(:,start:start+size(data0,2)-1)=data0;
    start=start+size(data0,2);
end
%初始化混合模型数据
gaussNum=200;%高斯模型个数
[dimention,dotNum]=size(data);%模型维数,采样点集大小

%k-means方法聚类，获得较为准确的初始位置
%初始化聚类数据
maxStepsm=200;%最大迭代次数
delta=floor(dotNum/(gaussNum+1));
kMeans=zeros(dimention,gaussNum);
for i=1:gaussNum
    kMeans(:,i)=data(:,i*delta+1);
end
kMeans0=kMeans;%记录上一次的聚类中心
m=0;%迭代次数
while m<maxStepsm
    %初始化迭代数据
    kMeanCenters=zeros(dimention+1,gaussNum);
    distances=zeros(gaussNum,dotNum);%每个采样点到上次迭代中每个聚类中心的距离
    shortcuts=zeros(1,dotNum);%每个采样点到最近的聚类中心的距离
    nearCenters=zeros(1,dotNum);%距离每个采样点最近的聚类中心编号
    %计算距离
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
    %通过距离计算新的聚类中心
    for i=1:dotNum
        kMeanCenters(1:dimention,nearCenters(i))=(kMeanCenters(1:dimention,nearCenters(i))*kMeanCenters(1+dimention,nearCenters(i))+data(:,i))./(kMeanCenters(1+dimention,nearCenters(i))+1);
        kMeanCenters(1+dimention,nearCenters(i))=kMeanCenters(1+dimention,nearCenters(i))+1;
    end
    %记录中心迁移
    kMeans=kMeanCenters(1:dimention,:);
    m=m+1;
    %如果中心中存在全零点，说明聚类过程中有个中心不与任何采样点距离近，重新随机新的位置构成新的中心加入迭代
    for i=1:gaussNum
        if kMeans(:,i)==zeros(dimention,1)
            kMeans(:,i)=width*rand(dimention,1);
        end
    end
    %如果两次迭代值完全一致，退出循环
    if kMeans==kMeans0
        break;
    end
    kMeans0=kMeans;
end

fid1=fopen(outName,'w');                                                         %需要改文件名称的地方
for i=1:dimention
    for j=1:gaussNum-1
        count=fprintf(fid1,'%f\t',kMeans(i,j));  
    end
        count=fprintf(fid1,'%f\n',kMeans(i,j+1));  
end

% 
% %EM算法计算更准确的聚类中心
% maxStepsn=200;
% data=data';
% EMs=kMeans';
% EMs0=EMs;%记录上一次的聚类中心
% cov=zeros(dimention,dimention,gaussNum);
% for i=1:gaussNum
%     cov(:,:,i) = eye(dimention);
% end
% p=zeros(dotNum,gaussNum);
% prep=ones(gaussNum)./gaussNum;
% n=0;
% while n<maxStepsn
%     for i=1:gaussNum
%         p(:,i)=prep(i)*mvnpdf(data,EMs(i,:),cov(:,:,i));
%     end
%     p=p./repmat(sum(p,2),1,size(p,2));
%     
%     prep = sum(p,1)./size(p,1); %把p的每一行加起来就能得到每一个聚类的先验概率
%     
%     EMs = p'*data;%分别得到data每一维对于每一个聚类的期望，EMs(i,j),i是维数，j是聚类数
%     EMs= EMs./repmat((sum(p,1))',1,size(EMs,2));
%     
%     for j = 1 : length(prep)
%         vari = repmat(p(:,j),1,size(data,2)).*(data- repmat(EMs(j,:),size(data,1),1)); %%得到一个特定聚类X每一维的方差矩阵，乘以p，（相当于选择出属于该聚类的d采样点）
%         cov(:,:,j) = (vari'*vari)/sum(p(:,j),1);
%     end
%     if n>5
%         if sum(abs(EMs0-EMs))<10^-3
%             break;
%         end
%     end
%     EMs0=EMs;
%     n=n+1;
% end


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
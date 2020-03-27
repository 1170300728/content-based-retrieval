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
%��ʼ�����ģ������
gaussNum=200;%��˹ģ�͸���
[dimention,dotNum]=size(data);%ģ��ά��,�����㼯��С

%k-means�������࣬��ý�Ϊ׼ȷ�ĳ�ʼλ��
%��ʼ����������
maxStepsm=200;%����������
delta=floor(dotNum/(gaussNum+1));
kMeans=zeros(dimention,gaussNum);
for i=1:gaussNum
    kMeans(:,i)=data(:,i*delta+1);
end
kMeans0=kMeans;%��¼��һ�εľ�������
m=0;%��������
while m<maxStepsm
    %��ʼ����������
    kMeanCenters=zeros(dimention+1,gaussNum);
    distances=zeros(gaussNum,dotNum);%ÿ�������㵽�ϴε�����ÿ���������ĵľ���
    shortcuts=zeros(1,dotNum);%ÿ�������㵽����ľ������ĵľ���
    nearCenters=zeros(1,dotNum);%����ÿ������������ľ������ı��
    %�������
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
    %ͨ����������µľ�������
    for i=1:dotNum
        kMeanCenters(1:dimention,nearCenters(i))=(kMeanCenters(1:dimention,nearCenters(i))*kMeanCenters(1+dimention,nearCenters(i))+data(:,i))./(kMeanCenters(1+dimention,nearCenters(i))+1);
        kMeanCenters(1+dimention,nearCenters(i))=kMeanCenters(1+dimention,nearCenters(i))+1;
    end
    %��¼����Ǩ��
    kMeans=kMeanCenters(1:dimention,:);
    m=m+1;
    %��������д���ȫ��㣬˵������������и����Ĳ����κβ�������������������µ�λ�ù����µ����ļ������
    for i=1:gaussNum
        if kMeans(:,i)==zeros(dimention,1)
            kMeans(:,i)=width*rand(dimention,1);
        end
    end
    %������ε���ֵ��ȫһ�£��˳�ѭ��
    if kMeans==kMeans0
        break;
    end
    kMeans0=kMeans;
end

fid1=fopen(outName,'w');                                                         %��Ҫ���ļ����Ƶĵط�
for i=1:dimention
    for j=1:gaussNum-1
        count=fprintf(fid1,'%f\t',kMeans(i,j));  
    end
        count=fprintf(fid1,'%f\n',kMeans(i,j+1));  
end

% 
% %EM�㷨�����׼ȷ�ľ�������
% maxStepsn=200;
% data=data';
% EMs=kMeans';
% EMs0=EMs;%��¼��һ�εľ�������
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
%     prep = sum(p,1)./size(p,1); %��p��ÿһ�м��������ܵõ�ÿһ��������������
%     
%     EMs = p'*data;%�ֱ�õ�dataÿһά����ÿһ�������������EMs(i,j),i��ά����j�Ǿ�����
%     EMs= EMs./repmat((sum(p,1))',1,size(EMs,2));
%     
%     for j = 1 : length(prep)
%         vari = repmat(p(:,j),1,size(data,2)).*(data- repmat(EMs(j,:),size(data,1),1)); %%�õ�һ���ض�����Xÿһά�ķ�����󣬳���p�����൱��ѡ������ڸþ����d�����㣩
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
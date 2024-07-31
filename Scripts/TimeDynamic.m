clear;clc;
%%
RawPath = 'E:\Cartoon\...\NetworkBoldData.mat';
load(RawPath);
Network = {'MTN'};
RawData = NetworkBoldData{1};
subnam = [1:55];

%% Calculate inter-subject dissimilarity of time dynamics for each region in the mentalizing network
ComNum = nchoosek(subnam,2);
for roi = 1:length(RawData)
    for com = 1:length(ComNum)
        x = RawData{roi}(ComNum(com,1),:)';
        y = RawData{roi}(ComNum(com,2),:)';
        [r{roi,1}(com,1),p{roi,1}(com,1)]=corr(x,y,'Type','pearson');
    end
    Dissimi{roi,1} = 1-r{roi,1};
end
fprintf('\n   Calculate ISC Done!   \n');

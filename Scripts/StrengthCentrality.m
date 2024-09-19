clear;clc;
%%
RawPath = '\...\NetworkBoldData.mat';
load(RawPath);
Network = {'MTN','Pain'};
subnum = 55;

%% Calculate strength centrality
for net = 1:length(NetworkBoldData)
    for sub =1:subnum
        for roi1 = 1:length(NetworkBoldData{net})
            RoiNam = [1:length(NetworkBoldData{net})];
            RoiNam(roi1) = []; %delete given ROI num for getting other ROIs
            for roi2 = 1:length(NetworkBoldData{net})-1
                x = NetworkBoldData{net}{roi1}(sub,:)';
                y = NetworkBoldData{net}{RoiNam(roi2)}(sub,:)';
                [r{net}{sub,1}{roi1,1}(roi2,1),p{net}{sub,1}{roi1,1}(roi2,1)] = corr(x,y,'Type','pearson','Rows','complete');
            end
            fisher_z{net}{sub,1}{roi1,1} = atanh(r{net}{sub,1}{roi1,1});
            SC{net}{sub,1}(roi1,1) = sum(fisher_z{net}{sub,1}{roi1,1}); %Strength Centrality
        end
    end
end

%% Calculate inter-subject dissimilarity of the global strength centrality
ComLocNum = nchoosek(1:subnum,2);
for net = 1:length(SC)
    for pair = 1: length(ComLocNum) %pairs of subjects
        x = SC{net}{ComLocNum(pair,1)};
        y = SC{net}{ComLocNum(pair,2)};
        Distan = x - y;
        Euclidean{net}(pair,1) = sqrt(sum(power(Distan,2)));
    end
end
fprintf('\n   Calculate Euclidean distance Done!   \n');

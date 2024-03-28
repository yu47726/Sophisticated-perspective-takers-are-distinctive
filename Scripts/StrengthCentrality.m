clear;clc;
%%
RawPath = 'E:\Cartoon\Network\xtrData';
MatName = 'TRBOLD.mat';
Network = {'MTN','Pain'};
for i =1:length(Network)
    load(fullfile(RawPath,Network{i},MatName));
    NetworkBoldData{i} = TRBoldData;
end

subnum = 55;
subnam = [1:55]';

%% Calculate strength centrality
for net = 1:length(NetworkBoldData)
    for sub =1:length(subnam)
        for roi1 = 1:length(NetworkBoldData{net})
            RoiNam = [1:length(NetworkBoldData{net})];
            RoiNam(roi1) = []; %delete given ROI num for getting other ROIs
            for roi2 = 1:length(NetworkBoldData{net})-1
                x = NetworkBoldData{net}{roi1}(subnam(sub),:)';
                y = NetworkBoldData{net}{RoiNam(roi2)}(subnam(sub),:)';
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

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
%% Calculate within-network correlation for each subject
for sub = 1:subnum
    for net = 1:length(NetworkBoldData)
        roinum = length(NetworkBoldData{net});
        ComRoi =  nchoosek(1:roinum,2); % combination number of rois in network
        for com = 1:length(ComRoi)
                x = NetworkBoldData{net}{ComRoi(com,1)}(sub,:)';
                y = NetworkBoldData{net}{ComRoi(com,2)}(sub,:)';
                [r{sub,1}{net,1}(com,1),p{sub,1}{net,1}(com,1)]=corr(x,y,'type','pearson');
        end
        fisher_z{sub,1}{net,1} = atanh(r{sub,1}{net,1}); 
        fisher_z_mean{sub,1}(net,1) = mean(fisher_z{sub,1}{net,1});
    end
end
fprintf('\n   Calculate within-network correlation Done!   \n');

%% Calculate inter-subject dissimilarity of the global functional connectivity
ComLocNum = nchoosek(1:subnum,2);
for net = 1:length(NetworkBoldData) %network
    for pair = 1: length(ComLocNum) %pairs of subjects
        x = fisher_z{ComLocNum(pair,1)}{net};
        y = fisher_z{ComLocNum(pair,2)}{net};
        Distan = x - y;
        Euclidean{net}(pair,1) = sqrt(sum(power(Distan,2)));
    end
end
fprintf('\n   Calculate Euclidean distance Done!   \n');
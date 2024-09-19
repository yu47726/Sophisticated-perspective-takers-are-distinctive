clear,clc;
%%
load('\...\EyeMoveData.mat');
RawData = Data;
subnum=[1:41];
SubPair = nchoosek(subnum,2);
for i = 1:length(SubPair)
    PairNam{i,1} = [num2str(SubPair(i,1)),'_',num2str(SubPair(i,2))];
end

%% 
for pair = 1:length(SubPair)
%%% data processing
    Index_row = [];
    hori_pos = [];
    verti_pos = [];
    for i = 1:2
        raw_data = RawData{SubPair(pair,i)};
        for row = 1:size(raw_data,1)
            if isequaln(NaN,raw_data{row,1})
                Index_row = [Index_row;row];
            end
        end
        %Determine whether the subject's gaze falls within the defined range
        %horizon
        for row=1:numel(raw_data(:,1) )
            if  raw_data{row,1} < 0
                hori_pos = [hori_pos; row];
            elseif  raw_data{row,1} > 1280
                hori_pos = [hori_pos; row];
            end
        end
        clear row
        % vertical
        for row=1:numel(raw_data(:,2))
            if raw_data{row,2}  < 142.4
                verti_pos = [verti_pos; row];
            elseif raw_data{row,2} > 932.8
                verti_pos = [verti_pos; row];
            end
        end
    end
    Null_Row{pair,1}  = [Index_row;verti_pos;hori_pos];  
    
    % delete the data out of defined range
    data = RawData(SubPair(pair,:));
    for i = 1:2
        data{i}(Null_Row{pair},:) = [];
    end
    % inter-subject dissimilarity of eye-gaze trajectories
    ISD_x{pair,1} = 1-corr(cell2mat(data{1}(:,1)),cell2mat(data{2}(:,1)));
    ISD_y{pair,1} = 1-corr(cell2mat(data{1}(:,2)),cell2mat(data{2}(:,2)));
    ISD_mean{pair,1} = mean([ISD_x{pair},ISD_y{pair}]);
    
    fprintf(['\n \\ ',PairNam{pair},' Processing done. /\n\n']);
end
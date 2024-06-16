clear,clc;
%%
load('E:\Cartoon\EyeMove\Data\EyeMoveData.mat');
RawData = filled_data;
subnum=[1:41];
SubPair = nchoosek(subnum,2);
for i = 1:length(SubPair)
    PairNam{i,1} = [num2str(SubPair(i,1)),'_',num2str(SubPair(i,2))];
end

%% 
for pair = 1:length(SubPair)
    %%% data processing
    % first of pair
    raw_data1 = RawData{SubPair(pair,1)};
    Index_row1 = [];
    for row = 1:size(raw_data1,1)
        if isequaln(NaN,raw_data1{row,1})
            Index_row1 = [Index_row1;row];
        end
    end
    %Determine whether the subject's gaze falls within the defined range
    %horizon
    hori_pos1 = [];
    for row=1:numel(raw_data1(:,1) )
        if  raw_data1{row,1} < 0
            hori_pos1 = [hori_pos1; row];
        elseif  raw_data1{row,1} > 1280
            hori_pos1 = [hori_pos1; row];
        end
    end
    clear row
    % vertical
    verti_pos1 = [];
    for row=1:numel(raw_data1(:,2))
        if raw_data1{row,2}  < 142.4
            verti_pos1 = [verti_pos1; row];
        end
        if raw_data1{row,2} > 932.8
            verti_pos1 = [verti_pos1; row];
        end
    end
    
    % second of pair
    raw_data2 = RawData{SubPair(pair,2)};
    Index_row2 = [];
    for row = 1:size(raw_data2,1)
        if isequaln(NaN,raw_data2{row,1})
            Index_row2 = [Index_row2;row];
        end
    end
    
    hori_pos2 = [];
    for row=1:numel(raw_data2(:,1) )
        if raw_data2{row,1} < 0
            hori_pos2 = [hori_pos2; row];
        elseif  raw_data1{row,1} > 1280
            hori_pos2 = [hori_pos2; row];
        end
        
    end
    clear row
    verti_pos2 = [];
    for row=1:numel(raw_data2(:,2) )
        if raw_data2{row,2}  < 142.4
            verti_pos2 = [verti_pos2; row];
        end
        if raw_data2{row,2} > 932.8
            verti_pos2 = [verti_pos2; row];
        end
    end
    
    Index_row_null{pair,1} = Index_row1; Index_row_null{pair,2} = Index_row2;
    hori_pos_null{pair,1} = hori_pos1; hori_pos_null{pair,2} = hori_pos2;
    verti_pos_null{pair,1} = verti_pos1; verti_pos_null{pair,2} = verti_pos2;
    
    EyeBlink{pair,1}  = [Index_row1;Index_row2];
    verti_Null{pair,1}  = [hori_pos1;hori_pos2];
    hori_Null{pair,1}  = [verti_pos1;verti_pos2];
    Null_Row{pair,1}  = [Index_row1;Index_row2;verti_pos1;verti_pos2;hori_pos1;hori_pos2]; 
    
    raw_data1(Null_Row{pair,1},:) = [];
    raw_data2(Null_Row{pair,1},:) = [];
    pair1_data{pair,1} = raw_data1;
    pair2_data{pair,1} = raw_data2;
    
    % inter-subject dissimilarity of eye-gaze trajectories
    ISD_x{pair,1} = 1-corr(cell2mat(raw_data1(:,1)),cell2mat(raw_data2(:,1)));
    ISD_y{pair,1} = 1-corr(cell2mat(raw_data1(:,2)),cell2mat(raw_data2(:,2)));
    
    ISD_mean{pair,1} = mean([ISD_x{pair,1},ISD_y{pair,1}]);
       
    fprintf(['\n \\ ',PairNam{pair},' done. /\n\n']);
end
clear
which_version = 3;
[subid,resultsdir,cate_total_num,N_item_percate] = version_related_config(which_version);
cd(resultsdir)
cate_number = [235];
C_licks = [];
C_licks_multiple = [];

idx.highpos = 7;
idx.highpos2 = 8;
idx.itemnum = 6;
%idx.values = 15:20;
%idx.order = 9:14;
%idx.trialnum = 5;
idx.confidence = 41;
idx.choice = 39;


[how_many_clicks, clicks_pos_1st, clicks_pos_last, ...
clicks_pos_2ndlast, clicks_val_best, clicks_val_2ndbest,...
confidence_resample_mat, confidence_nonresample_mat] = deal(NaN(1,length(subid)));
  

for subj = 1:length(subid)    
    subdir = strcat('sub',num2str(subid(subj)));
    load([resultsdir subdir filesep strcat('choice_subject_',num2str(subid(subj)),'_cate_',num2str(cate_number),'.mat')]);
    
    % for all trials
    ccclicks = [];
    ccclicks_multiple = [];
    how_many_clicks_sub = 0;
    clicks_pos_1st_sub = 0;
    clicks_pos_last_sub = 0;
    clicks_pos_2ndlast_sub = 0;
    clicks_val_best_sub = 0;
    clicks_val_2ndbest_sub = 0;
    
    
    % get rid of 6 item trials.
    iindex = find(choice_data(:,6)<6);
    data_included = choice_data(iindex,:);
    clicks_all_included = clicks_all(1,iindex);
    clicks_matrix = zeros(length(iindex),10);
    highpos_included = choice_data(iindex, idx.highpos);
    highpos2_included = choice_data(iindex, idx.highpos2);
    itemnum_included = choice_data(iindex, idx.itemnum);
    confidence_included = choice_data(iindex, idx.confidence);
    choice_included = choice_data(iindex, idx.choice);
    
    
    for i = 1: length(iindex)
        if choice_included(i) == highpos_included(i);
            choice_all(i) = 1;
        else
            choice_all(i) = 0;
        end
        
        cll = clicks_all_included{i};
        a   = size(cll);
        ccclicks(i) = a(1);
        how_many_clicks_sub = how_many_clicks_sub + (a(1) - 2);        
        clicks_whichitems = cll(2:end,4); % which items are clicked
        if length(clicks_whichitems) <= 10  % && length(clicks_whichitems) >=1
            clicks_matrix(i,1:length(clicks_whichitems)) = clicks_whichitems;
        elseif length(clicks_whichitems)>10
            clicks_matrix(i,:) = clicks_whichitems(1:10);
        end
        
        if a(1) == 2, ccclicks_multiple(i) = 0; else ccclicks_multiple(i)= 1; end
        
        if ccclicks_multiple(i) == 1
            clicks_m = clicks_matrix(i,:);
            clicks_m = clicks_m(find(clicks_m>0));
            for t = 2:length(clicks_m)
                % position - wise
                if clicks_m(t) == 1
                    clicks_pos_1st_sub = clicks_pos_1st_sub + 1;
                elseif clicks_m(t) == itemnum_included(i)
                    clicks_pos_last_sub = clicks_pos_last_sub + 1;
                elseif clicks_m(t) == itemnum_included(i) - 1
                    clicks_pos_2ndlast_sub = clicks_pos_2ndlast_sub + 1;
                end
                % value wise
                if clicks_m(t) == highpos_included(i)
                    clicks_val_best_sub = clicks_val_best_sub + 1;
                elseif clicks_m(t) == highpos2_included(i)
                    clicks_val_2ndbest_sub = clicks_val_2ndbest_sub + 1;
                end 
            end            
        end     
    end
    

    
    %% 3 item trials
    ccclicks_3 = [];
    ccclicks_multiple_3 = [];
    how_many_clicks_sub_3 = 0;
    clicks_val_best_sub_3 = 0;
    clicks_val_2ndbest_sub_3 = 0;
    
    iindex_3 = find(choice_data(:,6) == 3);
    data_included_3 = choice_data(iindex_3,:);
    clicks_all_included_3 = clicks_all(1,iindex_3);
    clicks_matrix_3 = zeros(length(iindex_3),10);
    highpos_included_3 = choice_data(iindex_3, idx.highpos);
    highpos2_included_3 = choice_data(iindex_3, idx.highpos2);
    itemnum_included_3 = choice_data(iindex_3, idx.itemnum);
    confidence_included_3 = choice_data(iindex_3, idx.confidence);
    
    for i = 1: length(iindex_3)
        cll = clicks_all_included_3{i};
        a   = size(cll);
        ccclicks_3(i) = a(1);
        how_many_clicks_sub_3 = how_many_clicks_sub_3 + (a(1) - 2);        
        clicks_whichitems_3 = cll(2:end,4); % which items are clicked
        if length(clicks_whichitems_3) <= 10  % && length(clicks_whichitems) >=1
            clicks_matrix_3(i,1:length(clicks_whichitems_3)) = clicks_whichitems_3;
        elseif length(clicks_whichitems_3)>10
            clicks_matrix_3(i,:) = clicks_whichitems_3(1:10);
        end
        
        if a(1) == 2, ccclicks_multiple_3(i) = 0; else ccclicks_multiple_3(i)= 1; end
        
        if ccclicks_multiple_3(i) == 1
            clicks_m = clicks_matrix_3(i,:);
            clicks_m = clicks_m(find(clicks_m>0));
            for t = 2:length(clicks_m)
                % value wise
                if clicks_m(t) == highpos_included_3(i)
                    clicks_val_best_sub_3 = clicks_val_best_sub_3 + 1;
                elseif clicks_m(t) == highpos2_included_3(i)
                    clicks_val_2ndbest_sub_3 = clicks_val_2ndbest_sub_3 + 1;
                end 
            end            
        end     
    end
    
    
    %% 4 item trials
    ccclicks_4 = [];
    ccclicks_multiple_4 = [];
    how_many_clicks_sub_4 = 0;
    clicks_val_best_sub_4 = 0;
    clicks_val_2ndbest_sub_4 = 0;
    
    iindex_4 = find(choice_data(:,6) == 4);
    data_included_4 = choice_data(iindex_4,:);
    clicks_all_included_4 = clicks_all(1,iindex_4);
    clicks_matrix_4 = zeros(length(iindex_4),10);
    highpos_included_4 = choice_data(iindex_4, idx.highpos);
    highpos2_included_4 = choice_data(iindex_4, idx.highpos2);
    itemnum_included_4 = choice_data(iindex_4, idx.itemnum);
    confidence_included_4 = choice_data(iindex_4, idx.confidence);
    
    for i = 1: length(iindex_4)
        cll = clicks_all_included_4{i};
        a   = size(cll);
        ccclicks_4(i) = a(1);
        how_many_clicks_sub_4 = how_many_clicks_sub_4 + (a(1) - 2);        
        clicks_whichitems_4 = cll(2:end,4); % which items are clicked
        if length(clicks_whichitems_4) <= 10  % && length(clicks_whichitems) >=1
            clicks_matrix_4(i,1:length(clicks_whichitems_4)) = clicks_whichitems_4;
        elseif length(clicks_whichitems_4)>10
            clicks_matrix_4(i,:) = clicks_whichitems_4(1:10);
        end
        
        if a(1) == 2, ccclicks_multiple_4(i) = 0; else ccclicks_multiple_4(i)= 1; end
        
        if ccclicks_multiple_4(i) == 1
            clicks_m = clicks_matrix_4(i,:);
            clicks_m = clicks_m(find(clicks_m>0));
            for t = 2:length(clicks_m)
                % value wise
                if clicks_m(t) == highpos_included_4(i)
                    clicks_val_best_sub_4 = clicks_val_best_sub_4 + 1;
                elseif clicks_m(t) == highpos2_included_4(i)
                    clicks_val_2ndbest_sub_4 = clicks_val_2ndbest_sub_3 + 1;
                end 
            end            
        end     
    end    
    
    
     %% 5 item trials
    ccclicks_5 = [];
    ccclicks_multiple_5 = [];
    how_many_clicks_sub_5 = 0;
    clicks_val_best_sub_5 = 0;
    clicks_val_2ndbest_sub_5 = 0;
    
    iindex_5 = find(choice_data(:,6) == 5);
    data_included_5 = choice_data(iindex_5,:);
    clicks_all_included_5 = clicks_all(1,iindex_5);
    clicks_matrix_5 = zeros(length(iindex_5),10);
    highpos_included_5 = choice_data(iindex_5, idx.highpos);
    highpos2_included_5 = choice_data(iindex_5, idx.highpos2);
    itemnum_included_5 = choice_data(iindex_5, idx.itemnum);
    confidence_included_5 = choice_data(iindex_5, idx.confidence);
    
    for i = 1: length(iindex_5)
        cll = clicks_all_included_5{i};
        a   = size(cll);
        ccclicks_5(i) = a(1);
        how_many_clicks_sub_5 = how_many_clicks_sub_5 + (a(1) - 2);        
        clicks_whichitems_5 = cll(2:end,4); % which items are clicked
        if length(clicks_whichitems_5) <= 10  % && length(clicks_whichitems) >=1
            clicks_matrix_5(i,1:length(clicks_whichitems_5)) = clicks_whichitems_5;
        elseif length(clicks_whichitems_5)>10
            clicks_matrix_5(i,:) = clicks_whichitems_5(1:10);
        end
        
        if a(1) == 2, ccclicks_multiple_5(i) = 0; else ccclicks_multiple_5(i)= 1; end
        
        if ccclicks_multiple_5(i) == 1
            clicks_m = clicks_matrix_5(i,:);
            clicks_m = clicks_m(find(clicks_m>0));
            for t = 2:length(clicks_m)
                % value wise
                if clicks_m(t) == highpos_included_5(i)
                    clicks_val_best_sub_5 = clicks_val_best_sub_5 + 1;
                elseif clicks_m(t) == highpos2_included_5(i)
                    clicks_val_2ndbest_sub_5 = clicks_val_2ndbest_sub_5 + 1;
                end 
            end            
        end     
    end
       
    
    
    %confidence wise
    how_many_clicks(subj) = how_many_clicks_sub;
    clicks_pos_1st(subj)  = clicks_pos_1st_sub;
    clicks_pos_last(subj) = clicks_pos_last_sub;
    clicks_pos_2ndlast(subj) = clicks_pos_2ndlast_sub;
    clicks_val_best(subj) = clicks_val_best_sub;
    clicks_val_2ndbest(subj) = clicks_val_2ndbest_sub;
    
    
    how_many_clicks_3(subj) = how_many_clicks_sub_3;
    how_many_clicks_4(subj) = how_many_clicks_sub_4;
    how_many_clicks_5(subj) = how_many_clicks_sub_5;
    
    clicks_val_best_3(subj) = clicks_val_best_sub_3;
    clicks_val_2ndbest_3(subj) = clicks_val_2ndbest_sub_3;
    clicks_val_best_4(subj) = clicks_val_best_sub_4;
    clicks_val_2ndbest_4(subj) = clicks_val_2ndbest_sub_4;    
    clicks_val_best_5(subj) = clicks_val_best_sub_5;
    clicks_val_2ndbest_5(subj) = clicks_val_2ndbest_sub_5;
    
    clicks_percent_best_3 = clicks_val_best_3 - how_many_clicks_3*0.333;
    clicks_percent_2ndbest_3 = clicks_val_2ndbest_3 - how_many_clicks_3*0.333;
    clicks_percent_best_4 = clicks_val_best_4 - how_many_clicks_4*0.25;
    clicks_percent_2ndbest_4 = clicks_val_2ndbest_4 - how_many_clicks_4*0.25;
    clicks_percent_best_5 = clicks_val_best_5 - how_many_clicks_5*0.2;
    clicks_percent_2ndbest_5 = clicks_val_2ndbest_5 - how_many_clicks_5*0.2;
    
    clicks_percent_best = clicks_percent_best_3 + clicks_percent_best_4 + clicks_percent_best_5;
    clicks_percent_2ndbest = clicks_percent_2ndbest_3 + clicks_percent_2ndbest_4 + clicks_percent_2ndbest_5;
    
    confidence_resample{subj} = confidence_included(find(ccclicks_multiple == 1));
    confidence_nonresample{subj} = confidence_included(find(ccclicks_multiple == 0));
    confidence_resample_mat(subj) = nanmean(confidence_included(find(ccclicks_multiple == 1)));
    confidence_nonresample_mat(subj) = nanmean(confidence_included(find(ccclicks_multiple == 0)));
    choice_resampled{subj} = choice_all(find(ccclicks_multiple == 1));
    choice_nonresampled{subj} = choice_all(find(ccclicks_multiple == 0));
    choice_resampled_mat(subj) = nanmean(choice_all(find(ccclicks_multiple == 1)));
    choice_nonresampled_mat(subj) = nanmean(choice_all(find(ccclicks_multiple == 0)));
    
end
[h,p,ci,stats] = ttest(clicks_percent_best([1:9,11:27]))
[h,p,ci,stats] = ttest(clicks_percent_2ndbest([1:9,11:27]))

choice_resampled_mat = choice_resampled_mat([1:9,11:27]);
choice_nonresampled_mat = choice_nonresampled_mat([1:9,11:27]);


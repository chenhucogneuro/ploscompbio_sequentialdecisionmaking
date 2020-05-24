% Pull the 5 categories together, category 1+2+3+4+5 = 15
clear all
which_version = input('data from which version?');
 [total_subject,resultsdir,cate_total,N_item_percate] = version_related_config(which_version);
for subid = total_subject
    choice_results = [];
    if which_version == 3;
            clicks_all = {};
    end
    
    
    for kk = 1:length(cate_total)
         cate_number = cate_total(kk);
        subdir = strcat('sub',num2str(subid));
        if which_version == 1
            load([resultsdir subdir filesep strcat('choice_subject_',num2str(subid),'cate_',num2str(cate_number),'.mat')]);
        else
            load([resultsdir subdir filesep strcat('choice_subject_',num2str(subid),'_cate_',num2str(cate_number),'.mat')]);
        end
        
        % get of invalid and slow choices
        for q = 1:length(choice_data)
            if choice_data(q,39) > 6
                choice_data(q,39) = NaN;
                choice_data(q,40) = NaN;
                choice_data(q,41) = NaN;
            end
            
            if which_version > 1
                if choice_data(q,2) == 2
                    choice_data(q,51) = 1;
                elseif choice_data(q,2) == 3
                    choice_data(q,51) = 2;
                elseif choice_data(q,2) == 5
                    choice_data(q,51) = 3;
                end
            end
            
            
        end
        choice_results  = [choice_results;choice_data];
        if which_version == 3 
             clicks_all((kk-1)*84+1: kk*84) = clicks_alltrials;
        end
        
    end
    choice_data = choice_results;
    cd([resultsdir subdir])
    
    if which_version == 1
        save(['choice_subject_',num2str(subid),'_cate_15.mat'],'choice_data');
    elseif which_version == 2
        save(['choice_subject_',num2str(subid),'_cate_235.mat'],'choice_data');
    elseif which_version == 3
        save(['choice_subject_',num2str(subid),'_cate_235.mat'],'choice_data', 'clicks_all');        
    end
end

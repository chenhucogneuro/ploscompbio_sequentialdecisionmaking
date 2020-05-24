% Pull ratings of 5 categories together, category 1+2+3+4+5 = 15
clear all
which_version = input('data from which version?');
[total_subject,resultsdir,cate_total,N_item_percate] = version_related_config(which_version);
N_cate = length(cate_total);

for subid = total_subject
    rating_all_1 = NaN(1,N_item_percate * N_cate);
    for cate_number = cate_total;
        subdir = strcat('sub',num2str(subid));
        if which_version == 1
            load([resultsdir subdir filesep strcat('pleasantRating_subject_',num2str(subid),'_cate_',num2str(cate_number),'.mat')]);
        else
            load([resultsdir subdir filesep strcat('pleasantRating_1_subject_',num2str(subid),'_cate_',num2str(cate_number),'.mat')]);
        end
        
        if which_version >1
            if cate_number <5
                rating_all_1((cate_number - 2)*N_item_percate + 1: (cate_number - 1)*N_item_percate) = rating.orderItem;
            elseif cate_number == 5
                rating_all_1((cate_number - 3)*N_item_percate + 1: (cate_number - 2)*N_item_percate) = rating.orderItem;
            end
            
        elseif which_version == 1
            rating_all_1((cate_number - 1)*N_item_percate + 1: cate_number*N_item_percate) = ratingItem;
        end
    end
    cd([resultsdir subdir])
    
    if which_version > 1
        save(['pleasantRating_1_subject_',num2str(subid),'_cate_235.mat'],'rating_all_1')
        clear rating_all_1 rating tm
    elseif which_version == 1
        save(['pleasantRating_1_subject_',num2str(subid),'_cate_15.mat'],'rating_all_1')
        clear rating_all_1 ratingItem
    end
    
    
    
    if which_version > 1
        cd(resultsdir)
        rating_all_2 = NaN(1,N_item_percate * N_cate);
        for cate_number = cate_total;
            subdir = strcat('sub',num2str(subid));
            load([resultsdir subdir filesep strcat('pleasantRating_2_subject_',num2str(subid),'_cate_',num2str(cate_number),'.mat')]);
            if cate_number <5
                rating_all_2((cate_number - 2)*N_item_percate + 1: (cate_number - 1)*N_item_percate) = rating.orderItem;
            elseif cate_number == 5
                rating_all_2((cate_number - 3)*N_item_percate + 1: (cate_number - 2)*N_item_percate) = rating.orderItem;
            end
        end
        cd([resultsdir subdir])
        save(['pleasantRating_2_subject_',num2str(subid),'_cate_235.mat'],'rating_all_2')
    end
end
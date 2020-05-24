function [total_subject,resultsdir,cate_total,N_item_percate] = version_related_config(which_version)
    if which_version == 1
        total_subject =  [1:18,20:24,101:104,106,107];  %  29 subjects in total
        cate_total = [1:5];
        N_item_percate = 86;
        [~, hostname] = system('hostname');
        if strcmp(hostname(1:5),'MBB31')
            resultsdir = 'C:\Users\chen.hu\Dropbox\PHD\sdm\V1_SDM\results_sdm\';          
        else
            resultsdir = '/Users/chen/Dropbox/PHD/sdm/V1_SDM/results_sdm/';
        end
    elseif which_version == 2
        cate_total = [2,3,5];         
        N_item_percate = 60;
        total_subject =  [1:18,20:21,30:42]; % 33 subjects in total
        [~, hostname] = system('hostname');
        if strcmp(hostname(1:5),'MBB31')
            resultsdir = 'C:\Users\chen.hu\Dropbox\PHD\sdm\V2_SDM\results_V2\';           
        else
            resultsdir = '/Users/chen/Dropbox/PHD/sdm/V2_SDM/results_V2/';
        end    
    elseif which_version == 3
        total_subject =[50,51,53,55,57:64,66:71,74:77,81,82,90,91,92]; % total number of subject 27
        cate_total = [2,3,5];        
        N_item_percate = 60;        
        [~, hostname] = system('hostname');
        if strcmp(hostname(1:5),'MBB31')
            resultsdir = 'C:\Users\chen.hu\Dropbox\PHD\sdm\V3_SDM\results_V3\';     
        else
            resultsdir = '/Users/chen/Dropbox/PHD/sdm/V3_SDM/results_V3/';
        end         
    end
    cd(resultsdir) 
    
end


count = [];
goback_percent = [];
goback3_percent = [];

total_subject =[50,51,53,55,57:64,66:71,74:77,81,82,90,91,92];

for subi = 1:length(total_subject)
    sub = total_subject(subi);
    load(['/Users/chen/Dropbox/PHD/sdm/V3_SDM/results_V3/sub',num2str(sub),'/choice_subject_',num2str(sub),'_cate_235.mat']);
    for i = 1:length(clicks_all),
        y = size(clicks_all{i});
        count(subi,i) = y(1) - 2;
    end
    goback_percent(subi) = length(find(count(subi,:)>0))/252;
    goback1_percent(subi) = length(find(count(subi,:)>3))/252;
    
end

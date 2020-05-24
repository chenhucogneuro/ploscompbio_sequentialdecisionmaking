clear all
which_version = input('data from which version?');
[subid,resultsdir,cate_total,N_item_percate] = version_related_config(which_version);
[plotconfig] = f_plots_configuration(which_version);

idx.itemnum = 6;
idx.highpos = 7;
idx.pt = 33:38; % item viewing time
idx.choice = 39;
idx.values = 15:20;

cate_number = [235];
bin_simu = {};
corre_coeffs = [];
pt_better_ones = [];
pt_worse_ones  = [];

for subj = 1:length(subid)
    
    subdir = strcat('sub',num2str(subid(subj)));
    load([resultsdir subdir filesep strcat('choice_subject_',num2str(subid(subj)),'_cate_',num2str(cate_number),'.mat')]);
    itnum =  choice_data(:,idx.itemnum);
    choice_sub = choice_data(:,idx.choice);
    
    pt_view  = choice_data(:,idx.pt);
    value_trial = choice_data(:,idx.values);
    high_pos = choice_data(:,idx.highpos);
    choice_trial = choice_data(:,idx.choice);
    
    % 1. calculating correlation coefficient
    % get rid of the 6 item trials
    not_6_item = find(choice_data(:,idx.itemnum) < 6);
    pt_view_n6 = pt_view(not_6_item,:);
    value_trial_n6 = value_trial(not_6_item,:);
    high_pos_n6 = high_pos(not_6_item);
    choice_trial_n6 = choice_trial(not_6_item);
    
    % reshaping them into an array
    pt_sub = reshape(pt_view_n6,1,size(pt_view_n6,1)*size(pt_view_n6,2));
    value_sub = reshape(value_trial_n6,1,size(value_trial_n6,1)*size(value_trial_n6,2));
    % calculating correlation coefficients
    [r,p] = corrcoef(pt_sub',value_sub');
    corre_coeffs(subj) = r(1,2);
    
    % 2. calculating whether better options has longer exposure time
    [value_sub_sorted,value_index] = sort(value_sub,'Descend');
    pt_sub_sorted = pt_sub(value_index);
    pt_better_ones(subj) = mean(pt_sub_sorted(1:length(pt_sub_sorted)/2));
    pt_worse_ones(subj)  = mean(pt_sub_sorted(length(pt_sub_sorted)/2 + 1:length(pt_sub_sorted)));
    
    
    % 3. regression analysis of the best option
    % get the dv, pt_best and choice best for each trial, get the array
    for k = 1:length(choice_trial_n6)
        p_best_trial = choice_trial_n6(k);
        pt_best_trial = pt_view_n6(k,:);
        pt_best(k) = pt_best_trial(high_pos_n6(k));
        v_trial_n6 = value_trial_n6(k,:);
        v_best(k) = v_trial_n6(high_pos_n6(k));
        v_reg(k) = v_best(k)*length(v_trial_n6)/(length(v_trial_n6) - 1) - nansum(v_trial_n6)/(length(v_trial_n6) - 1);
        
        if choice_trial_n6(k) == high_pos_n6(k);
            p_best(k) = 1;
        else
            p_best(k) = 0;
        end
    end
    % logistic regression analysis
    b = glmfit([v_reg',pt_best'],p_best','binomial','link','logit');
    regs_coef_dv(subj) = b(2);
    regs_coef_pt(subj) = b(3);
    
    
    
    %% ploting the probability of choice according to the browsing time.
    % get 3 items trials
    items3 = find(itnum == 3);  % which number of trials included
    for i = 1:length(items3)
        pt_view_3item = pt_view(items3(i),1:3);  % 0.5, 0.6, 0.7
        choice_3item  = zeros(1,3);
        if isnan(choice_sub(items3(i)))
        else
            choice_3item(choice_sub(items3(i))) = 1;% 0, 0, 1
        end
        
        [pt_view_3_item_ranked, sortIndx3] = sort(pt_view_3item, 'descend');
        view_choice_3item(i,:) = choice_3item(sortIndx3);
    end
    m_h0_3_1(subid(subj),:) = nanmean(view_choice_3item);
    
    
    % get 4 items trials
    items4 = find(itnum == 4);  % which number of trials included
    for i = 1:length(items4)
        pt_view_4item = pt_view(items4(i),1:4);
        choice_4item  = zeros(1,4);
        if isnan(choice_sub(items4(i)))
        else
            choice_4item(choice_sub(items4(i))) = 1;
        end
        
        [pt_view_4_item_ranked, sortIndx4] = sort(pt_view_4item, 'descend');
        view_choice_4item(i,:) = choice_4item(sortIndx4);
    end
    m_h0_4_1(subid(subj),:) = nanmean(view_choice_4item);
    
    
    % get 5 items trials
    items5 = find(itnum == 5);
    for i = 1:length(items5)
        pt_view_5item = pt_view(items5(i),1:5);
        choice_5item  = zeros(1,5);
        if isnan(choice_sub(items5(i)))
        else
            choice_5item(choice_sub(items5(i))) = 1;
        end
        
        [pt_view_5_item_ranked, sortIndx5] = sort(pt_view_5item, 'descend');
        view_choice_5item(i,:) = choice_5item(sortIndx5);
    end
    m_h0_5_1(subid(subj),:) = nanmean(view_choice_5item);
    
end


figure
hold on, set(gca,'fontsize',28)
errorbar(nanmedian(m_h0_3_1(subid,:)),nanstd(m_h0_3_1(subid,:))/sqrt(length(subid)),'Color','b', 'LineWidth',plotconfig.width)
errorbar(nanmedian(m_h0_4_1(subid,:)),nanstd(m_h0_4_1(subid,:))/sqrt(length(subid)),'Color','m', 'LineWidth',plotconfig.width)
errorbar(nanmedian(m_h0_5_1(subid,:)),nanstd(m_h0_5_1(subid,:))/sqrt(length(subid)),'Color','g', 'LineWidth',plotconfig.width)
legend('3 items','4 items','5 items')%, '6 items');
ylabel ('choice proba')
xlabel('ET ranking')


for j = 1:length(subid)
    b3 = glmfit(1:3, m_h0_3_1(subid(j),:),'normal');
    b4 = glmfit(1:4, m_h0_4_1(subid(j),:),'normal');
    b5 = glmfit(1:5, m_h0_5_1(subid(j),:),'normal');
    
    beta_interest(j) = mean([b3(2),b4(2),b5(2)]);
    beta_intersect(j) = mean([b3(1),b4(1),b5(1)]);
end

%% correlation of value and processing time
[h,p,ci,stats] = ttest(corre_coeffs)

%% whether better items are looked at longer
[h,p,ci,stats] = ttest(pt_better_ones,pt_worse_ones)

%% logistic regression
[h,p,ci,stats] = ttest(regs_coef_dv);
[h,p,ci,stats] = ttest(regs_coef_pt);




function [plotconfig] = f_plots_configuration(which_version)
[~, hostname] = system('hostname');
if strcmp(hostname(1:5),'MBB31')
    plotconfig.dir = ['C:\Users\chen.hu\Dropbox\PHD\sdm\general_resultsplot\version',num2str(which_version),'\'];
else
    plotconfig.dir =['/Users/chen/Dropbox/PHD/sdm/general_resultsplot/version',num2str(which_version),'/'];
end
plotconfig.width = 3;
plotconfig.size = [0,0,600,600];
plotconfig.colors = [1, 0.89412,0.88235; 0.46667,0.5333, 0.6; 0.18431,0.3098,0.3098; 0.6902,0.18824,0.37647;0.27451,0.5098,0.70588;0.82353,0.70588,0.54902];
plotconfig.marks = {'-o','-*','-s','->'};
plotconfig.marksize = 10;
plotconfig.transp = 0.7;
end

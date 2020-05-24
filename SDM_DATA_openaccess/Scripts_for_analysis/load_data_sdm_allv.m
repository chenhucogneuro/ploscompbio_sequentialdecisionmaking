% data loader for the SDM experiment
% input which_sub = subject number, which_category = category_number
% which_items = 'all','3items','4items','5items','6items'
% containts:
% 1) conditions:data.subject/data.category/data.repitition
% data.sessionorder/data.trialnumber
% 2) trialinfo:data.item.number/data.item.highpos/data.item.highpos2
% 3) optioninfo:data.item.order/data.item.values/data.item.id/data.item.pt
% 4) behaviorinfo: data.choice/data.choice1/data.choice2/data.rt/data_confidence

function [data,idx] = load_data_sdm_allv(which_sub,which_category,which_items,which_version,N_item_percate,resultsdir);

idx.nsubject = 1;
if which_version == 1
    idx.category = 2;
else
    idx.category = 51;  % corrected to continuous 1-3, was 2,3,5
end
idx.repitition = 3; % might be 1-4
idx.sessionorder = 4;  % which session has started first
idx.trialnum = 5;

idx.item.number = 6;  % 3-6 items
idx.item.highpos = 7;
idx.item.highpos2 = 8;
idx.item.order = 9:14;
idx.item.values = 15:20;
idx.item.id = 21:26;
idx.item.pt = 33:38;
idx.choice = 39;
idx.rt = 40;
idx.confidence = 41;


choice_data = [];
subdir = strcat('sub',num2str(which_sub));
load([resultsdir subdir filesep strcat('choice_subject_',num2str(which_sub),'_cate_',num2str(which_category),'.mat')]);

%% if no item is specified
data_all.subject = choice_data(:,idx.nsubject);
data_all.category = choice_data(:,idx.category);
data_all.repitition = choice_data(:,idx.repitition);
data_all.sessionorder = choice_data(:,idx.sessionorder);
data_all.trialnumber = choice_data(:,idx.trialnum);

data_all.item.number = choice_data(:,idx.item.number);  % 3-6 items
data_all.item.highpos = choice_data(:,idx.item.highpos);
data_all.item.highpos2 = choice_data(:,idx.item.highpos2);
data_all.item.highpos_dist = data_all.item.highpos - data_all.item.highpos2 ;

data_all.item.order = choice_data(:,idx.item.order);
data_all.item.values = choice_data(:,idx.item.values);

switch which_category
    case {1,2,3,4,5}
        data_all.item.id = choice_data(:,idx.item.id);
    case {15,235}
        data_all.item.id = choice_data(:,idx.item.id) + repmat(N_item_percate.* (data_all.category - 1),1,6);
end

data_all.item.pt = choice_data(:,idx.item.pt);
data_all.choice = choice_data(:,idx.choice);
data_all.choice1 = (data_all.choice ==  data_all.item.highpos);
data_all.choice2 = (data_all.choice ==  data_all.item.highpos2);
data_all.rt = choice_data(:,idx.rt);
data_all.confidence = choice_data(:,idx.confidence);

for i = 1:length(data_all.choice)
    data_all.item.pt_trial = data_all.item.pt(i,:);
    data_all.item.pt_best(i) = data_all.item.pt_trial(data_all.item.highpos(i));
end

%% if specifed as '3 items'

idx.items3 = find(data_all.item.number == 3);
data_3.item.highpos = data_all.item.highpos(idx.items3);
data_3.item.highpos2 = data_all.item.highpos2(idx.items3);
data_3.item.highpos_dist = data_all.item.highpos_dist(idx.items3);

data_3.item.order = data_all.item.order(idx.items3,:);
data_3.item.values = data_all.item.values(idx.items3,:);
data_3.item.id = data_all.item.id(idx.items3,:);
data_3.item.pt = data_all.item.pt(idx.items3,:);
data_3.choice = data_all.choice(idx.items3);
data_3.choice1 = data_all.choice1(idx.items3);
data_3.choice2 = data_all.choice2(idx.items3);
data_3.rt = data_all.rt(idx.items3);
data_3.rt_excl = data_3.rt(data_3.choice1);
data_3.confidence = data_all.confidence(idx.items3);
data_3.confidence_excl = data_3.confidence(data_3.choice1);

for i = 1:length(data_3.choice)
    data_3.item.pt_trial = data_3.item.pt(i,:);
    data_3.item.pt_best(i) = data_3.item.pt_trial(data_3.item.highpos(i));
end

%% if specifed as '4 items'
idx.items4 = find(data_all.item.number == 4);
data_4.item.highpos = data_all.item.highpos(idx.items4);
data_4.item.highpos2 = data_all.item.highpos2(idx.items4);
data_4.item.highpos_dist = data_all.item.highpos_dist(idx.items4);

data_4.item.order = data_all.item.order(idx.items4,:);
data_4.item.values = data_all.item.values(idx.items4,:);
data_4.item.id = data_all.item.id(idx.items4,:);
data_4.item.pt = data_all.item.pt(idx.items4,:);
data_4.choice = data_all.choice(idx.items4);
data_4.choice1 = data_all.choice1(idx.items4);
data_4.choice2 = data_all.choice2(idx.items4);
data_4.rt = data_all.rt(idx.items4);
data_4.confidence = data_all.confidence(idx.items4);
for i = 1:length(data_4.choice)
    data_4.item.pt_trial = data_4.item.pt(i,:);
    data_4.item.pt_best(i) = data_4.item.pt_trial(data_4.item.highpos(i));
end

%% if specifed as '5 items'
idx.items5 = find(data_all.item.number == 5);
data_5.item.highpos = data_all.item.highpos(idx.items5);
data_5.item.highpos2 = data_all.item.highpos2(idx.items5);
data_5.item.highpos_dist = data_all.item.highpos_dist(idx.items5);

data_5.item.order = data_all.item.order(idx.items5,:);
data_5.item.values = data_all.item.values(idx.items5,:);
data_5.item.id = data_all.item.id(idx.items5,:);
data_5.item.pt = data_all.item.pt(idx.items5,:);
data_5.choice = data_all.choice(idx.items5);
data_5.choice1 = data_all.choice1(idx.items5);
data_5.choice2 = data_all.choice2(idx.items5);
data_5.rt = data_all.rt(idx.items5);
data_5.confidence = data_all.confidence(idx.items5);
for i = 1:length(data_5.choice)
    data_5.item.pt_trial = data_5.item.pt(i,:);
    data_5.item.pt_best(i) = data_5.item.pt_trial(data_5.item.highpos(i));
end


%% if specifed as '6 items'

idx.items6 = find(data_all.item.number == 6);
data_6.item.highpos = data_all.item.highpos(idx.items6);
data_6.item.highpos2 = data_all.item.highpos2(idx.items6);
data_6.item.highpos_dist = data_all.item.highpos_dist(idx.items6);

data_6.item.order = data_all.item.order(idx.items6,:);
data_6.item.values = data_all.item.values(idx.items6,:);
data_6.item.id = data_all.item.id(idx.items6,:);
data_6.item.pt = data_all.item.pt(idx.items6,:);
data_6.choice = data_all.choice(idx.items6);
data_6.choice1 = data_all.choice1(idx.items6);
data_6.choice2 = data_all.choice2(idx.items6);
data_6.rt = data_all.rt(idx.items6);
data_6.confidence = data_all.confidence(idx.items6);
for i = 1:length(data_6.choice)
    data_6.item.pt_trial = data_6.item.pt(i,:);
    data_6.item.pt_best(i) = data_6.item.pt_trial(data_6.item.highpos(i));
end

switch which_items
    case 0
        data = data_all;
    case 3
        data = data_3;
    case 4
        data = data_4;
    case 5
        data = data_5;
    case 6
        data = data_6;
end
end








clear
which_version = input('data from which version?');
which_errorbar = input('which error bar plot do you want? 1= between subjects, 2 = withinsubjects mean corrected ');
all_measures = {'choice','rt','confidence','pt'};
legend_on = 0; label_on = 0;

[total_subject,resultsdir,cate_total,N_item_percate] = version_related_config(which_version);
[plotconfig] = f_plots_configuration(which_version);
[which_measure, which2plot, bestor2nd, exclude_nonchosen,which_cate,numitem_max] = analysis_config(which_version);

% specify what to be ploted
for cate_number = which_cate
    [choice_best_all,choice_best_dist_all,...
        choice_best2_all,choice_best2_dist_all,...
        rt_best_all,rt_dist_all,...
        conf_best_all,conf_dist_all,...
        pt_best_all] = deal({});
    [choice_best_all_se,choice_best_dist_all_se,...
        choice_best2_all_se,choice_best2_dist_all_se,...
        rt_best_all_se,rt_dist_all_se,...
        conf_best_all_se,conf_dist_all_se,...
        pt_best_all_se] = deal({});
    
    
    %% get choice proba, pt, rt, conf in absolute locations
    for m = 3:numitem_max
        [choice_best.mean,choice_best.se,choice_best2.mean,choice_best2.se,...
            rt_best.mean,rt_best.se,conf_best.mean,conf_best.se,pt_best.mean] = deal(NaN(length(total_subject),6));
        [choice_best_dist.mean,choice_best_dist.se,choice_best2_dist.mean,choice_best2_dist.se,...
            rt_dist.mean,rt_dist.se,conf_dist.mean, conf_dist.se, pt_best.se] = deal(NaN(length(total_subject),10));
        
        for subj = 1:length(total_subject)
            [data,~] = load_data_sdm_allv(total_subject(subj),cate_number, m, which_version, N_item_percate,resultsdir);
            for k = 1:m
                best_location = find(data.item.highpos == k);
                best_location2 = find(data.item.highpos2 == k);
                [choice_best] = get_mean_se(data.choice1,best_location,subj,k,choice_best);
                [choice_best2] = get_mean_se(data.choice2,best_location2,subj,k,choice_best2);
                [pt_best] = get_mean_se(data.item.pt_best, best_location,subj,k,pt_best);
                
                if exclude_nonchosen == 1
                    rt_best_al = data.rt(best_location); conf_best_al = data.confidence(best_location);
                    choice1_pos = data.choice1(best_location);
                    [rt_best] = get_mean_se(rt_best_al,choice1_pos,subj,k,rt_best);
                    [conf_best] = get_mean_se(conf_best_al,choice1_pos,subj,k,conf_best);
                elseif exclude_nonchosen == 2
                    [rt_best] = get_mean_se(data.rt,best_location,subj,k,rt_best);
                    [conf_best] = get_mean_se(data.confidence,best_location,subj,k,conf_best);
                end
            end
            
            %% get choice, pt, rt, conf in their relative positions
            dist_seq = [(1-m),(2-m),(m-2),(m-1)];
            for g = 1:length(dist_seq)
                pos_dist = find(data.item.highpos_dist == dist_seq(g));
                [choice_best_dist] = get_mean_se(data.choice1,pos_dist,subj,g,choice_best_dist);
                [choice_best2_dist] = get_mean_se(data.choice2,pos_dist,subj,g,choice_best2_dist);
                
                if exclude_nonchosen == 1
                    rt_dist_al = data.rt(pos_dist);  
                    conf_dist_al = data.confidence(pos_dist);
                    choice1_dist_pos = data.choice1(pos_dist);
                    [rt_dist] = get_mean_se(rt_dist_al,choice1_dist_pos,subj,g,rt_dist);
                    [conf_dist] = get_mean_se(conf_dist_al,choice1_dist_pos,subj,g,conf_dist);
                elseif exclude_nonchosen == 2
                    [rt_dist] = get_mean_se(data.rt,pos_dist,subj,g,rt_dist);
                    [conf_dist] = get_mean_se(data.confidence,pos_dist,subj,g,conf_dist);
                end
            end
        end
        choice_best_all{m} = choice_best.mean;               choice_best_all_se{m} = choice_best.se;
        choice_best2_all{m} = choice_best2.mean;             choice_best2_all_se{m} = choice_best2.se;
        rt_best_all{m} = rt_best.mean;                       rt_best_all_se{m} = rt_best.se;
        conf_best_all{m} = conf_best.mean;                   conf_best_all_se{m} = conf_best.se;
        pt_best_all{m} = pt_best.mean;                       pt_best_all_se{m} = pt_best.se;
        
        choice_best_dist_all{m} = choice_best_dist.mean;     choice_best_dist_all_se{m} = choice_best_dist.se;
        choice_best2_dist_all{m} = choice_best2_dist.mean;   choice_best2_dist_all_se{m} = choice_best2_dist.se;
        rt_dist_all{m} = rt_dist.mean;                       rt_dist_all_se{m} = rt_dist.se;
        conf_dist_all{m} = conf_dist.mean;                   conf_dist_all_se{m} = conf_dist.se;
    end
    
    
    %% plot
    figure; hold on, set(gca,'fontsize',28)%,ylim([0.75, 1])
    for m = 3:numitem_max
        if or(which2plot == 1,which2plot == 2)
            switch which_measure
                case 1
                    if bestor2nd == 1  % best option chosen in terms of positions
                        plot_mean = nanmean(choice_best_all{m});
                        plot_errorbar_between = nanstd(choice_best_all{m} - nanmean(choice_best_all{m}')')/sqrt(length(total_subject));
                        plot_errorbar_rse = sqrt(nansum((choice_best_all_se{m}./choice_best_all{m}).^2))./length(choice_best_all{m}).*nanmean(choice_best_all{m});
                    elseif bestor2nd == 2
                        plot_mean = nanmean(choice_best2_all{m});
                        plot_errorbar_between = nanstd(choice_best2_all{m})/sqrt(length(total_subject));
                        plot_errorbar_rse = sqrt(nansum((choice_best2_all_se{m}./choice_best2_all{m}).^2))./length(choice_best_all{m}).*nanmean(choice_best_all{m});
                    end
                case 2
                    plot_mean = nanmean(rt_best_all{m});
                    plot_errorbar_between = nanstd(rt_best_all{m} - nanmean(rt_best_all{m}')')/sqrt(length(total_subject));
                    plot_errorbar_rse = sqrt(nansum((rt_best_all_se{m}./rt_best_all{m}).^2))./length(rt_best_all{m}).*nanmean(rt_best_all{m});
                case 3
                    plot_mean = nanmean(conf_best_all{m});
                    plot_errorbar_between = nanstd(conf_best_all{m} - nanmean(conf_best_all{m}')')/sqrt(length(total_subject));
                    plot_errorbar_rse = sqrt(nansum((conf_best_all_se{m}./conf_best_all{m}).^2))./length(conf_best_all{m}).*nanmean(conf_best_all{m});
                case 4
                    plot_mean = nanmean(pt_best_all{m});
                    plot_errorbar_between = nanstd(pt_best_all{m} - nanmean(pt_best_all{m}')')/sqrt(length(total_subject));
                    plot_errorbar_rse = nanstd(pt_best_all{m} - nanmean(pt_best_all{m}')')/sqrt(length(total_subject));% sqrt(nansum((pt_best_all_se{m}./pt_best_all{m}).^2))./length(pt_best_all{m}).*nanmean(pt_best_all{m});
            end
            
            if which_errorbar  == 1
                plot_mean = plot_mean(~isnan(plot_mean));
                plot_errorbar_between = plot_errorbar_between(~isnan(plot_errorbar_between));
                plot(find(~isnan(nanmean(choice_best_all{m}))), plot_mean, plotconfig.marks{m -2},'Color',plotconfig.colors(m,:), 'LineWidth',plotconfig.width,'MarkerSize', plotconfig.marksize);                 
                boundedline(find(~isnan(nanmean(choice_best_all{m}))), plot_mean,plot_errorbar_between, 'orientation', 'vert', 'cmap', plotconfig.colors(m,:), 'transparency',  plotconfig.transp,'alpha');                 
%                 plot(1:length(plot_mean), plot_mean, plotconfig.marks{m -2},'Color',plotconfig.colors(m,:), 'LineWidth',plotconfig.width,'MarkerSize', plotconfig.marksize);
%                  boundedline(1:length(plot_mean), plot_mean,plot_errorbar_between, 'orientation', 'vert', 'cmap', plotconfig.colors(m,:), 'transparency',  plotconfig.transp,'alpha');
            elseif which_errorbar  == 2
                errorbar(plot_mean,plot_errorbar_rse,'Color',plotconfig.colors(m,:), 'LineWidth',plotconfig.width);
            end
            
            [xlabel_text, ylabel_text,filename] = set_plot_labels(which_measure, which2plot, bestor2nd, exclude_nonchosen,cate_number);
            xlim([1,numitem_max]);
            if which_measure == 1
                ylim([0.45, 0.85]);set(gca,'YTick',0.45:0.1:0.85)
            end
            if label_on == 1, xlabel(xlabel_text); ylabel (ylabel_text);end
            
        elseif which2plot == 3
            dist_seq = [(1-m),(2-m),(m-2),(m-1)];
            switch which_measure
                case 1
                    if bestor2nd == 1  % best option chosen in terms of positions
                        plot_mean = nanmean(choice_best_dist_all{m});
                        plot_errorbar_between = nanstd(choice_best_dist_all{m}- nanmean(choice_best_dist_all{m}')')/sqrt(length(total_subject));
                        plot_errorbar_rse = sqrt(nansum((choice_best_dist_all_se{m}./choice_best_dist_all{m}).^2))./length(choice_best_dist_all{m}).*nanmean(choice_best_dist_all{m});
                        
                    elseif bestor2nd == 2
                        plot_mean = nanmean(choice_best2_dist_all{m});
                        plot_errorbar_between = nanstd(choice_best2_dist_all{m} - nanmean(choice_best2_dist_all{m}')')/sqrt(length(total_subject));
                        plot_errorbar_rse = sqrt(nansum((choice_best2_dist_all_se{m}./choice_best2_dist_all{m}).^2))./length(choice_best_dist_all{m}).*nanmean(choice_best_dist_all{m});
                        
                    end
                    
                case 2
                    plot_mean = nanmean(rt_dist_all{m});
                    plot_errorbar_between = nanstd(rt_dist_all{m} - nanmean(rt_dist_all{m}')')/sqrt(length(total_subject));
                    plot_errorbar_rse = sqrt(nansum((rt_dist_all_se{m}./rt_dist_all{m}).^2))./length(rt_dist_all{m}).*nanmean(rt_dist_all{m});
                    
                case 3
                    plot_mean = nanmean(conf_dist_all{m});
                    plot_errorbar_between = nanstd(conf_dist_all{m} - nanmean(conf_dist_all{m}')')/sqrt(length(total_subject));
                    plot_errorbar_rse = sqrt(nansum((conf_dist_all_se{m}./conf_dist_all{m}).^2))./length(conf_dist_all{m}).*nanmean(conf_dist_all{m});
                    
            end
            
            if which_errorbar == 1
                %errorbar(dist_seq,plot_mean(~isnan(plot_mean)), plot_errorbar_between(~isnan(plot_errorbar_between)),'Color',plotconfig.colors(m,:), 'LineWidth',plotconfig.width);
                plot(dist_seq, plot_mean(~isnan(plot_mean)), plotconfig.marks{m-2},'Color',plotconfig.colors(m,:), 'LineWidth',plotconfig.width,'MarkerSize', plotconfig.marksize);
                boundedline(dist_seq, plot_mean(~isnan(plot_mean)), plot_errorbar_between(~isnan(plot_errorbar_between)), 'orientation', 'vert', 'cmap', plotconfig.colors(m,:), 'transparency',  plotconfig.transp,'alpha');
                
            elseif which_errorbar == 2
                errorbar(dist_seq,plot_mean(~isnan(plot_mean)), plot_errorbar_rse(plot_errorbar_rse~=0),'Color',plotconfig.colors(m,:), 'LineWidth',plotconfig.width);
            end
            [xlabel_text, ylabel_text,filename] = set_plot_labels(which_measure, which2plot, bestor2nd, exclude_nonchosen,cate_number);
            if label_on == 1, xlabel(xlabel_text); ylabel (ylabel_text);end
        end
    end
    
    if legend_on == 1
        if which_version == 1
            legend('3 items','4 items','5 items','6 items');
        else
            legend('3 items','4 items','5 items');
        end
    end
    
    set(gcf,'units','points','position',plotconfig.size)
    cd(plotconfig.dir);
    res=300;%resolution
    paperunits = 'centimeters';
    filewidth = 18;%cm
    fileheight = 18;%cm
    size = [filewidth fileheight];
    set(gcf,'paperunits',paperunits,'paperposition',[0 0 size]);
    set(gcf,'PaperSize', size);
    %     saveas(gcf,[filename.trace,'.pdf']);
    %     saveas(gcf,[filename.trace,'.tif']);
end

%% Regression
[beta_interest, beta_intersect] = get_regression_coeff(which_measure, which2plot,total_subject,numitem_max,...
    choice_best_all,choice_best2_all, rt_best_all,conf_best_all,pt_best_all,...
    choice_best_dist_all,choice_best2_dist_all,rt_dist_all, conf_dist_all,bestor2nd);
[h,p,ci,stats] = ttest(mean(beta_interest))

if which2plot~= 3
    x_plot = [1:numitem_max];
elseif which2plot== 3
    x_plot = dist_seq;
end
y_plot = mean(mean(beta_interest))* x_plot + mean(mean(beta_intersect));

hold on
plot(x_plot,y_plot,':','Color',[0, 0, 0.4], 'LineWidth',4)
if which_measure ==1
    ylim([0.45,0.85]);set(gca,'YTick',0.45:0.1:0.85)
end

if legend_on == 1
    if which_version == 1
        legend('3 items','4 items','5 items','6 items', 'GLM fit');
    else
        legend('3 items','4 items','5 items','GLM fit');
    end
end
if which_measure ==1
    set(gca,'YTick',0.45:0.1:0.85)
end

set(gcf,'units','points','position',plotconfig.size)
cd(plotconfig.dir);
res = 300;%resolution
paperunits = 'centimeters';
filewidth = 18;%cm
fileheight = 18;%cm
size = [filewidth fileheight];
set(gcf,'paperunits',paperunits,'paperposition',[0 0 size]);
set(gcf,'PaperSize', size);
saveas(gcf,[filename.regs,'.pdf']);
saveas(gcf,[filename.regs,'.tif']);


%% function definitions

% functions to get the mean and the standard error at the same time
function [variables_update] = get_mean_se(which_variable,positions,subject_number,best_pos,variables)
variables.mean(subject_number,best_pos)= nanmean(which_variable(positions));
variables.se(subject_number,best_pos) = nanstd(which_variable(positions))/sqrt(length(which_variable(positions)));
variables_update = variables;
end

% functions to specify which variable to plot
function [which_measure, which2plot, bestor2nd, exclude_nonchosen,which_cate,numitem_max]= analysis_config(which_version)
[which_measure, which2plot, bestor2nd, exclude_nonchosen] = deal(0);
which_measure = input('Which behavioral measure to plot? 1 = choice,2 = rt,3 = confidence,4 = pt');
which2plot = input('plot in function of which postion? 1. best, 2.2nd best, 3. relative postion');
if which_measure == 1;bestor2nd = input('plot the probability of choosing the best(1) or the second best(2)?');end
if which_measure ~= 1; exclude_nonchosen = input('include which trials? 1 = exclusively best chosen, 2 = all trials');end
if which_version == 1; which_cate = 15; numitem_max = 6; elseif which_version > 1; which_cate = 235; numitem_max = 5; end
end

%  plots related configurationns
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


% set plot labels and and file names
function [xlabel_text, ylabel_text,filename] = set_plot_labels(which_measure, which2plot, bestor2nd, exclude_nonchosen,cate_number)
all_measures = {'choice', 'rt', 'confidence','Exposure Time'};
all_plot_positions = {'best option position','2nd best position','relative position (best - 2nd best)'};
probability_keyword = {' probabilities','','',''};
best_2nd_best = {'','best','2ndbest'};
exclusive_or_not = {'','exclusive','all'};

xlabel_text = [all_plot_positions{which2plot}];
ylabel_text = [all_measures{which_measure},probability_keyword{which_measure},' ',best_2nd_best{bestor2nd+1}];%,exclusive_or_not{exclude_nonchosen+1}];
if which2plot < 3
    filename.trace = [all_measures{which_measure},'_',best_2nd_best{bestor2nd+1},exclusive_or_not{exclude_nonchosen+1},'_cate_',num2str(cate_number)];
    filename.regs = [all_measures{which_measure},'_',best_2nd_best{bestor2nd+1},exclusive_or_not{exclude_nonchosen+1},'_cate_',num2str(cate_number),'_regs'];
    
elseif which2plot == 3
    filename.trace = [all_measures{which_measure},'_',best_2nd_best{bestor2nd+1},exclusive_or_not{exclude_nonchosen+1},'_dist_cate_',num2str(cate_number)];
    filename.regs  = [all_measures{which_measure},'_',best_2nd_best{bestor2nd+1},exclusive_or_not{exclude_nonchosen+1},'_dist_cate_',num2str(cate_number),'_regs'];
end
end

function [beta_interest, beta_intersect] = get_regression_coeff(which_measure, which2plot,total_subject,numitem_max,...
    choice_best_all,choice_best2_all, rt_best_all,conf_best_all,pt_best_all,...
    choice_best_dist_all,choice_best2_dist_all,rt_dist_all, conf_dist_all, bestor2nd)

beta_interest = [];
beta_intersect = [];
if which2plot < 3
    if which_measure == 1
        if bestor2nd == 1
            variable_interest = choice_best_all;
        elseif bestor2nd == 1
            variable_interest = choice_best2_all;
        end
        
    elseif which_measure == 2
        variable_interest = rt_best_all;
        
    elseif which_measure == 3
        variable_interest = conf_best_all;
    elseif which_measure == 4
        variable_interest = pt_best_all;
        
    end
    
    for j = 1:length(total_subject)
        for k =  3:numitem_max
            temp = variable_interest{k}(j,:);
            b = glmfit(find(~isnan(nanmean(choice_best_all{k}))), temp(~isnan(temp)), 'normal');
%            b = glmfit(1:k, temp(~isnan(temp)), 'normal');

            beta_interest(k-2,j) = b(2);
            beta_intersect(k-2,j) = b(1);
        end
    end
    
elseif which2plot == 3
    if which_measure == 1
        if bestor2nd == 1
            variable_interest = choice_best_dist_all;
        elseif bestor2nd == 1
            variable_interest = choice_best2_dist_all;
        end
    elseif which_measure == 2
        variable_interest = rt_dist_all;
    elseif which_measure == 3
        variable_interest = conf_dist_all;
    end
    for j = 1:length(total_subject)
        for k =  3:numitem_max
            temp = variable_interest{k}(j,:);
            b = glmfit([(1-k),(2-k),(k-2),(k-1)], temp(~isnan(temp)), 'normal');
            beta_interest(k-2,j) = b(2);
            beta_intersect(k-2,j) = b(1);
            
        end
    end
end

end


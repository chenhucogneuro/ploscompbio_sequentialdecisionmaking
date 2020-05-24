% function param = invert_data_sdm(model_n, sub)
for which_version = 2
    all_mevidence = [];
    which_models = [8,16];
    % 1 = null model
    % 2 = local covert
    % 3 = local covert +1
    % 4 = pruning model
    % 5 = primacy decay
    
    % 6 = primacy divisive
    % 7 = global covert
    % 8 = 2leve = local covert + global overt
    
    
    % 9 = recency model - bounded prior
    % 10 = primacy + recency - unbounded prior
    
    %which_version = input('data from which version?');
    for model_n = which_models
        clearvars -except model_n  all_mevidence  which_models which_version
        [sub, root, which_categories, N_items_percate] = version_related_config(which_version);
        zscore_ornot = 0;
        multi_item_on = 1;
        
        
        %% Specify how to load informations needed
        [~, hostname] = system('hostname'); % try to identify which computer am I using
        if strcmp(hostname(1:5),'MBB31')
            resultdir = ['C:\Users\chen.hu\Dropbox\PHD\sdm\general_analysis\model_based\sdm_results\version',num2str(which_version),'\'];
        else
            resultdir = ['/Users/chen/Dropbox/PHD/sdm/general_analysis/model_based/sdm_results/version',num2str(which_version),'/'];
        end
        
        %% Load input data
        INDX_category = 2;
        INDX_itemnumber = 6;
        if zscore_ornot == 1
            INDX_values = 44:49;
        else
            INDX_values = 15:20;
        end
        INDX_itemid = 21:26;
        INDX_choice = 39;
        
        N_sub = length(sub);
        if N_items_percate == 60
            N_trials_percate = 72;
        elseif N_items_percate == 86     
            N_trials_percate = 72;
        end
        N_items = N_items_percate * length(which_categories);
        Ntrials = N_trials_percate  * length(which_categories);
        
        
        
        for s = 1:N_sub
            subj = sub(s);
            if which_version == 1
                mydatafile = load([root,'sub',num2str(subj),filesep,'choice_subject_',num2str(subj),'_cate_15.mat']);
                myratingfile = load([root,'sub',num2str(subj),filesep,'pleasantRating_1_subject_',num2str(subj),'_cate_15.mat']);
            else
                mydatafile = load([root,'sub',num2str(subj),filesep,'choice_subject_',num2str(subj),'_cate_235.mat']);
                mydatafile.choice_data = megafind(mydatafile.choice_data,INDX_itemnumber,{[3,4,5]},[1:51]);
                myratingfile = load([root,'sub',num2str(subj),filesep,'pleasantRating_1_subject_',num2str(subj),'_cate_235.mat']);
            end
            
            [choice_position, itemnum, which_category] = deal(NaN(Ntrials,1));
            [values,itemid,choice] = deal(NaN(Ntrials,6));
            
            itemnum = megafind(mydatafile.choice_data,INDX_category,{which_categories},INDX_itemnumber);
            values = megafind(mydatafile.choice_data,INDX_category,{which_categories},INDX_values);  % 6 values, sometimes the last fews can be empty
            choice_position = megafind(mydatafile.choice_data,INDX_category,{which_categories},INDX_choice);
            
            for i = 1: Ntrials
                temp = zeros(1, itemnum(i));
                if which_version == 1
                    which_category(i) =  mydatafile.choice_data(i,2);
                else
                    which_category(i) =  mydatafile.choice_data(i,51);
                end
                itemid(i, :)=  mydatafile.choice_data(i,INDX_itemid)+ (which_category(i)-1)*N_items_percate;
                
                if choice_position(i) < 7
                    temp(choice_position(i)) = 1;
                end
                choice(i, 1:itemnum(i)) = temp;
            end
            
            y = choice';
            u_r = [which_category, itemnum, itemid, values]';  % 360* 8, 3- 8, itemid
            if which_version == 3  && multi_item_on ==1
                u_r = [which_category, itemnum, itemid, values,mydatafile.clicks_matrix(:,1:3)]';  % 360* 8, 3- 8, itemid
            end
            
            % if using the global chosen model, throw the choices in
            if model_n == 8
                u_r = [u_r;choice_position'];
            end
            
            if model_n == 16
                u_r = [u_r;choice_position'];
            end            
            
            
            %% Modeles a tester :
            models_set = {'m_h0','m_bbc','m_bbc1plus', 'm_pairwise','m_primacy_decay','m_primacy_divisive',...
                'm_global', 'm_chosen_global','m_recency_div','m_primacy_recency_div',...
                'm_bbc_proba','m_primacy_extra','m_primacy_extra_diff','m_primacy_ratio', 'm_saliency',...
                'm_H0_2level'};
            model_name = models_set{model_n};
            
            switch model_name
                % model 1 the null model
                case 'm_h0'   % 1. linear model- one parameter, which is the beta
                    model_obs = @allobs_h0;
                    model_evo = [];
                    prior = [0]; %#ok<NBRAK>
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                    
                case 'm_bbc' % 2.bonus model 
                    %model_obs = @allobs_bbc1plus;  change on the 18/06
                    model_obs = @allobs_bbc;
                    if which_version == 3 &&  multi_item_on ==1
                        model_obs = @allobs_bbc_v3;
                    end
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                case 'm_bbc1plus' % 3. bonus 1+ model 
                    model_obs = @allobs_bbc1plus;
                    if which_version == 3 &&  multi_item_on ==1
                        model_obs = @allobs_bbc1plus_v3;
                    end
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    
                case 'm_pairwise'   % 4. 
                    model_obs = @allobs_pairwise;
                    model_evo = [];
                    prior = [0]; %#ok<NBRAK>
                    param = length(prior);
                    
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                    
                case 'm_primacy_decay' % 5. 
                    model_obs = @allobs_primdec;
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                case 'm_primacy_divisive' % 6
                    model_obs = @allobs_primdiv;
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                case 'm_global' % 7 
                    model_obs = @obs_000_evo;
                    model_evo = @evo_010;
                    if which_version == 3 &&  multi_item_on ==1
                        model_evo = @evo_010_v3;
                    end
                    prior = [0];
                    param = length(prior);
                    dim = struct('n',N_items,...  % number of hidden states
                        'n_theta',1,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                case 'm_chosen_global' % 8 
                    model_obs = @obs_000_chosen_evo;
                    if which_version == 3 && multi_item_on ==1
                        model_obs = @obs_000_chosen_evo_v3;
                    end
                    model_evo = @evo_chosen_global;
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',N_items,...  % number of hidden states
                        'n_theta',1,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                    
                case 'm_recency_div' % 9
                    model_obs = @allobs_recencydiv;
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                    
                case 'm_primacy_recency_div' % 10
                    model_obs = @allobs_primrecdiv;
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension
                    
                case'm_bbc_proba' % 11 reviewer 2's suggestion
                     model_obs = @allobs_bbc_proba;
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension                   
                    
                case 'm_primacy_extra' % 12 Reviewer 1's suggestion 
                    model_obs = @allobs_primdiv_1plus;
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension   
                    
                case 'm_primacy_extra_diff' % 13 Reviewer 1's suggestion,variation 
                    model_obs = @allobs_primdiv_1plus_diff;
                    model_evo = [];
                    prior = [0 0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension   
                   
                case 'm_primacy_ratio' % 14 reviewer 1's other suggestion
                    model_obs = @allobs_primdiv_ratio;
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension    
                    
                    
                 case 'm_saliency' % 15 reviewer 3's suggestion
                    model_obs = @allobs_saliency;
                    model_evo = [];
                    prior = [0 0];
                    param = length(prior);
                    dim = struct('n',0,...  % number of hidden states
                        'n_theta',0,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension  
                
                case 'm_H0_2level' % 16                    
                    model_obs = @obs_000_chosen_evo_H0;
                    if which_version == 3 && multi_item_on ==1
                        model_obs = @obs_000_chosen_evo_v3;
                    end
                    model_evo = @evo_chosen_global;
                    prior = [0];
                    param = length(prior);
                    dim = struct('n',N_items,...  % number of hidden states
                        'n_theta',1,... % number of evolution parameters
                        'n_phi', param,... % number of observation parameters
                        'n_t',Ntrials); % number of trials
                    %        'p',1,... % total output dimension                    
            end
            
            
            %% Definition of model options
            g_name = model_obs;
            f_name = model_evo;
            options.DisplayWin = 0; % Display setting
            options.GnFigs = 0; % Plotting option
            options.verbose= 1;
            
            options.isYout = zeros(size(choice)); % vector of the size of y, 1 if trial out
            options.sources.out  = 1:6;
            options.sources.type = 2;
            
            %% Definition of priors
            % Observation parameters :
            priors.muPhi = prior;
            priors.SigmaPhi = 1e0*eye(dim.n_phi);
            % Evolution parameters
            priors.muTheta = zeros(dim.n_theta,1);
            priors.SigmaTheta = 1e1*eye(dim.n_theta);
            priors.a_alpha = Inf;
            priors.b_alpha = 0;
            if model_n > 6
                priors.muX0 = myratingfile.rating_all_1';
                priors.SigmaX0 = 1e1*zeros(dim.n);
                options.updateX0 = 0 ;
                options.skipf = zeros(1,dim.n_t);
                options.skipf(1) = 1;
            end
            options.priors = priors;
            
            %% Performing the inversion
            options.figName = 'choice_data';
            size_y = size(y);
            exclusion = zeros(size_y);
            for h = 1:size_y(1)
                for q = 1:size_y(2)
                    if isnan(y(h,q))
                        y(h,q) = 100;
                        exclusion(h,q) = 1;
                    end
                end
            end
            options.isYout = exclusion;
            [posteriorr,outr] = VBA_NLStateSpaceModel(y,u_r,f_name,g_name,dim,options);
            model_evidence_r(subj,1) = outr.F; % #ok<AGROW>
            obs_param_all_r(subj,:)= posteriorr.muPhi(1:end)';
            % obs_param_all_r_var(subj,:)= posteriorr.SigmaPhi(1:end)';
            evo_param_all_r(subj,:)= posteriorr.muTheta(1:end)';
            
            posterior_all{subj} = posteriorr;
            out_all{subj} = outr;
            
        end
        
        cd(resultdir);
        params = struct('Name',[model_name,'_VBA'],'Val_param_obs',obs_param_all_r,'Priors',priors,'Rating_model_evidence',model_evidence_r, 'All_posteriors', posterior_all,'All_out',out_all);
        all_mevidence = [all_mevidence, model_evidence_r];
        if INDX_category == 2  % fitting according to different categories
            cname = ['cate_',sprintf('%d', which_categories)];
        elseif INDX_category == 4  % fitting according to different sessions
            cname = ['session_',sprintf('%d', which_categories)];
        elseif INDX_category == 6  % fitting accordinparams(1).All_posteriors.muPhig to different sessions
            cname = ['itemnum_',sprintf('%d', which_categories)];
        end
        obs_param_all_r_sub = obs_param_all_r(sub,:);
        %obs_param_all_r_var_sub = obs_param_all_r_var(sub,:);
        evo_param_all_r_sub = evo_param_all_r(sub,:);
        
        save (['sdm_model_fit_m_',num2str(model_n),'_',cname,'.mat'],...
            'obs_param_all_r','evo_param_all_r',...
            'obs_param_all_r_sub','evo_param_all_r_sub');
        
    end
    
    %% run BMC group model comparison
    model_names = {'h0','Bonus','Bonus1+','Pruning','PrimDec','PrimDiv','BonusGlobal','BonusCGlobal'};
    %options.families = {[1], [2,3],[4],[5,6]} ;
    options.DisplayWin = 1;
    [posterior,out] = VBA_groupBMC(all_mevidence(sub,:)',options)
    save (['sdm_model_fit_m_',sprintf('%d',which_models),'_',cname,'.mat'], 'all_mevidence','posterior','out')
    saveas(gcf,['BMS_',sprintf('%d',which_models),'_',cname,'.tif']);
    

    
end
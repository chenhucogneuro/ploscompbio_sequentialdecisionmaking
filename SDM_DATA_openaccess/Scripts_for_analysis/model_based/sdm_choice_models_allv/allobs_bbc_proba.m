function  [ gx ] = allobs_bbc_proba(x,P,u,in)
% there are 3 parameters version and 2 parameters version
inv_temp_general = safepos(P(1));
% invtp = safepos(P(2));
% delta = P(3);
invtp = inv_temp_general;
delta = P(2);

% get the value variables
items_value = u(9:14);
items_number = u(2);
n_possibilities = 2^(items_number - 1);
v_zero  =(items_value(~isnan(items_value)));

% bonus applied to the first item
v_zero(1) = v_zero(1) + delta; % step 0

%% 3 item scenario, 4 possibilities
if items_number == 3 
    % step 1
    p12 = (exp(v_zero(1).*invtp)./nansum(exp(v_zero(1:2).*invtp)));  p21 = 1 - p12;
    v_3_s1(1,:) = [v_zero(1) + delta, v_zero(2) - delta, v_zero(3)];  % possibility that option 1 wins
    v_3_s1(2,:) = [v_zero(1) - delta, v_zero(2) + delta, v_zero(3)];  % possibility that option 2 wins
    % step 2
    p13 = (exp(v_3_s1(1,1).*invtp)./nansum(exp(v_3_s1(1,[1,3]).*invtp))); p31 = 1 - p13;
    p23 = (exp(v_3_s1(2,2).*invtp)./nansum(exp(v_3_s1(2,[2,3]).*invtp))); p32 = 1 - p23;
    
    %     route 1 - end value possibility
    %     delta_matrix = [2 -1 -1; -1 2 -1; 0 -1 1; -1 0 1].*delta;
    %     v_3 = repmat(v_zero,n_possibilities,1) + delta_matrix;
    v_3(1,:) = [v_zero(1) + 2*delta, v_zero(2) - delta,   v_zero(3) - delta]; % choose 1*2: P12*P13
    v_3(2,:) = [v_zero(1) - delta,   v_zero(2) + 2*delta, v_zero(3) - delta]; % choose 2*2: P21*P23 = (1-P12)*P23
    v_3(3,:) = [v_zero(1),           v_zero(2) - delta,   v_zero(3) + delta]; % choose 1&3: P12*P31 = P12*(1-P13)
    v_3(4,:) = [v_zero(1) - delta,   v_zero(2),           v_zero(3) + delta]; % choose 2&3: P21*P32 = (1-P12)*(1-P23)
    
    % possibilities to end up by one of the 4 routes
    p_s12(1) = p12 * p13;
    p_s12(2) = p21 * p23;
    p_s12(3) = p12 * p31;
    p_s12(4) = p21 * p32;
    
    p_3_final = NaN(n_possibilities,items_number);
    % choice_probability
    for possib = 1:n_possibilities
        for option = 1:items_number
            p_3_final(possib,option) = p_s12(possib).* (exp(v_3(possib,option).*inv_temp_general)./nansum(exp(v_3(possib,:).*inv_temp_general)));
        end
    end
    kx = sum(p_3_final);
    
%% 4 item scenario, 8 possibilities    
elseif items_number == 4
    % step 1
    p12 = (exp(v_zero(1).*invtp)./nansum(exp(v_zero(1:2).*invtp))); p21 = 1 - p12;
    v_4_s1(1,:) = [v_zero(1) + delta, v_zero(2) - delta, v_zero(3), v_zero(4)];  % possibility that option 1 wins
    v_4_s1(2,:) = [v_zero(1) - delta, v_zero(2) + delta, v_zero(3), v_zero(4)];  % possibility that option 2 wins
    
    % step 2
    p13 =  (exp(v_4_s1(1,1).*invtp)./nansum(exp(v_4_s1(1,[1,3]).*invtp))); p31 = 1 - p13;
    p23 =  (exp(v_4_s1(2,2).*invtp)./nansum(exp(v_4_s1(2,[2,3]).*invtp))); p32 = 1 - p23;
    v_4_s2(1,:) = [v_zero(1) + 2*delta, v_zero(2) - delta,   v_zero(3) - delta, v_zero(4)]; % choose 1*2: P12*P13
    v_4_s2(2,:) = [v_zero(1) - delta,   v_zero(2) + 2*delta, v_zero(3) - delta, v_zero(4)]; % choose 2*2: P21*P23 = (1-P12)*P23
    v_4_s2(3,:) = [v_zero(1),           v_zero(2) - delta,   v_zero(3) + delta, v_zero(4)]; % choose 1&3: P12*P31 = P12*(1-P13)
    v_4_s2(4,:) = [v_zero(1) - delta,   v_zero(2),           v_zero(3) + delta, v_zero(4)]; % choose 2&3: P21*P32 = (1-P12)*(1-P23)
    
    % step 3
    p14   = (exp(v_4_s2(1,1).*invtp)./nansum(exp(v_4_s2(1,[1,4]).*invtp))); p41 = 1 - p14;
    p24   = (exp(v_4_s2(2,2).*invtp)./nansum(exp(v_4_s2(2,[2,4]).*invtp))); p42 = 1 - p24;
    p34   = (exp(v_4_s2(3,3).*invtp)./nansum(exp(v_4_s2(3,[3,4]).*invtp))); p43 = 1 - p34; 
%     % p34_1 equals p34_2 given that v_4_s2(3,3:4) equals v_4_s2(3,3:4)
%     p34_1 = (exp(v_4_s2(3,3).*invtp)./nansum(exp(v_4_s2(3,[3,4]).*invtp)));
%     p34_2 = (exp(v_4_s2(4,3).*invtp)./nansum(exp(v_4_s2(4,[3,4]).*invtp)));   
    v_4(1,:) = [v_zero(1) + 3 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta]; % chose 1*3 p12*p13*p14
    v_4(2,:) = [v_zero(1) - delta,     v_zero(2) + 3 * delta,   v_zero(3) - delta,     v_zero(4) - delta]; % chose 2*3 p21*p23*p24     = (1-p12)*p23*p24
    v_4(3,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + 2 * delta, v_zero(4) - delta]; % chose 1&3 p12*p31*p34_1   = p12*(1-p13)*p34_1
    v_4(4,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + 2 * delta, v_zero(4) - delta]; % chose 2&3 p21*p32*p34_2   = (1-p12)*(1-p23)*p34_2    
    v_4(5,:) = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) + delta]; % chose 1&4 p12*p13*p41     = p12*p13*(1- p14)
    v_4(6,:) = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4) + delta]; % chose 2&4 p21*p23*p42     = (1-p12)*p23*(1- p24)    
    v_4(7,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4) + delta]; % chose 1&3&4 p12*p31*p43_1 = p12*(1-p13)*(1- p34_1)
    v_4(8,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4) + delta]; % chose 2&3&4 p21*p32*p43_2 = (1-p12)*(1-p23)*(1- p34_2)

    % possibilities to end up by one of the 8 routes
    p_s123(1) = p12 * p13 * p14;  % 1*3
    p_s123(2) = p21 * p23 * p24;  % 2*3
    p_s123(3) = p12 * p31 * p34;  % 1&3
    p_s123(4) = p21 * p32 * p34;  % 2&3
    p_s123(5) = p12 * p13 * p41;  % 1&4
    p_s123(6) = p21 * p23 * p42;  % 2&4
    p_s123(7) = p12 * p31 * p43;  % 1&3&4
    p_s123(8) = p21 * p32 * p43;  % 2&3&4
    
    p_4_final = NaN(n_possibilities,items_number);
    % choice_probability
    for possib = 1:n_possibilities
        for option = 1:items_number
            p_4_final(possib,option) = p_s123(possib).* (exp(v_4(possib,option).*inv_temp_general)./nansum(exp(v_4(possib,:).*inv_temp_general)));
        end
    end
    kx = sum(p_4_final);

%% 4 item scenario, 16 possibilities    
elseif items_number == 5
    % step 1
    p12 = (exp(v_zero(1).*invtp)./nansum(exp(v_zero(1:2).*invtp))); p21 = 1 - p12;
    v_5_s1(1,:) = [v_zero(1) + delta, v_zero(2) - delta, v_zero(3), v_zero(4), v_zero(5)];  % possibility that option 1 wins
    v_5_s1(2,:) = [v_zero(1) - delta, v_zero(2) + delta, v_zero(3), v_zero(4), v_zero(5)];  % possibility that option 2 wins
    
    % step 2
    p13 = (exp(v_5_s1(1,1).*invtp)./nansum(exp(v_5_s1(1,[1,3]).*invtp))); p31 = 1 - p13;
    p23 = (exp(v_5_s1(2,2).*invtp)./nansum(exp(v_5_s1(2,[2,3]).*invtp))); p32 = 1 - p23;
    v_5_s2(1,:) = [v_zero(1) + 2*delta, v_zero(2) - delta,   v_zero(3) - delta, v_zero(4), v_zero(5)]; % choose 1*2: P12*P13
    v_5_s2(2,:) = [v_zero(1) - delta,   v_zero(2) + 2*delta, v_zero(3) - delta, v_zero(4), v_zero(5)]; % choose 2*2: P21*P23 = (1-P12)*P23
    v_5_s2(3,:) = [v_zero(1),           v_zero(2) - delta,   v_zero(3) + delta, v_zero(4), v_zero(5)]; % choose 1&3: P12*P31 = P12*(1-P13)
    v_5_s2(4,:) = [v_zero(1) - delta,   v_zero(2),           v_zero(3) + delta, v_zero(4), v_zero(5)]; % choose 2&3: P21*P32 = (1-P12)*(1-P23)
    
    % step 3
    p14   = (exp(v_5_s2(1,1).*invtp)./nansum(exp(v_5_s2(1,[1,4]).*invtp))); p41 = 1 - p14;
    p24   = (exp(v_5_s2(2,2).*invtp)./nansum(exp(v_5_s2(2,[2,4]).*invtp))); p42 = 1 - p24;
    p34   = (exp(v_5_s2(3,3).*invtp)./nansum(exp(v_5_s2(3,[3,4]).*invtp))); p43 = 1 - p34;
%    % p34 = p34_1 = p34_2
%     p34_1 = (exp(v_5_s2(3,3).*invtp)./nansum(exp(v_5_s2(3,[3,4]).*invtp)));
%     p34_2 = (exp(v_5_s2(4,3).*invtp)./nansum(exp(v_5_s2(4,[3,4]).*invtp)));
    v_5_s3(1,:) = [v_zero(1) + 3 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta, v_zero(5)]; % chose 1*3 p12*p13*p14
    v_5_s3(2,:) = [v_zero(1) - delta,     v_zero(2) + 3 * delta,   v_zero(3) - delta,     v_zero(4) - delta, v_zero(5)]; % chose 2*3 p21*p23*p24     = (1-p12)*p23*p24
    v_5_s3(3,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + 2 * delta, v_zero(4) - delta, v_zero(5)]; % chose 1&3 p12*p31*p34_1   = p12*(1-p13)*p34_1
    v_5_s3(4,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + 2 * delta, v_zero(4) - delta, v_zero(5)]; % chose 2&3 p21*p32*p34_2   = (1-p12)*(1-p23)*p34_2    
    v_5_s3(5,:) = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) + delta, v_zero(5)]; % chose 1&4 p12*p13*p41     = p12*p13*(1- p14)
    v_5_s3(6,:) = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4) + delta, v_zero(5)]; % chose 2&4 p21*p23*p42     = (1-p12)*p23*(1- p24)    
    v_5_s3(7,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4) + delta, v_zero(5)]; % chose 1&3&4 p12*p31*p43_1 = p12*(1-p13)*(1- p34_1)
    v_5_s3(8,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4) + delta, v_zero(5)]; % chose 2&3&4 p21*p32*p43_2 = (1-p12)*(1-p23)*(1- p34_2)

    % step 4
    p15    = (exp(v_5_s3(1,1).*invtp)./nansum(exp(v_5_s3(1,[1,5]).*invtp))); p51 = 1 - p15;
    p25    = (exp(v_5_s3(2,2).*invtp)./nansum(exp(v_5_s3(2,[2,5]).*invtp))); p52 = 1 - p25;
    p35    = (exp(v_5_s3(3,3).*invtp)./nansum(exp(v_5_s3(3,[3,5]).*invtp))); p53 = 1 - p35;    
    p45    = (exp(v_5_s3(5,4).*invtp)./nansum(exp(v_5_s3(5,[4,5]).*invtp))); p54 = 1 - p45;
%     % p35_1 equals p35_2    
%     p35_1  = (exp(v_5_s3(3,3).*invtp)./nansum(exp(v_5_s3(3,[3,5]).*invtp)));
%     p35_2  = (exp(v_5_s3(4,3).*invtp)./nansum(exp(v_5_s3(4,[3,5]).*invtp)));
%     % p45_1 & p45_2 & p45_13 & p45_23 are euqal
%     p45_1  = (exp(v_5_s3(5,4).*invtp)./nansum(exp(v_5_s3(5,[4,5]).*invtp)));
%     p45_2  = (exp(v_5_s3(6,4).*invtp)./nansum(exp(v_5_s3(6,[4,5]).*invtp)));
%     p45_13 = (exp(v_5_s3(7,4).*invtp)./nansum(exp(v_5_s3(7,[4,5]).*invtp)));
%     p45_23 = (exp(v_5_s3(8,4).*invtp)./nansum(exp(v_5_s3(8,[4,5]).*invtp)));   
    v_5(1,:)  = [v_zero(1) + 4 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta,     v_zero(5) - delta]; % chose 1*4: p12 * p13 * p14 * p15
    v_5(2,:)  = [v_zero(1) - delta,     v_zero(2) + 4 * delta,   v_zero(3) - delta,     v_zero(4) - delta,     v_zero(5) - delta]; % chose 2*4: p21 * p23 * p24 * p25;
    v_5(3,:)  = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + 3 * delta, v_zero(4) - delta,     v_zero(5) - delta]; % chose 1&3: p12 * p31 * p34 * p35;
    v_5(4,:)  = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + 3 * delta, v_zero(4) - delta,     v_zero(5) - delta]; % chose 2&3: p21 * p32 * p34 * p35;  
    v_5(5,:)  = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) + 2 * delta, v_zero(5) - delta]; % chose 1&4: p12 * p13 * p41 * p45;
    v_5(6,:)  = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4) + 2 * delta, v_zero(5) - delta]; % chose 2&4: p21 * p23 * p42 * p45;       
    v_5(7,:)  = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4) + 2 * delta, v_zero(5) - delta]; % chose 1&3&4: p12 * p31 * p43 * p45;
    v_5(8,:)  = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4) + 2 * delta, v_zero(5) - delta]; % chose 2&3&4: p21 * p32 * p43 * p45;
    v_5(9,:)  = [v_zero(1) + 2 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta,     v_zero(5) + delta]; % chose 1&5: p12 * p13 * p14 * p51; 
    v_5(10,:) = [v_zero(1) - delta,     v_zero(2) + 2 * delta,   v_zero(3) - delta,     v_zero(4) - delta,     v_zero(5) + delta]; % chose 2&5: p21 * p23 * p24 * p52;    
    v_5(11,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + delta,     v_zero(4) - delta,     v_zero(5) + delta]; % chose 1&3&5: p12 * p31 * p34 * p53; 
    v_5(12,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + delta,     v_zero(4) - delta,     v_zero(5) + delta]; % chose 2&3&5: p21 * p32 * p34 * p53;    
    v_5(13,:) = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4),             v_zero(5) + delta]; % chose 1&4&5: p12 * p13 * p41 * p54;
    v_5(14,:) = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4),             v_zero(5) + delta]; % chose 2&4&5: p21 * p23 * p42 * p54;
    v_5(15,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4),             v_zero(5) + delta]; % chose 1&3&4&5: p12 * p31 * p43 * p54;
    v_5(16,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4),             v_zero(5) + delta]; % chose 2&3&4&5:  p21 * p32 * p43 * p54; 
    
    % possibilities to end up by one of the 16 routes
    p_s1234(1)  = p12 * p13 * p14 * p15;   % 1*4
    p_s1234(2)  = p21 * p23 * p24 * p25;   % 2*4
    p_s1234(3)  = p12 * p31 * p34 * p35;   % 1&3
    p_s1234(4)  = p21 * p32 * p34 * p35;   % 2&3
    p_s1234(5)  = p12 * p13 * p41 * p45;   % 1&4
    p_s1234(6)  = p21 * p23 * p42 * p45;   % 2&4
    p_s1234(7)  = p12 * p31 * p43 * p45;   % 1&3&4
    p_s1234(8)  = p21 * p32 * p43 * p45;   % 2&3&4  
    p_s1234(9)  = p12 * p13 * p14 * p51;   % 1&5
    p_s1234(10) = p21 * p23 * p24 * p52;   % 2&5
    p_s1234(11) = p12 * p31 * p34 * p53;   % 1&3&5
    p_s1234(12) = p21 * p32 * p34 * p53;   % 2&3&5
    p_s1234(13) = p12 * p13 * p41 * p54;   % 1&4&5
    p_s1234(14) = p21 * p23 * p42 * p54;   % 2&4&5
    p_s1234(15) = p12 * p31 * p43 * p54;   % 1&3&4&5
    p_s1234(16) = p21 * p32 * p43 * p54;   % 2&3&4&5
    
    p_5_final = NaN(n_possibilities,items_number);
    % choice_probability
    for possib = 1:n_possibilities
        for option = 1:items_number
            p_5_final(possib,option) = p_s1234(possib).* (exp(v_5(possib,option).*inv_temp_general)./nansum(exp(v_5(possib,:).*inv_temp_general)));
        end
    end
    kx = sum(p_5_final);
    
%% 6 item scenario, 32 possibilities    
elseif items_number == 6
    % step 1
    p12 = (exp(v_zero(1).*invtp)./nansum(exp(v_zero(1:2).*invtp))); p21 = 1 - p12;
    v_6_s1(1,:) = [v_zero(1) + delta, v_zero(2) - delta, v_zero(3), v_zero(4), v_zero(5), v_zero(6)];  % possibility that option 1 wins
    v_6_s1(2,:) = [v_zero(1) - delta, v_zero(2) + delta, v_zero(3), v_zero(4), v_zero(5), v_zero(6)];  % possibility that option 2 wins
    
    % step 2
    p13 = (exp(v_6_s1(1,1).*invtp)./nansum(exp(v_6_s1(1,[1,3]).*invtp))); p31 = 1 - p13;
    p23 = (exp(v_6_s1(2,2).*invtp)./nansum(exp(v_6_s1(2,[2,3]).*invtp))); p32 = 1 - p23;
    v_6_s2(1,:) = [v_zero(1) + 2*delta, v_zero(2) - delta,   v_zero(3) - delta, v_zero(4), v_zero(5), v_zero(6)]; % choose 1*2: P12*P13
    v_6_s2(2,:) = [v_zero(1) - delta,   v_zero(2) + 2*delta, v_zero(3) - delta, v_zero(4), v_zero(5), v_zero(6)]; % choose 2*2: P21*P23 = (1-P12)*P23
    v_6_s2(3,:) = [v_zero(1),           v_zero(2) - delta,   v_zero(3) + delta, v_zero(4), v_zero(5), v_zero(6)]; % choose 1&3: P12*P31 = P12*(1-P13)
    v_6_s2(4,:) = [v_zero(1) - delta,   v_zero(2),           v_zero(3) + delta, v_zero(4), v_zero(5), v_zero(6)]; % choose 2&3: P21*P32 = (1-P12)*(1-P23)
    
    % step 3
    p14   = (exp(v_6_s2(1,1).*invtp)./nansum(exp(v_6_s2(1,[1,4]).*invtp))); p41 = 1 - p14;
    p24   = (exp(v_6_s2(2,2).*invtp)./nansum(exp(v_6_s2(2,[2,4]).*invtp))); p42 = 1 - p24;
    p34   = (exp(v_6_s2(3,3).*invtp)./nansum(exp(v_6_s2(3,[3,4]).*invtp))); p43 = 1 - p34;
    v_6_s3(1,:) = [v_zero(1) + 3 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta, v_zero(5), v_zero(6)]; % chose 1*3 p12*p13*p14
    v_6_s3(2,:) = [v_zero(1) - delta,     v_zero(2) + 3 * delta,   v_zero(3) - delta,     v_zero(4) - delta, v_zero(5), v_zero(6)]; % chose 2*3 p21*p23*p24     = (1-p12)*p23*p24
    v_6_s3(3,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + 2 * delta, v_zero(4) - delta, v_zero(5), v_zero(6)]; % chose 1&3 p12*p31*p34_1   = p12*(1-p13)*p34_1
    v_6_s3(4,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + 2 * delta, v_zero(4) - delta, v_zero(5), v_zero(6)]; % chose 2&3 p21*p32*p34_2   = (1-p12)*(1-p23)*p34_2    
    v_6_s3(5,:) = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) + delta, v_zero(5), v_zero(6)]; % chose 1&4 p12*p13*p41     = p12*p13*(1- p14)
    v_6_s3(6,:) = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4) + delta, v_zero(5), v_zero(6)]; % chose 2&4 p21*p23*p42     = (1-p12)*p23*(1- p24)    
    v_6_s3(7,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4) + delta, v_zero(5), v_zero(6)]; % chose 1&3&4 p12*p31*p43_1 = p12*(1-p13)*(1- p34_1)
    v_6_s3(8,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4) + delta, v_zero(5), v_zero(6)]; % chose 2&3&4 p21*p32*p43_2 = (1-p12)*(1-p23)*(1- p34_2)

    % step 4
    p15    = (exp(v_6_s3(1,1).*invtp)./nansum(exp(v_6_s3(1,[1,5]).*invtp))); p51 = 1 - p15;
    p25    = (exp(v_6_s3(2,2).*invtp)./nansum(exp(v_6_s3(2,[2,5]).*invtp))); p52 = 1 - p25;
    p35    = (exp(v_6_s3(3,3).*invtp)./nansum(exp(v_6_s3(3,[3,5]).*invtp))); p53 = 1 - p35;    
    p45    = (exp(v_6_s3(5,4).*invtp)./nansum(exp(v_6_s3(5,[4,5]).*invtp))); p54 = 1 - p45;
    v_6_s4(1,:)  = [v_zero(1) + 4 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta,     v_zero(5) - delta, v_zero(6)]; % chose 1*4: p12 * p13 * p14 * p15
    v_6_s4(2,:)  = [v_zero(1) - delta,     v_zero(2) + 4 * delta,   v_zero(3) - delta,     v_zero(4) - delta,     v_zero(5) - delta, v_zero(6)]; % chose 2*4: p21 * p23 * p24 * p25;
    v_6_s4(3,:)  = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + 3 * delta, v_zero(4) - delta,     v_zero(5) - delta, v_zero(6)]; % chose 1&3: p12 * p31 * p34 * p35;
    v_6_s4(4,:)  = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + 3 * delta, v_zero(4) - delta,     v_zero(5) - delta, v_zero(6)]; % chose 2&3: p21 * p32 * p34 * p35;  
    v_6_s4(5,:)  = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) + 2 * delta, v_zero(5) - delta, v_zero(6)]; % chose 1&4: p12 * p13 * p41 * p45;
    v_6_s4(6,:)  = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4) + 2 * delta, v_zero(5) - delta, v_zero(6)]; % chose 2&4: p21 * p23 * p42 * p45;       
    v_6_s4(7,:)  = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4) + 2 * delta, v_zero(5) - delta, v_zero(6)]; % chose 1&3&4: p12 * p31 * p43 * p45;
    v_6_s4(8,:)  = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4) + 2 * delta, v_zero(5) - delta, v_zero(6)]; % chose 2&3&4: p21 * p32 * p43 * p45;  
    v_6_s4(9,:)  = [v_zero(1) + 2 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta,     v_zero(5) + delta, v_zero(6)]; % chose 1&5: p12 * p13 * p14 * p51; 
    v_6_s4(10,:) = [v_zero(1) - delta,     v_zero(2) + 2 * delta,   v_zero(3) - delta,     v_zero(4) - delta,     v_zero(5) + delta, v_zero(6)]; % chose 2&5: p21 * p23 * p24 * p52;    
    v_6_s4(11,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + delta,     v_zero(4) - delta,     v_zero(5) + delta, v_zero(6)]; % chose 1&3&5: p12 * p31 * p34 * p53; 
    v_6_s4(12,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + delta,     v_zero(4) - delta,     v_zero(5) + delta, v_zero(6)]; % chose 2&3&5: p21 * p32 * p34 * p53;    
    v_6_s4(13,:) = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4),             v_zero(5) + delta, v_zero(6)]; % chose 1&4&5: p12 * p13 * p41 * p54;
    v_6_s4(14,:) = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4),             v_zero(5) + delta, v_zero(6)]; % chose 2&4&5: p21 * p23 * p42 * p54;
    v_6_s4(15,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4),             v_zero(5) + delta, v_zero(6)]; % chose 1&3&4&5: p12 * p31 * p43 * p54;
    v_6_s4(16,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4),             v_zero(5) + delta, v_zero(6)]; % chose 2&3&4&5:  p21 * p32 * p43 * p54; 
        
    % step 5
    p16    = (exp(v_6_s4(1,1).*invtp)./nansum(exp(v_6_s4(1,[1,6]).*invtp))); p61 = 1 - p16;
    p26    = (exp(v_6_s4(2,2).*invtp)./nansum(exp(v_6_s4(2,[2,6]).*invtp))); p62 = 1 - p26; 
    p36    = (exp(v_6_s4(3,3).*invtp)./nansum(exp(v_6_s4(3,[3,6]).*invtp))); p63 = 1 - p36;  % 1&3 v_6_s4(3,:) = 2&3 v_6_s4(4,:)
    p46    = (exp(v_6_s4(5,4).*invtp)./nansum(exp(v_6_s4(5,[4,6]).*invtp))); p64 = 1 - p46;  % v_6_s4(5:8,4) are of the same value
    p56    = (exp(v_6_s4(9,5).*invtp)./nansum(exp(v_6_s4(9,[5,6]).*invtp))); p65 = 1 - p56;
   
    v_6(1,:)  = [v_zero(1) + 5 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta,      v_zero(5) - delta,     v_zero(6) - delta]; % chose 1*5:     p12 * p13 * p14 * p15 * p16; 
    v_6(2,:)  = [v_zero(1) - delta,     v_zero(2) + 5 * delta,   v_zero(3) - delta,     v_zero(4) - delta,      v_zero(5) - delta,     v_zero(6) - delta]; % chose 2*4:     p21 * p23 * p24 * p25 * p26;
    v_6(3,:)  = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + 4 * delta, v_zero(4) - delta,      v_zero(5) - delta,     v_zero(6) - delta]; % chose 1&3:     p12 * p31 * p34 * p35 * p36;
    v_6(4,:)  = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + 4 * delta, v_zero(4) - delta,      v_zero(5) - delta,     v_zero(6) - delta]; % chose 2&3:     p21 * p32 * p34 * p35 * p36; 
    v_6(5,:)  = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) + 3 * delta,  v_zero(5) - delta,     v_zero(6) - delta]; % chose 1&4:     p12 * p13 * p41 * p45 * p46;
    v_6(6,:)  = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4) + 3 * delta,  v_zero(5) - delta,     v_zero(6) - delta]; % chose 2&4:     p21 * p23 * p42 * p45 * p46; 
    v_6(7,:)  = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4) + 3 * delta,  v_zero(5) - delta,     v_zero(6) - delta]; % chose 1&3&4:   p12 * p31 * p43 * p45 * p46;
    v_6(8,:)  = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4) + 3 * delta,  v_zero(5) - delta,     v_zero(6) - delta]; % chose 2&3&4:   p21 * p32 * p43 * p45 * p46;
    v_6(9,:)  = [v_zero(1) + 2 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta,      v_zero(5) + 2 * delta, v_zero(6) - delta]; % chose 1&5:     p12 * p13 * p14 * p51 * p56; 
    v_6(10,:) = [v_zero(1) - delta,     v_zero(2) + 2 * delta,   v_zero(3) - delta,     v_zero(4) - delta,      v_zero(5) + 2 * delta, v_zero(6) - delta]; % chose 2&5:     p21 * p23 * p24 * p52 * p56;   
    v_6(11,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + delta,     v_zero(4) - delta,      v_zero(5) + 2 * delta, v_zero(6) - delta]; % chose 1&3&5:   p12 * p31 * p34 * p53 * p56; 
    v_6(12,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + delta,     v_zero(4) - delta,      v_zero(5) + 2 * delta, v_zero(6) - delta]; % chose 2&3&5:   p21 * p32 * p34 * p53 * p56;
    v_6(13,:) = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4),              v_zero(5) + 2 * delta, v_zero(6) - delta]; % chose 1&4&5:   p12 * p13 * p41 * p54 * p56;
    v_6(14,:) = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4),              v_zero(5) + 2 * delta, v_zero(6) - delta]; % chose 2&4&5:   p21 * p23 * p42 * p54 * p56; 
    v_6(15,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4),              v_zero(5) + 2 * delta, v_zero(6) - delta]; % chose 1&3&4&5: p12 * p31 * p43 * p54 * p56;
    v_6(16,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4),              v_zero(5) + 2 * delta, v_zero(6) - delta]; % chose 2&3&4&5: p21 * p32 * p43 * p54 * p56;
    v_6(17,:) = [v_zero(1) + 3 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta,      v_zero(5) - delta,     v_zero(6) + delta]; % chose 1&6:     p12 * p13 * p14 * p15 * p61;
    v_6(18,:) = [v_zero(1) - delta,     v_zero(2) + 3 * delta,   v_zero(3) - delta,     v_zero(4) - delta,      v_zero(5) - delta,     v_zero(6) + delta]; % chose 2&6:     p21 * p23 * p24 * p25 * p62; 
    v_6(19,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + 2 * delta, v_zero(4) - delta,      v_zero(5) - delta,     v_zero(6) + delta]; % chose 1&3&6:   p12 * p31 * p34 * p35 * p63;
    v_6(20,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + 2 * delta, v_zero(4) - delta,      v_zero(5) - delta,     v_zero(6) + delta]; % chose 2&3&6:   p21 * p32 * p34 * p35 * p63; 
    v_6(21,:) = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) + delta,      v_zero(5) - delta,     v_zero(6) + delta]; % chose 1&4&6:   p12 * p13 * p41 * p45 * p64;
    v_6(22,:) = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4) + delta,      v_zero(5) - delta,     v_zero(6) + delta]; % chose 2&4&6:   p21 * p23 * p42 * p45 * p64;
    v_6(23,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4) + delta,      v_zero(5) - delta,     v_zero(6) + delta]; % chose 1&3&4&6: p12 * p31 * p43 * p45 * p64;
    v_6(24,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4) + delta,      v_zero(5) - delta,     v_zero(6) + delta]; % chose 2&3&4&6: p21 * p32 * p43 * p45 * p64;   
    v_6(25,:) = [v_zero(1) + 2 * delta, v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4) - delta,      v_zero(5),             v_zero(6) + delta]; % chose 1&5&6:   p12 * p13 * p14 * p51 * p65; 
    v_6(26,:) = [v_zero(1) - delta,     v_zero(2) + 2 * delta,   v_zero(3) - delta,     v_zero(4) - delta,      v_zero(5),             v_zero(6) + delta]; % chose 2&5&6:   p21 * p23 * p24 * p52 * p65;   
    v_6(27,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3) + delta,     v_zero(4) - delta,      v_zero(5),             v_zero(6) + delta]; % chose 1&3&5&6: p12 * p31 * p34 * p53 * p65; 
    v_6(28,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3) + delta,     v_zero(4) - delta,      v_zero(5),             v_zero(6) + delta]; % chose 2&3&5&6: p21 * p32 * p34 * p53 * p65;    
    v_6(29,:) = [v_zero(1) + delta,     v_zero(2) - delta,       v_zero(3) - delta,     v_zero(4),              v_zero(5),             v_zero(6) + delta]; % chose 1&4&5&6: p12 * p13 * p41 * p54 * p65;
    v_6(30,:) = [v_zero(1) - delta,     v_zero(2) + delta,       v_zero(3) - delta,     v_zero(4),              v_zero(5),             v_zero(6) + delta]; % chose 2&4&5&6: p21 * p23 * p42 * p54 * p65;
    v_6(31,:) = [v_zero(1),             v_zero(2) - delta,       v_zero(3),             v_zero(4),              v_zero(5),             v_zero(6) + delta]; % chose 1&3&4&5&6: p12 * p31 * p43 * p54 * p65;
    v_6(32,:) = [v_zero(1) - delta,     v_zero(2),               v_zero(3),             v_zero(4),              v_zero(5),             v_zero(6) + delta]; % chose 2&3&4&5&6: p21 * p32 * p43 * p54 * p65; 

    % possibilities to end up by one of the 32 routes
    p_s12345(1)  = p12 * p13 * p14 * p15 * p16;   % 1*5
    p_s12345(2)  = p21 * p23 * p24 * p25 * p26;   % 2*5
    p_s12345(3)  = p12 * p31 * p34 * p35 * p36;   % 1&3
    p_s12345(4)  = p21 * p32 * p34 * p35 * p36;   % 2&3
    p_s12345(5)  = p12 * p13 * p41 * p45 * p46;   % 1&4
    p_s12345(6)  = p21 * p23 * p42 * p45 * p46;   % 2&4
    p_s12345(7)  = p12 * p31 * p43 * p45 * p46;   % 1&3&4
    p_s12345(8)  = p21 * p32 * p43 * p45 * p46;   % 2&3&4  
    p_s12345(9)  = p12 * p13 * p14 * p51 * p56;   % 1&5
    p_s12345(10) = p21 * p23 * p24 * p52 * p56;   % 2&5
    p_s12345(11) = p12 * p31 * p34 * p53 * p56;   % 1&3&5
    p_s12345(12) = p21 * p32 * p34 * p53 * p56;   % 2&3&5
    p_s12345(13) = p12 * p13 * p41 * p54 * p56;   % 1&4&5
    p_s12345(14) = p21 * p23 * p42 * p54 * p56;   % 2&4&5
    p_s12345(15) = p12 * p31 * p43 * p54 * p56;   % 1&3&4&5
    p_s12345(16) = p21 * p32 * p43 * p54 * p56;   % 2&3&4&5

    p_s12345(17) = p12 * p13 * p14 * p15 * p61;   % 1&6
    p_s12345(18) = p21 * p23 * p24 * p25 * p62;   % 2&6
    p_s12345(19) = p12 * p31 * p34 * p35 * p63;   % 1&3&6
    p_s12345(20) = p21 * p32 * p34 * p35 * p63;   % 2&3&6
    p_s12345(21) = p12 * p13 * p41 * p45 * p64;   % 1&4&6
    p_s12345(22) = p21 * p23 * p42 * p45 * p64;   % 2&4&6
    p_s12345(23) = p12 * p31 * p43 * p45 * p64;   % 1&3&4&6
    p_s12345(24) = p21 * p32 * p43 * p45 * p64;   % 2&3&4&6   
    p_s12345(25) = p12 * p13 * p14 * p51 * p65;   % 1&5&6
    p_s12345(26) = p21 * p23 * p24 * p52 * p65;   % 2&5&6
    p_s12345(27) = p12 * p31 * p34 * p53 * p65;   % 1&3&5&6
    p_s12345(28) = p21 * p32 * p34 * p53 * p65;   % 2&3&5&6
    p_s12345(29) = p12 * p13 * p41 * p54 * p65;   % 1&4&5&6
    p_s12345(30) = p21 * p23 * p42 * p54 * p65;   % 2&4&5&6
    p_s12345(31) = p12 * p31 * p43 * p54 * p65;   % 1&3&4&5&6
    p_s12345(32) = p21 * p32 * p43 * p54 * p65;   % 2&3&4&5&6
    
    p_6_final = NaN(n_possibilities,items_number);
    % choice_probability
    for possib = 1:n_possibilities
        for option = 1:items_number
            p_6_final(possib,option) = p_s12345(possib).* (exp(v_6(possib,option).*inv_temp_general)./nansum(exp(v_6(possib,:).*inv_temp_general)));
        end
    end
    kx = sum(p_6_final);    
end

gx = zeros(6,1);
gx(1:items_number,1) = kx;
 
end
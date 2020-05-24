function  [fx] = evo_010_v3(x,P,u,in)

alpha = P(1);
ID_items = u(3:8);
ID_items =(ID_items(~isnan(ID_items)));
v_zero = x(ID_items);


%% previous way as in evo_010
% winning_index = 1;
% k = 1;
% while k <= length(v_zero) -1
%     if v_zero(winning_index) >= v_zero(k+1)                                                                % the previous winning option is the better of the two
%         defeat_index = k+ 1; % winning_index stay unchanged;
%         v_zero(defeat_index) = v_zero(defeat_index) - alpha;
%         v_zero(winning_index) = v_zero(winning_index) + alpha;
%         
%     elseif v_zero(winning_index) < v_zero(k+1)  % if the new option is winning
%         defeat_index = winning_index;
%         winning_index = k + 1;
%         v_zero(defeat_index ) = v_zero(defeat_index ) - alpha;
%         v_zero(winning_index) = v_zero(winning_index) + alpha;
%         
%     elseif v_zero(winning_index) == v_zero(k+1)  % if the two options have the same value, flip a coin to decide which wins
%         coin = rand(1);
%         if coin >= 0.5
%             defeat_index = k+1; % winning_index stay unchanged;
%         elseif coin <0.5
%             defeat_index = winning_index;
%             winning_index = k+1;
%         end
%         v_zero(defeat_index ) = v_zero(defeat_index ) - alpha;
%         v_zero(winning_index) = v_zero(winning_index) + alpha;
%     end
%     k = k + 1;
% end
%% bonus version 1
windex = 1;
v_zero(windex) = v_zero(windex) + alpha;
for k = 2:length(v_zero)
    if v_zero(windex) < v_zero(k)
        windex = k;
    end
    v_zero(windex) = v_zero(windex) + alpha;
end
v_zero = v_zero - alpha;
v_zero(windex) = v_zero(windex) + alpha;

items_clicks = u(15: end);
hm =u(16: end);
hm = hm(hm~=0);

if ~isempty (hm)
    for w = 1: length(hm+1)
        if v_zero(windex)< v_zero(items_clicks(w))
            v_zero(windex) = v_zero(windex) - alpha;
            v_zero(items_clicks(w)) = v_zero(items_clicks(w)) + alpha;
            windex = items_clicks(w);
        elseif v_zero(windex) > v_zero(items_clicks(w))
            v_zero(windex) = v_zero(windex) + alpha;
            v_zero(items_clicks(w)) = v_zero(items_clicks(w)) - alpha;
        end
    end
end




%%
x(ID_items) = v_zero;
fx = x;

end

function  [ gx ] = obs_000_chosen_evo_v3(x,P,u,in)
inv_temp = safepos(P(1));
alpha = P(2);

% get the value variables
ID_items = u(3:8);
ID_items =(ID_items(~isnan(ID_items)));
v_zero = x(ID_items);

%% within trial updating
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

items_clicks = u(15: end-1);
hm =u(16: end-1);
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

% the prediction needs to be aglined with the dimension of the input y,
% although some y values have been ignored due to trial property
gx = zeros(1,6);
for k = 1:length(v_zero)
    gx(k) = (exp(v_zero(k).*inv_temp)./nansum(exp(v_zero.*inv_temp)));
end

gx = gx';
end
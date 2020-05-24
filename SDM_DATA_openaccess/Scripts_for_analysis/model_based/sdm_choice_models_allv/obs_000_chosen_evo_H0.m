function  [ gx ] = obs_000_chosen_evo(x,P,u,in)
inv_temp = safepos(P(1));
alpha = 0;

% get the value variables
ID_items = u(3:8);
ID_items =(ID_items(~isnan(ID_items)));
v_zero = x(ID_items);

%% within trial updating
windex = 1;
v_zero(windex) = v_zero(windex) + alpha;
for k = 2:length(v_zero)
    if v_zero(windex) < v_zero(k) % || (v_zero(windex) == v_zero(k) && rand(1) < 0.5)
        windex = k;
    end
    v_zero(windex) = v_zero(windex) + alpha;
end
v_zero = v_zero - alpha;
v_zero(windex) = v_zero(windex) + alpha;


% the prediction needs to be aglined with the dimension of the input y,
% although some y values have been ignored due to trial property
gx = zeros(1,6);
for k = 1:length(v_zero)
    gx(k) = (exp(v_zero(k).*inv_temp)./nansum(exp(v_zero.*inv_temp)));
end

gx = gx';
end
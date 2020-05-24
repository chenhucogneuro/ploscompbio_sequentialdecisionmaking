function  [ gx ] = allobs_bbc(x,P,u,in)
    inv_temp = safepos(P(1));
    alpha = P(2);

    % get the value variables
    Value_items = u(9:14);
    Value_items =(Value_items(~isnan(Value_items)));
    v_zero = Value_items;

    %% bonus version 1
    windex = 1;
    % v_zero(windex) = v_zero(windex) + alpha;

    for k = 2:length(v_zero)
        if v_zero(windex) < v_zero(k) % || (v_zero(windex) == v_zero(k) && rand(1) < 0.5)
            windex = k;
        end
        v_zero(windex) = v_zero(windex) + alpha;
    end
    v_zero = v_zero - alpha;
    v_zero(windex) = v_zero(windex) + alpha;

    %% softmax
    gx = zeros(6,1);
    for k = 1:length(v_zero)
        gx(k) = (exp(v_zero(k).*inv_temp)./nansum(exp(v_zero.*inv_temp)));
    end


end
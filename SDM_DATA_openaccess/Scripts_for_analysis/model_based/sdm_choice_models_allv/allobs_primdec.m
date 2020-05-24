function  [ gx ] = allobs_primdec(x,P,u,in)
    inv_temp = safepos(P(1));
    alpha = abs(P(2));
    % alpha = 1./(1 + exp(-P(2)));

    % get the value variables
    Value_items = u(9:14);
    Value_items =(Value_items(~isnan(Value_items)));
    v_zero = Value_items;

    %%  primacy effect
        for i = 1:length(v_zero)
            v_zero(i) = v_zero(i) + alpha^(i);
        end


    %% softmax
    gx = zeros(6,1);
    for k = 1:length(v_zero)
        gx(k) = (exp(v_zero(k).*inv_temp)./nansum(exp(v_zero.*inv_temp)));
    end



end
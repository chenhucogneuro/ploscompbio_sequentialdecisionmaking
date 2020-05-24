function  [ gx ] = allobs_pairwise(x,P,u,in)
inv_temp = safepos(P(1));
% alpha = P(2);

% get the value variables
Value_items = u(9:14);
Value_items =(Value_items(~isnan(Value_items)));
v_zero = Value_items;

% pairwise comparison
    p = zeros(6);
    p(1,1) = 1;
    % v_zero(1,1) = v_zero(1,1)+ alpha;
    for n = 1:(length(v_zero) - 1)
        for i = 1:n
            p(n+1,i) = p(n,i)*exp(v_zero(i).*inv_temp)/(exp(v_zero(i).*inv_temp) + exp(v_zero(n+1).*inv_temp));
        end
        p(n+1,n+1) = 1 - sum(p(n+1,1:n));
       % v_zero(1:n+1) = v_zero(1:n+1) + alpha;
    end
    gx = p(n+1,:)';

end
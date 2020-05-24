function  [fx] = evo_chosen_global(x,P,u,in)

cbonus = P(1);
ID_items = u(3:8);
ID_items =(ID_items(~isnan(ID_items)));
v_zero = x(ID_items);

which_choice = u(end);
if which_choice <7
    v_zero(which_choice) = v_zero(which_choice) + cbonus;
end

x(ID_items) = v_zero;
fx = x;

end

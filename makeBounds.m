function [lb, ub] = makeBounds(M, w_min, w_max, u1_min, u1_max, u2_min, u2_max, s_min, s_max)
D = 5*M;
lb = zeros(1,D);
ub = zeros(1,D);

idx = 1;
for i = 1:M
    % w
    lb(idx)=w_min; ub(idx)=w_max; idx=idx+1;
    % c1
    lb(idx)=u1_min; ub(idx)=u1_max; idx=idx+1;
    % c2
    lb(idx)=u2_min; ub(idx)=u2_max; idx=idx+1;
    % s1
    lb(idx)=s_min; ub(idx)=s_max; idx=idx+1;
    % s2
    lb(idx)=s_min; ub(idx)=s_max; idx=idx+1;
end
end

function [w, c1, c2, s1, s2] = decodeChromosome(x, M)
% x = [w1 c11 c21 s11 s21  w2 c12 c22 s12 s22 ...]
w  = zeros(M,1);
c1 = zeros(M,1);
c2 = zeros(M,1);
s1 = zeros(M,1);
s2 = zeros(M,1);

idx = 1;
for i = 1:M
    w(i)  = x(idx); idx = idx+1;
    c1(i) = x(idx); idx = idx+1;
    c2(i) = x(idx); idx = idx+1;
    s1(i) = x(idx); idx = idx+1;
    s2(i) = x(idx); idx = idx+1;
end
end

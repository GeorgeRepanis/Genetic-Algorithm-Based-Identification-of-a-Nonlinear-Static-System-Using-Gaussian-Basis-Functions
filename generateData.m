function [U, y] = generateData(N, u1_min, u1_max, u2_min, u2_max)
% N τυχαία σημεία (uniform) μέσα στα όρια και y = f(u1,u2)

u1 = u1_min + (u1_max-u1_min)*rand(N,1);
u2 = u2_min + (u2_max-u2_min)*rand(N,1);

U = [u1, u2];
y = f_true(u1, u2);
end

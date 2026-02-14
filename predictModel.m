function yhat = predictModel(U, x, M)
% U: Nx2
% x: 1x(5M)
% yhat: Nx1

u1 = U(:,1);
u2 = U(:,2);

[w, c1, c2, s1, s2] = decodeChromosome(x, M);

N = size(U,1);
yhat = zeros(N,1);

for i = 1:M
    % Gaussian basis
    g = exp( - ((u1 - c1(i)).^2 ./ (2*s1(i)^2) + (u2 - c2(i)).^2 ./ (2*s2(i)^2)) );
    yhat = yhat + w(i)*g;
end
end

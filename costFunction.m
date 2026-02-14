function J = costFunction(x, U, y, M, usePenalty, lambda)
yhat = predictModel(U, x, M);
e = y - yhat;
J = mean(e.^2);

if usePenalty
    [w, ~, ~, ~, ~] = decodeChromosome(x, M);
    J = J + lambda*sum(abs(w));   % απλή "ποινή" για να σβήνουν βάσεις
end
end

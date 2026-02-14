function x = mutate(x, pm, mutScale, lb, ub)
% mutation ανά γονίδιο: με πιθανότητα pm προσθέτουμε Gaussian θόρυβο
range = (ub - lb);

for j = 1:length(x)
    if rand < pm
        x(j) = x(j) + mutScale*range(j)*randn;
    end
end
% clamp bounds
x = min(max(x, lb), ub);
end

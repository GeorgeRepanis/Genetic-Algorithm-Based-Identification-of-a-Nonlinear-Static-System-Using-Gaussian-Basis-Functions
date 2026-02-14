%% GA_main.m
clear; clc; close all;

%% 1) Ρυθμίσεις / Σταθερές προβλήματος
rng(1);                         % για επαναληψιμότητα

M = 15;                         % max Gaussians
D = 5*M;                        % 75 μεταβλητές (w,c1,c2,s1,s2 για καθε Gaussian)

% Domain εισόδων
u1_min = -1;  u1_max =  2;
u2_min = -2;  u2_max =  1;

% Bounds παραμέτρων
w_min = -2;  w_max = 2;
s_min = 0.1; s_max = 1.5;

[lb, ub] = makeBounds(M, w_min, w_max, u1_min, u1_max, u2_min, u2_max, s_min, s_max);

%% 2) Δημιουργία δεδομένων train/test
Ntrain = 1000;
Ntest  = 1000;

[Utrain, ytrain] = generateData(Ntrain, u1_min, u1_max, u2_min, u2_max);
[Utest,  ytest ] = generateData(Ntest,  u1_min, u1_max, u2_min, u2_max);

%% 3) Ρυθμίσεις GA
P      = 80;       % πληθυσμός
G      = 200;      % γενιές
pc     = 0.85;     % πιθανότητα crossover
pm     = 0.05;     % πιθανότητα mutation ανά γονίδιο
eliteK = 2;        % πόσοι καλύτεροι περνάνε αυτούσιοι
tSize  = 3;        % tournament size

% mutation step (σχετικό με το εύρος)
mutScale = 0.08;   % όσο μικρότερο, τόσο πιο "ήπια" μετάλλαξη

% (προαιρετικό) penalty για "χαμηλή πολυπλοκότητα"
usePenalty = false;
lambda = 1e-3;     % αν usePenalty=true

%% 4) Αρχικοποίηση πληθυσμού
pop = rand(P, D).*(ub-lb) + lb;   % P x D

bestCostHistory = zeros(G,1);

%% 5) GA loop
for gen = 1:G

    % 5.1 Αξιολόγηση κόστους
    costs = zeros(P,1);
    for p = 1:P
        costs(p) = costFunction(pop(p,:), Utrain, ytrain, M, usePenalty, lambda);
    end

    % ταξινόμηση (για elitism)
    [costsSorted, idx] = sort(costs, 'ascend');
    popSorted = pop(idx,:);

    bestCostHistory(gen) = costsSorted(1);
    xBest = popSorted(1,:);

    % Εμφάνιση προόδου
    if mod(gen,20)==0 || gen==1
        fprintf('Gen %3d | best MSE = %.6f\n', gen, costsSorted(1));
    end

    % 5.2 Νέα γενιά
    newPop = zeros(P, D);

    % 5.2.1 Elitism
    newPop(1:eliteK,:) = popSorted(1:eliteK,:);

    % 5.2.2 Γέμισμα υπολοίπου με selection/crossover/mutation
    k = eliteK + 1;
    while k <= P
        % επιλογή γονέων (tournament)
        parentA = popSorted(tournamentSelect(costsSorted, tSize), :);
        parentB = popSorted(tournamentSelect(costsSorted, tSize), :);

        child1 = parentA;
        child2 = parentB;

        % crossover
        if rand < pc
            alpha = rand; % [0,1]
            child1 = alpha*parentA + (1-alpha)*parentB;
            child2 = (1-alpha)*parentA + alpha*parentB;
        end

        % mutation (Gaussian noise σε μερικά γονίδια)
        child1 = mutate(child1, pm, mutScale, lb, ub);
        child2 = mutate(child2, pm, mutScale, lb, ub);

        % clamp bounds (ασφάλεια)
        child1 = min(max(child1, lb), ub);
        child2 = min(max(child2, lb), ub);

        newPop(k,:) = child1;
        if k+1 <= P
            newPop(k+1,:) = child2;
        end
        k = k + 2;
    end

    pop = newPop;
end

%% 6) Τελική αξιολόγηση σε train/test
MSE_train = costFunction(xBest, Utrain, ytrain, M, false, 0);
MSE_test  = costFunction(xBest, Utest,  ytest,  M, false, 0);

fprintf('\nFINAL:\nMSE_train = %.6f\nMSE_test  = %.6f\n', MSE_train, MSE_test);

% Πόσες "ενεργές" βάσεις χρησιμοποιεί
[w, ~, ~, ~, ~] = decodeChromosome(xBest, M);
active = sum(abs(w) > 0.05);
fprintf('Active Gaussians (|w|>0.05): %d / %d\n', active, M);

%% 7) Plots
figure; plot(bestCostHistory, 'LineWidth', 1.5);
xlabel('Generation'); ylabel('Best MSE'); grid on; title('GA Convergence');

% Surface plots σε grid
nGrid = 60;
u1g = linspace(u1_min, u1_max, nGrid);
u2g = linspace(u2_min, u2_max, nGrid);
[U1, U2] = meshgrid(u1g, u2g);
Ug = [U1(:), U2(:)];

fTrue = f_true(Ug(:,1), Ug(:,2));
fHat  = predictModel(Ug, xBest, M);
err   = fTrue - fHat;

figure;
surf(U1, U2, reshape(fTrue, nGrid, nGrid)); shading interp;
xlabel('u1'); ylabel('u2'); zlabel('f'); title('True f(u1,u2)');

figure;
surf(U1, U2, reshape(fHat, nGrid, nGrid)); shading interp;
xlabel('u1'); ylabel('u2'); zlabel('fhat'); title('Estimated \hat{f}(u1,u2)');

figure;
surf(U1, U2, reshape(err, nGrid, nGrid)); shading interp;
xlabel('u1'); ylabel('u2'); zlabel('error'); title('Error: f - \hat{f}');

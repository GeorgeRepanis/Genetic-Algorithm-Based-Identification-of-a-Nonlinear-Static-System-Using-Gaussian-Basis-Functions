function winnerIdx = tournamentSelect(costsSorted, tSize)
% costsSorted είναι ήδη ταξινομημένο (αύξουσα), άρα μικρότερο = καλύτερο
P = length(costsSorted);

candidates = randi(P, tSize, 1);
[~, bestLocal] = min(costsSorted(candidates));
winnerIdx = candidates(bestLocal);
end

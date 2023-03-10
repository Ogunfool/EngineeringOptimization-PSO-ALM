function Retval = Gfun_Project(X)
% function[g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12] = Gfun_Project(X1,X2,X3,X4)

% Inequality constraint vector

% g1 = 0.0193*x(1) - x(3);
% g2 = 0.00954*x(1) - x(4);
% g3
X1 = X(1); X2 = X(2); X3 = X(3); X4 = X(4);
Retval = [(0.0193*X(1) - X(3)), (0.00954*X(1) - X(4)), (1296000 - (pi*X(1)^2*X(2)) - ((4/3)*pi*X(1)^3)), (X(2) - 240), (X(3) - 99), (0.1 - X(3)), ... 
    (X(4) - 99), (0.1 - X(4)), (X(1) - 200), (10 - X(1)), (X(2) - 200), (10 - X(2))];
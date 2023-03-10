%--------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Applied Optimization with Matlab Programming
% Dr. P.Venkataraman
% Second Edition,  John Wiley
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	An  Indirect Method for Constrained Optinmization
%
%  ALM (Augmented Lagrange Method) for Constrained Minimization
%  Uses DFP  (Gradient Based Method)
%  P. Venkataraman - April 2008
%--------------------------------------------------
% A function m-file for the ALM Method
%***************************************************
%***************************************************
%	Problem is described IN
%_______________________________________________________________
%	Minimize   	ObjectiveFun(X)        :	[X] -> n x 1 vector
%	Subject to	InEqualFun(X) <= 0.0	:	[Gfun] -> m x 1 vector
% 	Subject to	EqualFun(X)   =  0.0 :		[Hfun] -> leq x 1 vector
%               xl <= x  <= xu : i = 1...n
%   The Augmented function is AgumentedFun(X)
%    Minimize  AgumentedFun(X)
%
% ObjectiveFun.m , InEqualFu.m, EqualFun.m, and AgumentedFun.m
% must exist in the path for the program to work
%--------------------------------------------------------------------
% The program uses DFP method for Unconstrained minimization
%			golden section for 1 D minimization and requires
% the following files also
%								DFP.m
%								Gold_Section_nVar,m
%								UpperBound_nVar.m
%								gradfunction.m
%
% ALGORITHMIC CONTROLS ARE AHRD PROGRAMMED in
%_______________________________________________________
%** gradients are numerically evaluated using first
%** forward difference
% USAGE: ALM(initaldesign,lowerlimit,upperlimit, ...
%                       SUMT iterations, DFP iterations)
%************************************************

function[xstore fVstore gAstore hAstore FALMstore lamstore bstore rhstore rgstore] = ALM(X0,XLow,XHigh,NS,NU)

%%%  GLOBAL STATEMENTS  %%%%%%%%%%%%%
global ObjectiveFun EqualFun InEqualFun AgumentedFun
global NOPLOT_DFP
global lamda beta
global n m leq
global rh rg ch cg
global EPSXDIF EPSFDIF EPSGDIF EPSHDIF
global TOL ALPHAL ASTEP NSTEP


%%% the iteration by iteration details of ALM is available
global xstore fVstore gAstore hAstore FALMstore
global lamstore bstore rhstore rgstore
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% management functions
format short e   % represent numbers in scientific form
format compact  % avoid skipping a line when writing to the command window
warning off  % don't report any warnings like divide by zero etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   Functions expected in %%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective function is found in ObjeciveFun.m
% Equality constraints will be found in EqualFun
% Inequality constraints will be found in InEqualFun
% The unconstrained function is constructed in AugmentedFun
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate and store the starting values
xbegin = X0;

fbegin = feval(ObjectiveFun,xbegin)

gVbegin = feval(InEqualFun,xbegin)
if length(gVbegin)~= m
    fprintf('\nThere is a mismatch between m and the number of vectors')
    fprintf('\returned from InEqualFun.m')
    return;
end

hVbegin = feval(EqualFun,xbegin);
if length(hVbegin)~= leq
    fprintf('\nThere is a mismatch between leq and the number of vectors')
    fprintf('\returned from EqualFun.m')
    return;
end

if m > 0
    gAstore(1,:) = gVbegin;
    for j = 1:m
        g(j) = max(gVbegin(j),0);
        %%% adjust initial beta
        if g(j) ~= 0
            beta(j) = min(fbegin/g(j),beta(j));
        end
    end

    gError = g*g';
    gErr(1) = gError;

    %%% scale initial penalty multiplier
    if (gError ~= 0)
        rg = fbegin/gError;
    end
end;


if leq> 0

    hAstore(1,:) = hVbegin;
    hError = hVbegin*hVbegin';
    hErr(1) = hError;
    %%% adjust initial lamda
    for j = 1:leq
        if hVbegin(j) ~= 0
            lamda(j) = min(lamda(j),fbegin/hVbegin(j));
        end
    end
    %%% scale initial penalty multiplier
    if (hError ~= 0)
        rh = fbegin/hError;
    end
end;


% store values
iter = 1;
xstore(iter,:) = xbegin;
lamstore(iter,:) =lamda;
bstore(iter,:)=beta;
rhstore(iter) = rh;
rgstore(iter) = rg;
fVstore(iter) = fbegin;
FALMstore(iter)=feval(AgumentedFun,xbegin);

global lamstore bstore rhstore rgstore
% method starts here
xdes = xbegin;
COUNTLOOP = 0;  %%% Start Iteration
fprintf('\n**********************')
fprintf('\n*ALM iteration number: '),disp(COUNTLOOP)
fprintf('***********************\n')
fprintf('Design Vector (X) :  '),disp(xdes);
fprintf('Objective function : '),disp(fbegin)
if m~= 0
fprintf('Inequality constraints : '),disp(gVbegin)
fprintf('Sum of Squared Error in inequality constraints(g) : '),disp([gError]);
fprintf('Lagrange Multipliers (beta): '),disp([beta]);
fprintf('Penalty Multipliers (rg): '),disp(rg);
end;
if leq ~= 0
fprintf('Equality constraints : '),disp(hVbegin)
fprintf('Sum of Squared Error in equality constraints(g) : '),disp([hError]);
fprintf('Lagrange Multipliers (lamda): '),disp([lamda]);
fprintf('Penalty Multipliers (rh): '),disp(rh);
end;



fprintf('\n')

for outloop = 1:NS;				% outermost loop - based on NS (SUMT iteration)

    COUNTLOOP = COUNTLOOP + 1;
    xcur = xdes ;			% current x vector

    fresult = DFP(AgumentedFun,xcur,NU,TOL,ALPHAL,ASTEP,NSTEP);

    for ix = 1:n
        xnew(ix) = fresult(ix);
    end
    Fnew = fresult(n+1);

    fend = feval(ObjectiveFun,xnew);
    if leq > 0
        hVend = feval(EqualFun,xnew);
    end;


    iter = iter + 1;
    xstore(iter,:) = xnew;
    fVstore(iter) = fend;
    FALMstore(iter) = Fnew;
    if m > 0
        gVend = feval(InEqualFun,xnew);
        gAstore(iter,:) = gVend;
        for j = 1:m
            g(j) = max(gVend(j),0);
        end

        gError = g*g';
        gErr(iter) = gError;
    end;

    if leq > 0
        hVend = feval(EqualFun,xnew);
        hAstore(iter,:) = hVend;
        hError = hVend*hVend';
        hErr(iter) = hError;
    end;

    xcur = xnew;

    % check for stopping and convergence

    fdiff = Fnew - FALMstore(iter - 1);;
    if m > 0,	gdiff = gErr(iter) - gErr(iter -1);	end;
    if leq > 0,	hdiff = hErr(iter) - hErr(iter -1);	end;


    % stop if irearations are exceeded
    if outloop == NS
        fprintf('ALM: maximumum number of iterations reached : %6i \n',NS);
        if m > 0 & leq > 0
            fprintf('\n The values for x and f and g and h are : \n');
            disp([xstore fVstore' gErr' hErr']);

            fprintf('\n The values for lamda and beta are : \n');
            disp([lamstore' bstore']);


        elseif m > 0
            fprintf('\n The values for x and f and g are : \n');
            disp([xstore fVstore' gErr']);

            fprintf('\n The values for beta are : \n');
            disp([bstore']);


        elseif leq > 0
            fprintf('\n The values for x and f and h are : \n');
            disp([xstore fVstore' hErr']);

            fprintf('\n The values for lamda are : \n');
            disp([lamstore']);

        else
            fprintf('\n The values for x and f are : \n');
            disp([xstore fVstore']);
        end



        break;
    end


    % convergence in changes in x
    xdiff = (xnew-xdes)*(xnew-xdes)';
    if xdiff < EPSXDIF
        fprintf('\nALM: X not changing : % 12.3E  reached in %6i iterations \n', ...
            xdiff, outloop);

        if m > 0 & leq > 0
            fprintf('\n The values for x and f and g and h are : \n');
            disp([xstore fVstore' gErr' hErr']);

            fprintf('\n The values for lamda and beta are : \n');
            disp([lamstore bstore]);


        elseif m > 0
            fprintf('\n The values for x and f and g are : \n');
            disp([xstore fVstore' gErr']);

            fprintf('\n The values for beta are : \n');
            disp([bstore]);


        elseif leq > 0
            fprintf('\n The values for x and f and h are : \n');
            disp([xstore fVstore' hErr']);

            fprintf('\n The values for lamda and beta are : \n');
            disp([lamstore']);


        else
            fprintf('\n The values for x and f are : \n');
            disp([xstore fVstore']);
        end
        break;
    end

    if m > 0 & leq > 0
        if abs(fdiff) < EPSFDIF & abs(gdiff) <EPSGDIF & abs(hdiff) < EPSHDIF
            fprintf('ALM: Convergence in f : % 14.3E  reached in %6i iterations \n', ...
                abs(fdiff), outloop);
            fprintf('\n The values for x and f and g are :\n');
            disp([xstore fVstore' gerr' herr']);
            break;
        else
            fprintf('\n********************************')
            fprintf('\n*ALM iteration number: '),disp(COUNTLOOP)
            fprintf('***********************************\n')
            fprintf('Design Vector (X) :                          '),disp(xcur);
            fprintf('Objective function:                          '),disp(fend);
            fprintf('Sum of Squared Error in constraints (h, g) : '),disp([hError gError])
            fprintf('Lagrange Multipliers (lamda beta):           '),disp([lamda beta]);
            fprintf('Penalty Multipliers (rh rg):                 '),disp([rh rg]);
            fprintf('\n')
        end

    elseif m > 0 & leq == 0
        if abs(fdiff) < EPSFDIF & abs(gdiff) <EPSGDIF
            fprintf('Convergence in f : % 14.3E  reached in %6i iterations \n', ...
                abs(fdiff), outloop);
            fprintf('\n The values for x and f and g are :\n');
            disp([xstore fVstore' gErr' ]);
            break;
        else
            fprintf('\n*******************************')
            fprintf('\n*ALM iteration number: '),disp(COUNTLOOP)
            fprintf('*********************************\n')
            fprintf('Design Vector (X) :                      '),disp(xcur);
            fprintf('Objective function:                      '),disp(fend);
            fprintf('Inequality constraints:                  '),disp(gVend);
            fprintf('Sum of Squared Error in constraints (g) :'),disp([gError])
            fprintf('Lagrange Multipliers (beta):             '),disp([beta]);
            fprintf('Penalty Multipliers (rg):                '),disp(rg);
            fprintf('\n')
        end

    elseif leq > 0 & m ==0

        if abs(fdiff) < EPSFDIF & abs(hdiff) <EPSHDIF
            fprintf('Convergence in f : % 14.3E  reached in %6i iterations \n', ...
                abs(fdiff), outloop);
            fprintf('\n The values for x and f and h are :\n');
            disp([xstore fVstore' hErr']);
            break;
        else
            fprintf('\n*******************************')
            fprintf('\n*ALM iteration number: '),disp(COUNTLOOP)
            fprintf('*********************************\n')
            fprintf('Design Vector (X) :                      '),disp(xcur);
            fprintf('Objective function:                      '),disp(fend);
            fprintf('Equality constraints:                    '),disp(hVend);
            fprintf('Sum of Squared Error in constraints (h) :'),disp([hError])
            fprintf('Lagrange Multipliers (lamda):            '),disp([lamda]);
            fprintf('Penalty Multipliers (rh):                '),disp(rh);
            fprintf('\n')

            disp([xcur fend hError ]);
        end



    else
        if abs(fdiff) < EPSFDIF
            fprintf('Convergence in f : % 14.3E  reached in %6i iterations \n', ...
                abs(fdiff), outloop);
            fprintf('\n The values for x and f are :\n');
            disp([xstore fVstore']);
            break;
        else
            %disp([xcur fend outloop]);
        end


    end
    xdes = xcur;
    if leq >0
        lamda = lamda * 2*rh*hVend;
    end
    if m > 0
        for j = 1:m;
            beta(j) = beta(j) + 2*rg*max(gVend(j),-beta(j)/(2*rg));
        end
    end
    lamstore(iter,:) =lamda;
    bstore(iter,:)= beta;

    rh = rh*ch;
    rg = rg*cg;
    rhstore(iter) = rh;
    rgstore(iter) = rg;
    

end

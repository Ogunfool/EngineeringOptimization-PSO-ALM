%MECH 580 PROJECT
%            For Constrained Optimization
%--------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Applied Optimization with Matlab Programming
% Dr. P.Venkataraman
% Second Edition,  John Wiley
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%
% NOTE THESE NAMES ARE PLACEHOLDERS FOR ACTUAL FUNCTIONS
% DEFINED BELOW
%___________________________________________________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USAGE: ALM(initaldesign,lowerlimit,upperlimit, ...
%                       SUMT iterations, DFP iterations)

function[xstore, initialdesign, rg,rh, rgstore, rhstore, bstore,FALMstore,fVstore,gAstore,lamstore] = ALM_main()
    clear  % clear all variable/information in the workspace - use CAUTION
    clear global  %  again use caution - clears global information
    clc    % position the cursor at the top of the screen
    close   %  closes the figure window
    format compact  % avoid skipping a line when writing to the command window
    warning off  %#ok<WNOFF> % don't report any warnings like divide by zero etc.
    
     
    %%%   GLOBAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%  INFORMATION TRANSFERRED TO ALM
    global ObjectiveFun EqualFun InEqualFun AgumentedFun
    global NOPLOT_DFP
    global lamda beta
    global n m leq
    global rh rg ch cg
    global EPSXDIF EPSFDIF EPSGDIF EPSHDIF
    global TOL ALPHAL ASTEP NSTEP
    
    
    %%%  INFORMATION TRANSFERRED FROM ALM
    %%% You can suppress printing in ALM to increase speed
    %%% Can format printing here if desired
    global xstore fVstore gAstore hAstore FALMstore
    global lamstore bstore rhstore rgstore
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% monitor cpu time
    starttime = cputime;
    fprintf('\nProject1 (ALM)')
    fprintf('\n********************************\n\n')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% DATA --For the Particular Example ----
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    n = 4;  % Number of design variables
    m = 12;  % Number of Inequality constraints
    leq = 0;% Number of equality constraints
    %%% define the function m-files associated with problem definintion
    ObjectiveFun = 'Ofun_Project';  % objective function
    EqualFun = 'Hfun_Project';      % equailty constraints
    InEqualFun = 'Gfun_Project';    % Inequality Constraints
    AgumentedFun = 'FALM_Project';  % Augmented Function
    
    %%%  initial values and limits for design
    Xlow = [10 10 0.1 0.1];  % lower limit
    Xhigh =[200 200 99 99];  % upper limit

%     init_x1 = Xlow(:,1) + (Xhigh(:,1)-Xlow(:,1)).*rand(1);
%     init_x2 = Xlow(:,2) + (Xhigh(:,2)-Xlow(:,2)).*rand(1);
%     init_x3 = Xlow(:,3) + (Xhigh(:,3)-Xlow(:,3)).*rand(1);
%     init_x4 = Xlow(:,4) + (Xhigh(:,4)-Xlow(:,4)).*rand(1);
%     initialdesign = [init_x1, init_x2, init_x3, init_x4];
    initialdesign = [186.3794818, 120.2171695,	1.779612602, 	12.05301158];


    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Program CONTROL - can be changed with Example
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%   CONTROL PARAMETERS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set some epsilon values for control for ALM
    % differences in design vector, objective and constraints
    EPSXDIF = 1.0e-08; EPSFDIF = 1.0E-08;
    EPSGDIF = 1.0e-08; EPSHDIF = 1.0e-08;
    
    % inputs for golden section and upper bound calculation
    TOL = 1.0e-08; ALPHAL = 0; ASTEP = 1.0; NSTEP = 20;
    NOPLOT_DFP = 0;   % do not plot DFP iterations for two variables
    
    % initial estimate  for rh and rg
    %%% these values will be adjusted in ALM
    %%% if corresponding function is not zero at the start
    rh =  1; rg = 1;
    % scaling factors for multipliers
    ch = 5; cg = 5;
    
    % initial estimates for multipliers
    %%% these values will be adjusted in ALM
    %%% if corresponding function is not zero at the start
    %%% these are vectors based on number of constraints
    lamda = ones(1,12); beta = ones(1,12);
    
    %%% Number of iterations
    NSumt = 50;   %  Number of ALM iteratons
    NDFP = 20;    %  Number of DFP iterations
    %%%%%-----END of PROGRAM CONTROL -------------
    %%%%%-----END of DATA ------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%   call ALM Method   --------------------
    ALM(initialdesign,Xlow,Xhigh,NSumt,NDFP)
    %%%%-----------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Check side constraints and print information
    nv = length(fVstore);
    for i = 1:n
        if xstore(nv,i) < Xlow(i)
            fprintf('design Variable %2i violates lower limit\n ',i)
        end
        if xstore(nv,i) > Xhigh(i)
            fprintf('\ndesign Variable %2i violates upper limit\n ',i)
        end
    end
    
    %%% print time
    totaltime = cputime - starttime;
    fprintf('\n\nTotal cpu time (s)= %7.4f \n\n',totaltime)
    % Final_xstore = zeros(1,n);
    % Final_xstore(1,:) = xstore(end,:);
end
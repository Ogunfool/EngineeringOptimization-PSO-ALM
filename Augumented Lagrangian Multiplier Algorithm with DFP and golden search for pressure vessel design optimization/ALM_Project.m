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

function ALM_main(o)

%%% management functions
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
initialguess = [1 1 1 1];  % initial guess
initialdesign = initialguess + [2 2 0.5 0.5]*o;
% initialdesign = [2 2 0.5 0.5];
Xlow = [10 10 0.1 0.1];  % lower limit
Xhigh =[200 200 99 99];  % upper limit
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  draw contours of the problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(initialdesign) == 2
    % %%%  plot iterations here
    x1=-2:0.1:4;
    x2=-2:0.1:4;
    [X1,X2]=meshgrid(x1,x2);

    %%% functions
    f = X1.^4 -2*(X1.^2).*X2 +  X1.*X1 + X1.*X2.*X2 -2*X1 +4;
    h =X1.*X1 + X2.*X2 -2;
    g = 0.25*X1.*X1 + 0.75*X2.*X2 -1;

    %%% draw multiple contours of the objective function
    [C1,h1] = contour(x1,x2,f,[2.05 3 3.1 3.25 3.5 4 5 7 10 15 20 50],'g-');

    clabel(C1,h1);  %  label contours
    set(h1,'LineWidth',2);
    xlabel('x_1','FontName','times','FontSize',12);
    ylabel('x_2','FontName','times','FontSize',12)
    title('Example 7.1 - ALM','FontName','times','FontSize',12)
    grid
    hold on   % there will be addtional plots on this figure
    axis square
    %-------------------------------------------------------
    %%%  draw a single contour of the inequality constrint g
    [C2,h2] = contour(x1,x2,g,[0,0],'r-');
    clabel(C2,h2);  % avoid label for clarity
    set(h2,'LineWidth',2);
    % [XL1 YL1] = drawHashMarks(C2,'t');
    % hl2 = line(XL1,YL1,'Color','k','LineWidth',1);

    [C21,h21] = contour(x1,x2,g,[0.05 0.05],'k:');
    set(h21,'LineWidth',2);
    %-------------------------------------------------------
    %%%  draw a single contour of the equality constrint h
    [C3,h3] = contour(x1,x2,h,[0,0],'b-');
    clabel(C2,h2);  % avoid label for clarity
    set(h3,'LineWidth',2);

    text(2.2,-0.2,'g','FontName','Times','FontWeight','bold', ...
        'FontSize',14,'Color','red')
    text(0.75,-1.5,'h','FontName','Times','FontWeight','bold', ...
        'FontSize',14,'Color','blue')
    l1 = line([-2 4],[ 0 0]);
    set(l1,'Color','k','LineStyle','-','LineWidth',2)

    l2 = line([0 0],[-2 4]);
    set(l2,'Color','k','LineStyle','-','LineWidth',2)


    %%%  Draw the ALM iterations
    plot(xstore(1,1),xstore(1,2),'bo',...
        'MarkerFaceColor','y','MarkerSize',12);
    for i = 1:length(fVstore)-1
        l1 = line([xstore(i,1) xstore(i+1,1)],[ xstore(i,2) xstore(i+1,2)]);
        set(l1,'Color','m','LineStyle','-','LineWidth',3)
        plot(xstore(i+1,1),xstore(i+1,2),'bo',...
            'MarkerFaceColor','y');
    end

end
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   FINISHED DRAWING   %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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



%     %%% management functions
%     clear  % clear all variable/information in the workspace - use CAUTION
%     clear global  %  again use caution - clears global information
%     clc    % position the cursor at the top of the screen
%     close   %  closes the figure window
%     format compact  % avoid skipping a line when writing to the command window
%     warning off  %#ok<WNOFF> % don't report any warnings like divide by zero etc.
end
% Chapter 5: Numerical Techniques
%            The One Dimensional Problem
%--------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Applied Optimization with Matlab Programming
% Dr. P.Venkataraman
% Second Edition,  John Wiley
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------
% An function m-file to apply the Golden Section Method
% Golden section - Many Variable
% Section 5.4.1
%------------------------------------------------
%************************************
% requires:     UpperBound_nVar.m
%***************************************
%
% the following information are passed to the function
%
% the name of the function 			       'functname'
% this function should be available as a function m-file
% and should return the value of the function for a design vector
%
% the tolerance								0.001
% the current position vector				x
% the current search direction			    s
%
%
% following is needed for UpperBound_nVar
% the initial value							lowbound
% the incremental value 					intvl
% the number of scanning steps	    	    ntrials
%
% the function returns a row vector of the following
% alpha(1),f(alpha1), design variables at alpha(1)
% for the last iteration
%
%	sample callng statement

% GoldSection_nVar('Example5_3',0.001,[0 0 0 ],[0 0 6],0,0.1,10)
%
%  a global statement capturing the values in all iterations is available
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ch 5: Numerical Techniques - 1 D optimization
% Optimzation with MATLAB, Section 5.4.1
% Golden Section Method - many variables
% copyright (code) Dr. P.Venkataraman
%
% An m-file to apply the Golden Section Method
%************************************
% requires:     UpperBound_nVar.m
%***************************************
%
% the following information are passed to the function

% the name of the function 			'functname'
% this function should be available as a function m-file
% and should return the value of the function
% corresponding to a design vector given a vector
%
% the tolerance										0.001

% following needed for UpperBound_nVar

% the initial value							lowbound
% the incremental value 					intvl
% the number of scanning steps	    	ntrials
%
%
%  a global statement capturing the values in all iterations is available
%  for processing in other programs if needed  
function ReturnValue = ...
    GoldSection_nVar(functname,tol,x,s,lowbound,intvl,ntrials)
global asL fasL as1 fas1 as2 fas2 asU fasU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% management functions
format compact  % avoid skipping a line when writing to the command window
warning off  % don't report any warnings like divide by zero etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% management functions
format compact  % avoid skipping a line when writing to the command window
warning off  % don't report any warnings like divide by zero etc.

% find upper bound
upval = UpperBound_nVar(functname,x,s,lowbound,intvl,ntrials);
au=upval(1);	fau = upval(2);

if (tol == 0) tol = 1.0e-08;  %default
end

eps1 = tol/(au - lowbound);
tau = 0.38197;
nmax = round(-2.078*log(eps1)); % no. of iterations

aL = lowbound;              xL = x + aL*s;  faL =feval(functname,xL);;
a1 = (1-tau)*aL + tau*au;   x1 = x + a1*s; fa1 = feval(functname,x1);
a2 = tau*aL + (1 - tau)*au; x2 = x + a2*s; fa2 = feval(functname,x2);

% storing all the four values for printing

i = 1;
asL(i) = aL; as1(i) = a1;   as2(i) = a2;  asU(i) = au;
fasL(i) = faL;  fas1(i) = fa1;  fas2(i) = fa2;  fasU(i) = fau;

% remember to suppress printing after debugging
%%% store the values
% fprintf('start  \n')
% fprintf('alphal(low)   alpha(1)   alpha(2)  alpha{up) \n')
% avec = [aL a1 a2 au;faL fa1 fa2 fau];
% disp([avec])
for i = 1:nmax
    ii = i+1;
    if fa1 >= fa2
        aL = a1;	faL = fa1;
        a1 = a2;	fa1 = fa2;
        a2 = tau*aL + (1 - tau)*au;	x2 = x + a2*s;
        fa2 = feval(functname,x2);

        au = au;	fau = fau;  % not necessary -just for clarity

        asL(ii) = aL; as1(ii) = a1;   as2(ii) = a2;  asU(ii) = au;
        fasL(ii) = faL;  fas1(ii) = fa1;  fas2(ii) = fa2;  fasU(ii) = fau;
        % remember to suppress printing after debugging
%         fprintf('\niteration '),disp(i)
%         fprintf('alphal(low)   alpha(1)   alpha(2)  alpha{up) \n')
%         avec = [aL a1 a2 au;faL fa1 fa2 fau];
%         disp([avec])

    else
        au = a2;	fau = fa2;
        a2 = a1;	fa2 = fa1;
        a1 = (1-tau)*aL + tau*au;	x1 = x + a1*s;
        fa1 = feval(functname,x1);
        aL = aL;	faL = faL;  % not necessary

        asL(ii) = aL; as1(ii) = a1;   as2(ii) = a2;  asU(ii) = au;
        fasL(ii) = faL;  fas1(ii) = fa1;  fas2(ii) = fa2;  fasU(ii) = fau;
        % remember to suppress printing after debugging
%         fprintf('\niteration '),disp(i)
%         fprintf('alphal(low)   alpha(1)   alpha(2)  alpha{up) \n')
%         avec = [aL a1 a2 au;faL fa1 fa2 fau];
%         disp([avec])

    end
end
% returns the value at the last iteration
ReturnValue =[a1 fa1 x1];
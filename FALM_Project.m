function retval = FALM_Project(x)
% 
% calculates the unconstrained fuction for ALM method
%
global lamda beta
global n m leq
global rh rg
retval = Ofun_Project(x);

if leq > 0
   hval = Hfun_Project(x);
   retval = retval + lamda*hval'+ rh*(hval*hval');
end

if m > 0
   gval = Gfun_Project(x);
   for j = 1:m
      g(j) = max(gval(j),-beta(j)/(2*rg));
   end
   retval = retval + beta*g'+ rg*(g*g');
end

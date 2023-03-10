ni = 200;
n = 4;
m = 12;

Final_xstore = zeros(ni,n);
Final_rgstore = zeros(1,ni);
Final_rhstore = zeros(1,ni);
Final_fVstore = zeros(1,ni);
Final_FALMstore = zeros(1,ni);
Final_gAstore = zeros(ni,m);
Final_bstore = zeros(ni,m);
Final_lamstore = zeros(ni,m);
Final_initialdesign = zeros(ni,n);

for o = 1:ni
    [xstore, initialdesign, rg,rh, rgstore, rhstore, bstore,FALMstore,fVstore,gAstore,lamstore] = ALM_main()
    Final_xstore(o,:) = xstore(end,:);
    Final_rgstore(o) = rg;
    Final_rhstore(o) = rh;
    Final_fVstore(o) = fVstore(:,end);
    Final_FALMstore(o,:) = FALMstore(:,end);
    Final_gAstore(o,:) = gAstore(end,:);
    Final_bstore(o,:) = bstore(end,:);
    Final_lamstore(o,:) = lamstore(end,:);
    Final_initialdesign(o,:) = initialdesign; 

end
%%% Plot Cost function per ALM iteration

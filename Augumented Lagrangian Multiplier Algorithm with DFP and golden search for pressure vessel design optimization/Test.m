% %%%  plot iterations here
x1=-2:0.1:4;
x2=-2:0.1:4;
x3=-2:0.1:4;
% x4=-2:0.1:4;
[X1,X2,X3]=meshgrid(x1,x2,x3);
x4 = linspace(0, 1, 100);

%%% functions
z = 0.6224*X3*X1*X2 + 1.7781*x4*X1^2 + 3.1661*X3^2*X2 + 19.84*X3^2*X1;
% Generate animation
f = figure('DoubleBuffer', 'on');
while ishandle(f)
      for n = 1:size(x, 3)
          if ~ishandle(f), break,end
          h = surf(X1(:,:,n),X2(:,:,n),X3(:,:,n),z(:,:,n));
          axis([-1 1 -1 1 -1 1])
          title(sprintf('t = %0.3f', x4(1,1,n)))
          drawnow
      end
end

% tht = linspace(-pi, pi, 40);
% phi = linspace(-pi/2, pi/2, 40);
% t = linspace(0, 1, 100);
% [tht phi t] = meshgrid(tht, phi, t);
% r = 1 - t.^2/2;
% x = r.*cos(phi).*cos(tht);
% y = r.*cos(phi).*sin(tht);
% z = r.*sin(phi);
% %Determine temperate distribution
% c = abs(asin(x-t) + acos(y+t) + asin(y+t).*acos(x-t));
% % Generate animation
% f = figure('DoubleBuffer', 'on');
% while ishandle(f)
%       for n = 1:size(x, 3)
%           if ~ishandle(f), break,end
%           h = surf(x(:,:,n),y(:,:,n),z(:,:,n),c(:,:,n));
%           axis([-1 1 -1 1 -1 1])
%           title(sprintf('t = %0.3f', t(1,1,n)))
%           drawnow
%       end
% end
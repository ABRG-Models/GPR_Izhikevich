% Quick scheme to view nullclines and poss. quiver plots for given
% set of params.

% Model params
A=0.032;
B=4;
C=113.147;
a=0.03;
b=0.191;
c=-65;
d=0.05;
T=0.4;
constI=0;

% Graphing params
lowerV = -100;
upperV = 30;
qvlowerv = lowerV;
qvupperv = upperV;
qvloweru = -20;
qvupperu = 0;
qpscale = 1;
qpdivisor = .00001;

nullcline_fig = figure(curfig);
%curfig = curfig+1;
clf;

% Compute nullclines
Vn = linspace (lowerV, upperV, 1000);
wv = A.*Vn.*Vn + B.*Vn + C + constI;%./T;
ww = b .* Vn;
        
% Compute vector field
thescale = abs(qvlowerv-qvupperv)./qpscale;
Vgv = linspace(qvlowerv, qvupperv, thescale);
ugv = linspace(qvloweru, qvupperu, thescale);
[Vg, ug] = meshgrid(Vgv, ugv);
% Calculate v/u for the trajectory region:
dv = A.*T.*Vg.*Vg + B.*T.*Vg + C.*T - ug.*T + constI.*T;
du = a.*T.*(b.*Vg - ug);

% Plot vector field as quiver plot
do_power = 1;
[stem_x, stem_y, arrow1_x, arrow1_y, arrow2_x, arrow2_y, vlens] = KG_quiver(Vg, ug, dv, du, qpscale/qpdivisor, do_power);

v = axis;
axis(v);

% Plot nullclines after vector field
hold on
plot(Vn', wv, 'b')
plot(Vn, ww, 'r')

max_len = max(vlens);
fprintf('maximum vector length in vector field is %.5g\n', max_len);

ylabel('u');
xlabel('v');

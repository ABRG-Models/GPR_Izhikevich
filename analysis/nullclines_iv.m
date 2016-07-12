% Quick scheme to view nullclines and poss. quiver plots for given
% set of params.

% Model params, IV formulation
C = 1./0.4;
k = 0.032;
vr = -59.9166;
vt = -59.1146;
a = 0.006;
b = 0.191;
c = -65;
d = 0.05;
constI = 0;

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
wv = k.*(Vn-vr).*(Vn-vt) + b.*vr + constI;
ww = b.*(Vn);
  
% Compute vector field
thescale = abs(qvlowerv-qvupperv)./qpscale;
Vgv = linspace(qvlowerv, qvupperv, thescale);
ugv = linspace(qvloweru, qvupperu, thescale);
[Vg, ug] = meshgrid(Vgv, ugv);
% Calculate v/u for the trajectory region:
dv = ((k./C).*((Vg-vr).*(Vg-vt))) - (ug./C) + (b.*vr./C) + (constI)./C;
du = a.*(b.*(Vg-vr) - ug + b.*vr);

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

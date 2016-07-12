% How to call the Izhykevich post processing to examine the result
% of a single neuron simulation carried out in SpineCreator. This
% is useful when parameterizing your neuron components.

% Specify your parameter mapping in this line - the names you gave
% your Izhy parameters in your SpineCreator component.
% In this order: 'a', 'b', 'c', 'd', 'Cap', 'Vreset', 'Vthresh',
% 'k', 'Vpeak'
%
% NB: Cap, vr, vt, k are used in the "biophysical" formulation of the
% Izhi Simple model given in the book; A, B, C are used in the
% simplified formulation given in the 2003 IEEE Transactions paper.
% T is a time scaling parameter.
codeIzhyParams = {'a', 'b', 'c', 'd', 'Cap', 'vr', 'vt', 'k', 'Vpeak', ...
                 'A', 'B', 'C', 'T'};
% ** Change this line to suit your model. **
myIzhyParams   = {'a', 'b', 'c', 'd', 'C',   'Vr', 'Vt', 'k', 'Vpeak', ...
                 'A', 'B', 'C', 'T'};
paramMapping = containers.Map (codeIzhyParams, myIzhyParams);

% List your state variable names, including the injected current
% (that'll be a component port rather than a component state variable).
codeIzhyStateVars = {'v', 'u', 'I'};
% ** Change this line to suit your model **
myIzhyStateVars   = {'v', 'u', 'I'};
statevarMapping = containers.Map (codeIzhyStateVars, myIzhyStateVars);

% Your preferred graphing params. These are params for the nullcline
% plot and for the quiver plot around the equilibrium. Also set here
% is the initial V for finding an equilibrium, as the code only finds
% one of up to two equilibrium points.
%
% Have a play and read the code in phaseplane_izhi_paperform.m to find
% out what these are.
graphingParamNames = {'qvscale', 'qvinc', 'qvdivisor', ...
                    'qvnearequil', ...
                    'qvlowerv', 'qvupperv', 'qvloweru', 'qvupperu', ...
                    'equil_initV', 'equil_initV2', ...
                    'nullcline_lowerv', 'nullcline_upperv'};

% ** Change this line to suit your output. qvscale determines size
% of arrows. qvinc is the spacing between arrows. **
%
% Ok for full field:
graphingParamVals = [ 0.5,1,0.0001, 0, -80,-40,-20,-10, -70,-55 -80,30];
%
% Ok for near equilibrium:
%graphingParamVals = [8,1,0.2,      1, -80,-40,-20,-10, -73,-40, -80,-20];

graphingParams = containers.Map (graphingParamNames, graphingParamVals);


% Calls phaseplane_izhy with the specified location, expt, population
% name and param mapping
%** Change this line to suit your model location, experiment, population etc. **

firstfig = 1;
ee=[24,25,26];
for e = ee
    display(['Crunching experiment' num2str(e) '.xml']);
    spinemlcmd = ['pushd /home/seb/src/SpineML_2_BRAHMS && ' ...
                  'LD_LIBRARY_PATH="" ./convert_script_s2b -m ~/abrg/abrg_local/' ...
                  'IzhiBG/Izhi_STN -e' num2str(e) '; popd'];
    display (spinemlcmd);
    system(spinemlcmd);
    rate = phaseplane_izhi_paperform_tscaled ('/home/seb/src/SpineML_2_BRAHMS/temp', ...
                                              ['experiment' num2str(e) '.xml'], 'Sebtest1', ...
                                              paramMapping, statevarMapping, graphingParams, ...
                                              firstfig);
    firstfig = firstfig + 4;
end
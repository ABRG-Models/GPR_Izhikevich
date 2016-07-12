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
codeIzhyParams = {'a', 'b', 'c', 'd', 'Cap', 'vr', 'vt', 'k', 'Vpeak', ...
                 'A', 'B', 'C'};
% ** Change this line to suit your model. **
myIzhyParams   = {'a', 'b', 'c', 'd', 'C',   'Vr', 'Vt', 'k', 'Vpeak', ...
                 'A', 'B', 'C'};
paramMapping = containers.Map (codeIzhyParams, myIzhyParams);

% List your state variable names, including the injected current
% (that'll be a component port rather than a component state variable).
codeIzhyStateVars = {'v', 'u', 'I'};
% ** Change this line to suit your model **
myIzhyStateVars   = {'v', 'u', 'I'};
statevarMapping = containers.Map (codeIzhyStateVars, myIzhyStateVars);

% Your preferred quiver plot params. These are: scale, increment,
% plot_scale_divisor. Try [ 10, 0.5, 5 ]. Increase scale to show
% more of the trajectory.
quivParamNames = {'qvscale', 'qvinc', 'qvdivisor'};
% ** Change this line to suit your output **
quivParamVals = [ 5, 0.5, 5 ];
quiverParams = containers.Map (quivParamNames, quivParamVals);


% Calls phaseplane_izhy with the specified location, expt, population
% name and param mapping
%** Change this line to suit your model location, experiment, population etc. **
e=19
spinemlcmd = ['pushd /home/seb/src/SpineML_2_BRAHMS && ./convert_script_s2b -m ~/abrg2/abrg_local/' ...
              'IzhiBG/IzhiSimplestForm -e' num2str(e) '; popd'];
system(spinemlcmd);
rate = phaseplane_izhi_paperform ('/home/seb/src/SpineML_2_BRAHMS/temp', ['experiment' num2str(e) '.xml'], 'Sebtest1', ...
                                  paramMapping, statevarMapping, quiverParams, ...
                                  1);

e = 20
spinemlcmd = ['pushd /home/seb/src/SpineML_2_BRAHMS && ./convert_script_s2b -m ~/abrg2/abrg_local/' ...
              'IzhiBG/IzhiSimplestForm -e' num2str(e) '; popd'];
system(spinemlcmd);
rate = phaseplane_izhi_paperform ('/home/seb/src/SpineML_2_BRAHMS/temp', ['experiment' num2str(e) '.xml'], 'Sebtest1', ...
                                  paramMapping, statevarMapping, quiverParams, ...
                                  10);

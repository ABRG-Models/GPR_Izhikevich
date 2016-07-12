% How to call the Izhykevich post processing to examine the result
% of a single neuron simulation carried out in SpineCreator. This
% is useful when parameterizing your neuron components.

% Specify your parameter mapping in this line - the names you gave
% your Izhy parameters in your SpineCreator component.
% In this order: 'a', 'b', 'c', 'd', 'A', 'B', 'C', 'Vpeak'
codeIzhyParams = {'a', 'b', 'c', 'd', 'A', 'B', 'C', 'Vpeak'};
% ** Change this line to suit your model **
myIzhyParams   = {'a', 'b', 'c', 'd', 'A', 'B', 'C', 'Vpeak'};
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
quivParamVals = [ 20, 0.5, 5 ];
quiverParams = containers.Map (quivParamNames, quivParamVals);


% Calls phaseplane_izhy with the specified location, expt, population
% name and param mapping
%** Change this line to suit your model location, experiment, population etc. **
rates=[];
currents = [0.1, 0.2, 0.4, 0.8, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 16, 18, 30];
for e = 0:17
    display(['Crunching experiment' num2str(e) '.xml']);
    spinemlcmd = ['pushd /home/seb/src/SpineML_2_BRAHMS && ./convert_script_s2b -m ~/abrg2/abrg_local/' ...
                  'IzhiBG/Izhi2003_TC -e' num2str(e) '; popd'];
    system(spinemlcmd);
    rate = phaseplane_izhi_paperform ('/home/seb/src/SpineML_2_BRAHMS/temp', ['experiment' num2str(e) '.xml'], 'Sebtest1', ...
                            paramMapping, statevarMapping, quiverParams, ...
                            1);
    rates = [rates; currents(e+1), rate];
    pause(2)
end

figure(35);
subplot (2,1,1);
plot (rates(:,1), rates(:,2), 'o-');
xlabel('Current');
ylabel('Firing rate /s');
subplot (2,1,2);
drates = diff(rates(:,2));
drates = [drates; 0]./rates(:,1);
plot (rates(:,1), drates, 'o-r');
xlabel('Current');
ylabel('delta firing rate/delta current');

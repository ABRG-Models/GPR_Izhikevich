% How to call the Izhykevich post processing to examine the result
% of a single neuron simulation carried out in SpineCreator. This
% is useful when parameterizing your neuron components.

% Specify your parameter mapping in this line - the names you gave
% your Izhy parameters in your SpineCreator component.
% In this order: 'a', 'b', 'c', 'd', 'A', 'B', 'C', 'Vpeak'
codeIzhyParams = {'a', 'b', 'c', 'd', 'A', 'B', 'C', 'Vpeak', 'T'};
% ** Change this line to suit your model **
myIzhyParams   = {'a', 'b', 'c', 'd', 'A', 'B', 'C', 'Vpeak', 'T'};
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
%graphingParamVals = [ 0.5,1,0.0001, 0, -80,-40,-20,-10, -70,-55 -80,30];
%
% Ok for near equilibrium:
graphingParamVals = [8,1,0.2, 1, -80,-40,-20,-10, -73,-40, -80,-20];

graphingParams = containers.Map (graphingParamNames, graphingParamVals);

% Calls phaseplane_izhy with the specified location, expt, population
% name and param mapping
%** Change this line to suit your model location, experiment, population etc. **
rates=[];
isiRates=[];
currents = [0.1, 0.2, 0.4, 0.8, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, ...
            16, 18, 30, 60, 90, 150, 300];
for e = 0:21
    display(['Crunching experiment' num2str(e) '.xml']);
    spinemlcmd = ['pushd /home/seb/src/SpineML_2_BRAHMS && ' ...
                  'LD_LIBRARY_PATH="" ./convert_script_s2b -m ~/abrg/abrg_local/' ...
                  'IzhiBG/Izhi_STN -e' num2str(e) '; popd'];
    system(spinemlcmd);
    [rate, isiRate] = phaseplane_izhi_paperform_tscaled ('/home/seb/src/SpineML_2_BRAHMS/temp', ...
                                                      ['experiment' num2str(e) '.xml'], 'Sebtest1', ...
                                                      paramMapping, statevarMapping, graphingParams, ...
                                                      1);
    rates = [rates; currents(e+1), rate];
    isiRates = [isiRates; currents(e+1), isiRate];
    pause(2)
end

figure(35); %clf;
subplot (2,1,1);
plot (rates(:,1), rates(:,2), 'o-');
hold on;
%plot (isiRates(:,1), isiRates(:,2), 'or-');
xlabel('Current');
ylabel('Firing rate /s');
subplot (2,1,2);
drates = diff(rates(:,2));
drates = [drates; 0]./rates(:,1);
plot (rates(:,1), drates, 'o-r');
xlabel('Current');
ylabel('delta firing rate/delta current');

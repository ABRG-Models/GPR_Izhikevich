% A function to take u and v from an Izhykevich neuron simulation
% carried out in SpineCreator and show phase plane and quiver plots
% and analysis. Based on Kevin Gurney's demo matlab code for the MS
% course - specifically dynamicsIz.m with the simulation removed
% from the code.
%
% Adapted by Seb James
%
% This version works with the equations as presented in Izhikevich's
% 2003 IEE Transactions paper, but with the quadratic parameter names
% passed in as A, B, C (in paramNames) and read from the model, rather
% than being hardcoded as 0.04, 5 and 140, as in the paper.

function [meanRate]  = phaseplane_izhi_paperform ...
    (spineml_results_path, experimentXml, ...
     populationName, paramNames, stateVarNames, ...
     quiverParams, startFigNum)

    % Hard-coded parameters.
    % Initial value for locating an equilibrium
    initV = quiverParams('equil_initV');
    initV2 = quiverParams('equil_initV2');
    % For nullclines
    lowerV = quiverParams('nullcline_lowerv');
    upperV = quiverParams('nullcline_upperv');

    fig_i = 1;
    
    % Initialise model parameters and load them from the model.xml
    a = 0; b = 0; c = 0; d = 0; Vpeak = 0; A = 0; B = 0; C = 0;
    izhy_cmpt = '';
    modelDoc = xmlread([spineml_results_path, '/model/model.xml']);
    neurons = modelDoc.getElementsByTagName ('LL:Neuron');
    % find the neuron which is called populationName.
    for n_iter = 0:neurons.getLength-1
        neuron = neurons.item (n_iter);
        nm = neuron.getAttribute ('name');
        if nm == populationName
            % This is our population. Can get component xml name here.
            izhy_cmpt = char(neuron.getAttribute ('url'));
            % Get all paramNames.
            % get value of paramNames('a') % etc
            props = neuron.getElementsByTagName ('Property');
            for p_iter = 0:props.getLength-1
                property = props.item (p_iter);
                pname = property.getAttribute ('name');
                if pname == paramNames('a')
                    % Assume this param property is a fixed value
                    a = str2num(char(property.getElementsByTagName ...
                                     ('FixedValue').item (0).getAttribute ('value')));
                elseif pname == paramNames('b')
                    b = str2num(char(property.getElementsByTagName ...
                                     ('FixedValue').item (0).getAttribute ('value')));
                elseif pname == paramNames('c')
                    c = str2num(char(property.getElementsByTagName ...
                                     ('FixedValue').item (0).getAttribute ('value')));
                elseif pname == paramNames('d')
                    d = str2num(char(property.getElementsByTagName ...
                                     ('FixedValue').item (0).getAttribute ('value')));
                elseif pname == paramNames('Vpeak')
                    Vpeak = str2num(char(property.getElementsByTagName ...
                                         ('FixedValue').item (0).getAttribute ('value')));
                elseif pname == paramNames('A')
                    A = str2num(char(property.getElementsByTagName ...
                                         ('FixedValue').item (0).getAttribute ('value')));
                elseif pname == paramNames('B')
                    B = str2num(char(property.getElementsByTagName ...
                                         ('FixedValue').item (0).getAttribute ('value')));
                elseif pname == paramNames('C')
                    C = str2num(char(property.getElementsByTagName ...
                                         ('FixedValue').item (0).getAttribute ('value')));
                else
                    fprintf ('unknown/ignored component property %s\n', char(pname));
                end
            end
        end
    end

    % Now load time series.
    [v, v_count, t] = load_sc_data ([spineml_results_path ...
                        '/log/' populationName '_' stateVarNames('v') ...
                        '_log.bin']);
    [u, u_count, ~] = load_sc_data ([spineml_results_path ...
                        '/log/' populationName '_' stateVarNames('u') ...
                        '_log.bin']);

    % The existing script uses a container y to store the data:
    y = [v', u'];
    t = t';
    
    % Duration of simulation in milliseconds
    duration = t(end);
    
    % A time series for I (much bigger than required)
    I = zeros (1, v_count);
    
    % Read the Currents from the experiment file.
    disp([spineml_results_path '/model/' experimentXml]);
    exptDoc = xmlread([spineml_results_path '/model/' experimentXml]);
    % I may be time varying:
    %
    % <TimeVaryingInput target="Population" port="I" name="I">
    %  <TimePointValue time="0" value="0"/>
    %  <TimePointValue time="100" value="100"/>
    %  <TimePointValue time="200" value="10"/>
    % </TimeVaryingInput>
    %
    % Or constant:
    %
    % <ConstantInput target="Population" port="I" value="100" name="I"/>
    
    % First check for constant input I
    constI = NaN;
    constInputs = exptDoc.getElementsByTagName ('ConstantInput');
    for ci_iter = 0:constInputs.getLength-1
        constInput = constInputs.item (ci_iter);
        port = char(constInput.getAttribute ('port'));
        targ = char(constInput.getAttribute ('target'));
        if strcmp (port, stateVarNames('I'))
            if strcmp (targ, populationName)
                constI = str2num(char(constInput.getAttribute ...
                                      ('value')));
                I = I + constI;
                fprintf ('Got a ConstantInput current for %s of %d\n', ...
                         populationName, max(I));
            end
        end
    end
    
    % If there was no constant input, then find a time varying one.
    multiI = [];
    if isnan(constI)
        % Check time series.
        tvInputs = exptDoc.getElementsByTagName ('TimeVaryingInput');
        timePointValues = [];
        for tvi_iter = 0:tvInputs.getLength-1
            tvInput = tvInputs.item (tvi_iter);
            port = char(tvInput.getAttribute ('port'));
            targ = char(tvInput.getAttribute ('target'));
            if strcmp (port, stateVarNames('I'))
                if strcmp (targ, populationName)
                    % Match. Get points now.                    
                    tpValues = tvInput.getElementsByTagName ...
                        ('TimePointValue');
                    timePointValues = zeros (tpValues.getLength, 2);
                    for tpv_iter = 0:tpValues.getLength-1
                        tpValue = tpValues.item(tpv_iter);
                        timePointValues(tpv_iter+1,1) = ...
                            str2num(char(tpValues.item(tpv_iter).getAttribute('time')));
                        timePointValues(tpv_iter+1,2) = ...
                            str2num(char(tpValues.item(tpv_iter).getAttribute('value'))); 
                    end
                end
            end
        end

        % Add final value to timePointValues to use interp1 to
        % generate I series data.
        if isempty(timePointValues)
            disp('timePointValues is empty');
        else
            timePointValues = [timePointValues; [t(end), timePointValues(end,2)]];
            I = interp1 (timePointValues(:,1), timePointValues(:,2), t, ...
                         'previous');
            % Set the "constant I" used to plot nullclines to the max
            % value of I for now. Would ideally plot multiple nullclines.
            constI = max(timePointValues(:,2));
            
            multiI = timePointValues(:,2);
        end

    end % isnan(constI)

    if isnan(constI) && isempty(multiI)
        display (['Failed to find the injection current for the ' ...
                  'simulation, exiting']);
        return;
    end
    
    % Here, check in the expt file for any overridden variables.
    props = exptDoc.getElementsByTagName ('UL:Property');
    for p_iter = 0:props.getLength-1
        property = props.item (p_iter);
        pname = property.getAttribute ('name');
        if pname == paramNames('a')
            % Assume this param property is a fixed value
            a = str2num(char(property.getElementsByTagName ...
                             ('UL:FixedValue').item (0).getAttribute ('value')));
        elseif pname == paramNames('b')
            b = str2num(char(property.getElementsByTagName ...
                             ('UL:FixedValue').item (0).getAttribute ('value')));
        elseif pname == paramNames('c')
            c = str2num(char(property.getElementsByTagName ...
                             ('UL:FixedValue').item (0).getAttribute ('value')));
        elseif pname == paramNames('d')
            d = str2num(char(property.getElementsByTagName ...
                             ('UL:FixedValue').item (0).getAttribute ('value')));
        elseif pname == paramNames('Vpeak')
            Vpeak = str2num(char(property.getElementsByTagName ...
                                 ('UL:FixedValue').item (0).getAttribute ('value')));
        elseif pname == paramNames('A')
            A = str2num(char(property.getElementsByTagName ...
                                 ('UL:FixedValue').item (0).getAttribute ('value')));
        elseif pname == paramNames('B')
            B = str2num(char(property.getElementsByTagName ...
                                 ('UL:FixedValue').item (0).getAttribute ('value')));
        elseif pname == paramNames('C')
            C = str2num(char(property.getElementsByTagName ...
                                 ('UL:FixedValue').item (0).getAttribute ('value')));
        else
            fprintf ('unknown/ignored component property %s\n', char(pname));
        end
    end
    % Done checking for parameters which are overridden in the expt file.
    
    % First plot y(:,1), the membrane voltage and I against sample
    vi_fig = figure(startFigNum);
    clf;
    tstr = sprintf ('Time series. %s/%s', izhy_cmpt, populationName);
    subplot(2,1,1);
    plot(t, y(:,1), 'r')
    title (tstr);
    ylabel('~mV');
    xlabel('ms');
    subplot(2,1,2);
    plot(t, I)
    ylabel('~pA');
    xlabel('ms');

    % "Zoomed in time series"
    vi_fig = figure(startFigNum+fig_i); fig_i = fig_i + 1;
    clf;
    tstr = sprintf ('Time series. %s/%s', izhy_cmpt, populationName);
    subplot(2,1,1);
    ts_low = 1430; % Mod these to change the zoomed graph's range
    ts_hi = 1940;
    ts_span = ts_hi-ts_low;
    plot(t(ts_low:ts_hi), y(ts_low:ts_hi,1), 'r')
    ylabel('~mV');
    xlabel('ms');
    subplot(2,1,2);
    ts_low = ts_low-ts_span/2;
    ts_hi = ts_hi+ts_span/2;
    plot(t(ts_low:ts_hi), y(ts_low:ts_hi,1), 'r')
    ylabel('~mV');
    xlabel('ms');

    
    % find max and min for bifurcation diagram
    maxV = max(y(:,1));
    minV = min(y(:,1));
    fprintf(1, 'maximum Vm %.6fmV \n', maxV); 
    fprintf(1, 'minimum Vm %.6fmV \n\n', minV);

    %  nullclines
    nullcline_fig = figure(startFigNum+fig_i); fig_i = fig_i + 1;
    clf;
    tstr = sprintf ('Nullclines. %s/%s', izhy_cmpt, populationName);
    sz = size(y(:,1));
    Vn = linspace (lowerV, upperV, 1000);
    
    if (isempty(multiI))
        wv = A.*Vn.*Vn + B.*Vn + C + constI;
        plot(Vn', wv, 'b')
        hold on
    else
        firstnullcline = 1;
        for i = multiI'
            wv = A.*Vn.*Vn + B.*Vn + C + i;
            if firstnullcline == 1
                plot(Vn, wv, 'b--')
                firstnullcline = 0
            else
                plot(Vn, wv, 'b')
            end
            hold on
        end
    end
    ww = b .* Vn;

    plot(Vn, ww, 'r')

    % phase trajectory. Select out the range lowerV to upperV?
    
    plot(y(:,1), y(:,2),  'g')
    %axis([lowerV upperV -100 200]);
    title (tstr);
    ylabel('u');
    xlabel('v');
    %ylim([-500 1000]);
    
    hold off

    %  find zeros
    warning off MATLAB:fzero:UndeterminedSyntax

    opts = optimset('fzero');
    optimset(opts, 'TolX', 1e-15);
    
    display(['Calling model_Iz_zeros_paperform with initV=' ...
             num2str(initV) ' and constI=' num2str(constI)]);
    [vz, fval, exitflag] = fzero(@model_Iz_zeros_paperform, initV, ...
                                 opts, constI, a, b, A, B, C);

    display(['Calling model_Iz_zeros_paperform with initV=' num2str(initV2)]);
    [vz2, fval2, exitflag2] = fzero(@model_Iz_zeros_paperform, initV2, ...
                                    opts, constI, a, b, A, B, C);

    if exitflag > 0 && exitflag2 > 0
        uz = b .* vz;
        uz2 = b .* vz2;
        fprintf(1, 'equilibrium potential (vz) %.6f \n', vz); 
        fprintf(1, 'equilibrium potential 2 (vz2) %.6f \n', vz2); 
        fprintf(1, 'equilibrium n gate (uz) %.6f \n', uz); 
        fprintf(1, 'equilibrium n gate 2 (uz2) %.6f \n', uz2); 
    elseif exitflag2 > 0
        vz = -50;
        uz = 0;
        uz2 = b .* vz2;
        fprintf(1, 'equilibrium potential (vz) not found: %.6f \n', vz); 
        fprintf(1, 'equilibrium potential 2 (vz2) %.6f \n', vz2); 
        fprintf(1, 'equilibrium n gate (uz) %.6f \n', uz); 
        fprintf(1, 'equilibrium n gate 2 (uz2) %.6f \n', uz2);             
    elseif exitflag > 0
        uz = b .* vz;
        vz2 = -50;
        uz2 = 0;
        fprintf(1, 'equilibrium potential (vz) %.6f \n', vz); 
        fprintf(1, 'equilibrium potential 2 (vz2) not found: %.6f \n', vz2); 
        fprintf(1, 'equilibrium n gate (uz) %.6f \n', uz); 
        fprintf(1, 'equilibrium n gate 2 (uz2) %.6f \n', uz2);             
    else
        fprintf(1, 'There were no equilibria\n\n');
        vz = -50;
        uz = 0;
        vz2 = -50;
        uz2 = 0;
    end


    % vector field around equilibria

    % quiver plot params
    qpscale = quiverParams('qvscale'); % An overall scale factor for the quiver plot
    qpinc = quiverParams('qvinc'); % increment
    quiver_plot_scale = qpscale ./ quiverParams('qvdivisor');
    qvnearequil = quiverParams('qvnearequil');
    % Used in quiver plot if plotting whole phase space
    qvlowerv = quiverParams('qvlowerv'); % -80
    qvupperv = quiverParams('qvupperv'); % -20
    qvloweru = quiverParams('qvloweru'); % -10
    qvupperu = quiverParams('qvupperu'); % -20
    % end quiver plot params

    if uz == 0 || uz2 == 0
        qvnearequil = 0;
    end
    
    if qvnearequil
        % EITHER Generate limited trajectory space around vz, the
        % equilibrium point:
        v0 = vz + qpinc ./ 2;
        lv = v0 - qpscale .* qpinc;
        uv = vz2 + qpscale .* qpinc;
        Vgv = lv:qpinc:uv;
        u0 = uz + qpinc ./ 2;
        lu = u0 - qpscale .* qpinc;
        uu = uz2 + qpscale .* qpinc;
        ugv = lu:qpinc:uu;
    else
        % OR use this for complete trajectory space
        thescale = abs(qvlowerv-qvupperv)./qpscale;
        Vgv = linspace(qvlowerv, qvupperv, thescale);
        ugv = linspace(qvloweru, qvupperu, thescale);
        %quiver_plot_scale = quiver_plot_scale .* 10000;
    end
    % Create trajectory grid
    [Vg, ug] = meshgrid(Vgv, ugv);

    % Calculate v/u for the trajectory region:
    dv = A .* Vg .* Vg + B .* Vg + C - ug + constI;
    du = a .* (b .* Vg - ug);

    quiver_fig = figure(startFigNum+fig_i); fig_i = fig_i + 1;
    clf;
    do_power = 1;
    [stem_x, stem_y, arrow1_x, arrow1_y, arrow2_x, arrow2_y, vlens] = KG_quiver(Vg, ug, dv, du, quiver_plot_scale, do_power);
    hold on
    v = axis;
    plot(vz, uz, 'og')
    plot(vz2, uz2, '*g')
    plot(y(:,1), y(:,2), 'g')
    axis(v);
    hold off
    max_len = max(vlens);
    fprintf('maximum vector length in vector field is %.5g\n', max_len);
    tstr = sprintf ('Quiver. %s/%s', izhy_cmpt, ...
                    populationName);
    title (tstr);
    ylabel('u');
    xlabel('v');

    % find eigenvalues for the linearized system near the given eqm
    doEigenValues = 0;
    if doEigenValues
        if exitflag > 0
            aa = (k ./ Cap) .* (2 .* vz - (vr + vt));
            bb = 1 ./ Cap;
            cc = a .* b;
            dd = -a;
            Jac = [aa bb; cc dd];
            % [eigvec, eigval] = eig(Jac, 'nobalance');
            [eigvec, eigval] = eig(Jac);
            
            e1 = eigval(1,1);
            e2 = eigval(2,2);
            if isreal(e1) % real
                fprintf(1, 'real eigenvalues %.6f \t and %.6f\n', e1, e2); 
                if e1 .* e2 > 0 % same sign
                    if e1 > 0 %  positive
                        fprintf(1, 'unstable node\n');
                    else %  negative
                        fprintf(1, 'stable node\n');
                        figure(nullcline_fig)
                        hold on
                        [yy, j] = min(abs([e1 e2]));
                        %plot([vz vz + eigvec(1,j)], [uz uz + eigvec(2,j)], 'k')
                        hold off
                    end
                else % opposite sign
                    fprintf(1, 'saddle\n');
                end
            else % complex
                fprintf(1, 'complex eigenvalues %.6f %.3i \t and %.6f %.6i\n', real(e1), imag(e1), real(e2), imag(e2));
                if real(e1) > 0
                    fprintf(1, 'unstable focus\n');
                else
                    fprintf(1, 'stable focus\n');
                end
            end
        else
            disp('no equilibria to find eigenvalues for')
        end
    end % doEigenValues

    % find firing rate
    spike_thresh = 0;
    V = y(:,1);
    V_binary = V > spike_thresh;
    mask = [-1 1];
    cmask = abs(conv(+V_binary, mask));
    
    % "number of spikes in period" method
    No_spikes = sum(cmask) ./ 2;
    fprintf(1, 'Number of spikes %.1f\n', No_spikes);
    rate = 1000 .* No_spikes ./ duration;
    fprintf(1, 'Spike rate %.5f spikes/sec\n', rate);

    % Inter-spike interval method (better for low spiking rates)
    V_diff = diff(V);
    V_points = V_diff < (min(V_diff)./2);
    cur_isis = [];
    spike_count = 0;
    in_spike = 0;
    cur_isi = 0;
    svp = size(V_points);
    for vpi = 1:svp(1)
        if V_points(vpi) == 0
            if in_spike == 1
                in_spike = 0;
            end
            cur_isi = cur_isi + 1;
        else
            % We've hit a spike
            if in_spike == 0
                cur_isis = [cur_isis cur_isi];
                in_spike = 1;
                cur_isi = 0;
                spike_count = spike_count + 1;
            end
        end
    end
    
    % Discard partial ISIs (at start and end):
    cur_isis(cur_isis<(mean(cur_isis)-std(cur_isis))) = [];
    meanISI = mean(cur_isis) % milliseconds
    meanRate = 1/(meanISI/1000) % per second
    
    % lastly, stick the equilibrium point onto the nullcline fig
    figure (nullcline_fig);
    hold on
    plot(vz, uz, 'og');
    plot(vz2, uz2, '*g');
    % When comparing behaviours it's useful to fix the axes:
    xlim([-80 -20]);
    ylim([-22 22]);
    
end

function dvdt = model_Iz_zeros_paperform(v, I, a, b, A, B, C)
    u = b .* v; % as dudt = 0 = a(bv - u)
    dvdt = A .* v .* v + B .* v + C - u + I; % Now fzero can find
                                             % where this crosses 0
end

%% A script to compute the mean firing rate of the three channels
%% in the bg1 model.
function [ch1t, fr] = mean_firing_rate (basepath, popcsv, fignum)

    filepath = [basepath '/' popcsv];

    %sl = csvread
    %('/home/seb/src/SpineML_2_BRAHMS/temp/log/SNr_spike_log.csv');
    sl = csvread (filepath);

    % sl is two cols, first col is time of spike; second col is index of
    % neuron in population. Indices 0-19 are channel 1, 20-39 are channel
    % 2 and 40 - 59 channel 3.

    ch1vals = sl(sl(:,2) < 20);
    % This is "logical indexing":
    ch2vals = sl(19 < sl(:,2) & sl(:,2) < 40);
    ch3vals = sl(sl(:,2) > 39);

    % Can now do simple histogram plots of the spikes to get mean
    % firing rate:
    %figure (10);
    %hist (sl(ch1idx), 20);
    %
    % But it's easier to do a good plot if we use hist to get the data:
    numbins = 20;
    [ch1fr, ch1t] = hist (ch1vals, numbins);
    [ch2fr, ch2t] = hist (ch2vals, numbins);
    [ch3fr, ch3t] = hist (ch3vals, numbins);

    fr = [ch1fr;ch2fr;ch3fr]';

    % Scale firing rate based on bin size. numbins bins for sl whose max
    % time is:
    lasttime = sl(end, 1);
    % So time (in ms) per bin is:
    bintime = lasttime ./ numbins;
    % That gives the scaling factor, so apply it:
    fr = fr ./ bintime;
    % Now scale to spikes per second per neuron
    fr = fr .* 1000 ./ 20;

    figure (fignum);
    hax = plot (ch1t, fr, 'o-');
    legend ('Ch1','Ch2','Ch3');
    xlabel ('Time (ms)');
    ylabel ('Mean firing rate (spikes/s)');
    title (popcsv, 'interpreter', 'none');

end

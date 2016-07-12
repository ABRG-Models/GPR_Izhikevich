%% A script to compute the mean firing rate of the three channels
%% in the bg1 model.
basepath = '/home/seb/src/SpineML_2_BRAHMS/temp/log';
popcsv = 'SNr_spike_log.csv';
[tsnr_sig, frsnr_sig] = mean_firing_rate (basepath, popcsv, 10);
popcsv = 'STN_spike_log.csv';
[tstn_sig, frstn_sig] = mean_firing_rate (basepath, popcsv, 11);

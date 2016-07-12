# V is the time series of the membrane voltage, duration is the
# duration of the series in milliseconds. timestep is size of time
# step in ms.
def firing_rate (V, duration, timestep):

    import numpy as np

    # find firing rate
    spike_thresh = 0;
    V_binary = np.greater (V, spike_thresh);
    mask = [-1, 1];
    cmask = np.abs(np.convolve(V_binary, mask));

    # "number of spikes in period" method
    No_spikes = np.sum(cmask) / 2;
    rate = 1000 * No_spikes / duration; # 1000 because duration given
                                        # in milliseconds and rate
                                        # should be in s-1
    #print 'Spike rate ', rate , ' spikes/sec\n'

    # Inter-spike interval method (better for low spiking rates)
    if hasattr(V, "__len__"):
        V_diff = np.diff(V);
        V_points = np.less(V_diff, (np.min(V_diff)/2))
        #print 'V_points len', len(V_points)
        cur_isis = [];
        spike_count = 0;
        in_spike = 0;
        cur_isi = 0;
        for point in V_points:
            if point == 0:
                if in_spike == 1:
                    in_spike = 0
                cur_isi = cur_isi + 1
            else:
                # We've hit a spike
                #print 'spike'
                if in_spike == 0:
                    cur_isis.append(cur_isi);
                    in_spike = 1;
                    cur_isi = 0;
                    spike_count = spike_count + 1;

        # Discard partial ISIs (at start and end):
        mean_isi = np.mean(cur_isis)
        std_isi = np.std(cur_isis)
        #print cur_isis

        #print 'mean isi ', mean_isi, ' std_isi ', std_isi

        lowerbound = mean_isi - 2*std_isi;
        upperbound = mean_isi + 2*std_isi;

        ltcontent = np.less(cur_isis, lowerbound).astype(int)
        #print 'ltcontent', ltcontent
        np.delete (cur_isis, ltcontent)

        gtcontent = np.greater(cur_isis, upperbound).astype(int)
        #print 'gtcontent', gtcontent
        np.delete (cur_isis, gtcontent)

        meanISI = np.mean(cur_isis) * timestep
        isiRate = 1/(meanISI/1000) # per second
    else:
        isiRate = -1

    return rate, isiRate

# This version of firing_rate takes a spike threshold, and the start time so
# that a section of the data can have its firing rate determined.
def firing_rate2 (V, duration, timestep, spike_thresh, start_ms):

    import numpy as np

    # find firing rate
    start_step = int(start_ms/timestep)
    end_step = int((start_ms+duration)/timestep)
    V_binary = np.greater (V[start_step:end_step], spike_thresh);
    #print "V_binary shape",V_binary.shape
    mask = [-1, 1];
    cmask = np.abs(np.convolve(V_binary, mask));
    #print "cmask.shape:",cmask.shape

    # "number of spikes in period" method
    No_spikes = np.sum(cmask) / 2;
    rate = 1000 * No_spikes / duration; # 1000 because duration given
                                        # in milliseconds and rate
                                        # should be in s-1
    #print 'Spike rate ', rate , ' spikes/sec\n'

    # Inter-spike interval method (better for low spiking rates)
    if hasattr(V, "__len__"):
        V_diff = np.diff(V);
        V_points = np.less(V_diff, (np.min(V_diff)/2))
        #print 'V_points len', len(V_points)
        cur_isis = [];
        spike_count = 0;
        in_spike = 0;
        cur_isi = 0;
        for point in V_points:
            if point == 0:
                if in_spike == 1:
                    in_spike = 0
                cur_isi = cur_isi + 1
            else:
                # We've hit a spike
                #print 'spike'
                if in_spike == 0:
                    cur_isis.append(cur_isi);
                    in_spike = 1;
                    cur_isi = 0;
                    spike_count = spike_count + 1;

        # Discard partial ISIs (at start and end):
        mean_isi = np.mean(cur_isis)
        std_isi = np.std(cur_isis)
        #print cur_isis

        #print 'mean isi ', mean_isi, ' std_isi ', std_isi

        lowerbound = mean_isi - 2*std_isi;
        upperbound = mean_isi + 2*std_isi;

        ltcontent = np.less(cur_isis, lowerbound).astype(int)
        #print 'ltcontent', ltcontent
        np.delete (cur_isis, ltcontent)

        gtcontent = np.greater(cur_isis, upperbound).astype(int)
        #print 'gtcontent', gtcontent
        np.delete (cur_isis, gtcontent)

        meanISI = np.mean(cur_isis) * timestep
        isiRate = 1/(meanISI/1000) # per second
    else:
        isiRate = -1

    return rate, isiRate

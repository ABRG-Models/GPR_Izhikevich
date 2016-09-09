import numpy as np

# Read spike log
def read_data (logdir1, logfile):
    logpath = logdir1 + logfile
    # spikelog is two columns, times and spike index
    spikelog = np.genfromtxt (logpath, delimiter=',')
    return spikelog

# Graph the data. Sub-called by vis_data
def graph_data (bin_edges1, fr_sigI, logfile):
    ## %matplotlib inline
    import matplotlib.pyplot as plt
    plt.figure(figsize=(10,8))

    bincenters = 0.5*(bin_edges1[1:]+bin_edges1[:-1])
    
    plt.plot (bincenters, fr_sigI[0,:], '-', color='r', label='Ch0', linewidth=3)
    plt.plot (bin_edges1[0:-1],fr_sigI[1,:]+500, '-',  color='b', label='Ch1', linewidth=3)
    #plt.plot (bin_edges1[0:-1],fr_sigI[2,:], '--',  color='g', marker='o', label='Ch2', linewidth=3)

    plt.legend(loc='best',fontsize=14)

    plt.xlabel('t (ms)',fontsize=24);
    
    from matplotlib import rc
    plt.ylabel('mean neuronal firing rate (s$^{-1}$)',fontsize=24);
    plt.tick_params(axis='x', labelsize=24, pad=10)
    plt.tick_params(axis='y', labelsize=24, pad=10)
    
    plt.title(logfile)

    graphdir = '/home/pc1ssj/izhibg/GPR_Izhikevich/labbook/'

    filename = logfile.replace(' ','_')
    plt.savefig('{0}{1}.svg'.format(graphdir, filename))
    
    plt.show()

# Histogram the data for each neuron (expt should have run 100 times)
def compute_data_indiv (sl_sigI, numbins, numrepeatruns, neuronIndices=(12,22,45)):

    ch1idx_sigI  = sl_sigI[:,1] == neuronIndices[0]
    ch2idx_sigI  = sl_sigI[:,1] == neuronIndices[1]
    ch3idx_sigI  = sl_sigI[:,1] == neuronIndices[2]
    
    ch1fr, bin_edges1 = np.histogram (sl_sigI[ch1idx_sigI,0], numbins)
    ch2fr, bin_edges2 = np.histogram (sl_sigI[ch2idx_sigI,0], numbins)
    ch3fr, bin_edges3 = np.histogram (sl_sigI[ch3idx_sigI,0], numbins)
    fr_sigI = np.vstack((ch1fr,ch2fr,ch3fr))
    allfr_sigI, bin_edgesall = np.histogram (sl_sigI[:,0], numbins)

    # There are 20 neurons per channel in this model, 60 total
    neuronsPerChan = 1
    num_channels_used = 3 # We only take data from first 3 channels!
    neuronsPerInvestigation = neuronsPerChan * num_channels_used

    simlength_ms = 2000    
    
    # Scale the firing rates
    bintime = simlength_ms / numbins;
    fr_sigI  = (fr_sigI) * 1000 / (bintime * neuronsPerChan * numrepeatruns)
    allfr_sigI = (allfr_sigI * 1000) / (bintime * neuronsPerInvestigation * numrepeatruns)

    return bin_edges1, fr_sigI

def vis (sl_sigI, numbins, numrepeatruns, graphname, neuronIndices = (12,22,45)):    
    bin_edges1, fr_sigI = compute_data_indiv (sl_sigI, numbins, numrepeatruns, neuronIndices)
    graph_data (bin_edges1, fr_sigI, graphname)


# Main program entry point

d1logfile = 'D1_MSN_spike_log.csv'
d2logfile = 'D2_MSN_spike_log.csv'
stnlogfile = 'STN_spike_log.csv'
gpelogfile = 'GPe_spike_log.csv'
gpilogfile = 'GPi_spike_log.csv'

sl_D1 = np.ndarray((0,2))
sl_D2 = np.ndarray((0,2))
sl_STN = np.ndarray((0,2))
sl_GPe = np.ndarray((0,2))
sl_GPi = np.ndarray((0,2))

numrepeatruns = 100
nr = numrepeatruns

for i in range(1,numrepeatruns):
    logdir = '/fastdata/pc1ssj/SpikeGPR/run{0}/log/'.format(i)
    sl_D1 = np.vstack((sl_D1, read_data (logdir, d1logfile)))
    sl_D2 = np.vstack((sl_D2, read_data (logdir, d2logfile)))
    sl_STN = np.vstack((sl_STN, read_data (logdir, stnlogfile)))
    sl_GPe = np.vstack((sl_GPe, read_data (logdir, gpelogfile)))
    sl_GPi = np.vstack((sl_GPi, read_data (logdir, gpilogfile)))
    
# You now have 5 sets of data in memory. Save like this:
#np.savetxt('sl_D1.csv',sl_D1, delimiter=',')
#np.savetxt('sl_D2.csv',sl_D2, delimiter=',')
#np.savetxt('sl_STN.csv',sl_STN, delimiter=',')
#np.savetxt('sl_GPe.csv',sl_GPe, delimiter=',')
#np.savetxt('sl_GPi.csv',sl_GPi, delimiter=',')

# Call visualisation at the ipython cmd line as follows:

numbins = 2000 # 2000 bins for 2 seconds gives 1 ms per bin, as used by Tachibana et al 2008.
nb = numbins # short for ease of use

vis (sl_GPi, nb, nr, 'GPi', (8,22,40))

#vis (sl_D1, numbins, numrepeatruns, 'D1')
#vis (sl_D2, numbins, numrepeatruns, 'D2')
#vis (sl_STN, numbins, numrepeatruns, 'STN')
#vis (sl_GPe, numbins, numrepeatruns, 'GPe')
#vis (sl_GPi, numbins, numrepeatruns, 'GPi')

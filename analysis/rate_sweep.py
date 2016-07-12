# Sweep through a series of currents, obtaining the firing rate in each case.
def rate_sweep (constI=0, a=0.03, b=0.193, c=-65, d=0.05, vpeak=30, A=0.032, B=4, C=113.147, T=0.4, lowerV=-80, upperV=-20, qvloweru=-16, qvupperu=-10, qpscale=3, qpdivisor=0.00001, vinit=-70, uinit=-10):

    # Which experiment are we running?
    expt = 0;

    constI=0
    a=0.03; b=0.193; c=-65; d=0.05
    vpeak=30;
    A=0.032; B=4; C=113.147; T=0.4
    lowerV=-80; upperV=-20; qvloweru=-16; qvupperu=-10
    qpscale=3; qpdivisor=0.00001;
    vinit=-70; uinit=-10

    # Where's the model and data?
    modeldir = '/home/seb/abrg/abrg_local/IzhiBG/Izhi_STN';
    modelxml = modeldir+'/model.xml';
    exptxml = modeldir+'/experiment'+`expt`+'.xml';
    spineml2brahms ='/home/seb/src/SpineML_2_BRAHMS';
    spinemltmp = spineml2brahms+'/temp/log/';

    # We have to deal with the namespace used in the model.xml file.
    ns = {'UL': 'http://www.shef.ac.uk/SpineMLNetworkLayer',
          'LL': 'http://www.shef.ac.uk/SpineMLLowLevelNetworkLayer'}
  
    # Parse the model to find the parameters.
    import xml.etree.ElementTree as et
    et.register_namespace('', "http://www.shef.ac.uk/SpineMLNetworkLayer")
    et.register_namespace('LL', "http://www.shef.ac.uk/SpineMLLowLevelNetworkLayer")
    tree = et.parse(modelxml)
    root = tree.getroot()

    qvlowerv = lowerV;
    qvupperv = upperV;

    updated = 0
    for child in root.findall('./*/LL:Neuron/', ns):
        nm = child.get('name')
        #print 'Model file ', nm;
        if nm == 'a':
            _a = float(child.find('*').get('value'))
            if a != _a:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `a`)
                updated = 1
        elif nm == 'b':
            _b = float(child.find('*').get('value'))
            if b != _b:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `b`)
                updated = 1
        elif nm == 'c':
            _c = float(child.find('*').get('value'))
            if c != _c:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `c`)
                updated = 1
        elif nm == 'd':
            _d = float(child.find('*').get('value'))
            if d != _d:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `d`)
                updated = 1
        elif nm == 'A':
            _A = float(child.find('*').get('value'))
            if A != _A:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `A`)
                updated = 1
        elif nm == 'B':
            _B = float(child.find('*').get('value'))
            if B != _B:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `B`)
                updated = 1
        elif nm == 'C':
            _C = float(child.find('*').get('value'))
            if C != _C:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `C`)
                updated = 1
        elif nm == 'T':
            _T = float(child.find('*').get('value'))
            if T != _T:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `T`)
                updated = 1
        elif nm == 'v':
            _vinit = float(child.find('*').get('value'))
            if vinit != _vinit:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `vinit`)
                updated = 1
        elif nm == 'u':
            _uinit = float(child.find('*').get('value'))
            if uinit != _uinit:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `uinit`)
                updated = 1
        elif nm == 'Vpeak':
            _vpeak = float(child.find('*').get('value'))
            if vpeak != _vpeak:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `vpeak`)
                updated = 1
    if (updated > 0):
        tree.write(modelxml)

    # Parse the expt data to find the currents and any parameter overrides
    updated = 0
    tree = et.parse(exptxml)
    root = tree.getroot()
    for child in root.findall('.//UL:Property', ns): # or './*'
        nm = child.get('name')
        #print 'Expt file ', nm
        if nm == 'a':
            _a = float(child.find('UL:FixedValue').get('value'))
            print '_a: ', _a
            if a != _a:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `a`)
                updated = 1
        elif nm == 'b':
            _b = float(child.find('*').get('value'))
            if b != _b:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `b`)
                updated = 1
        elif nm == 'c':
            _c = float(child.find('*').get('value'))
            if c != _c:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `c`)
                updated = 1
        elif nm == 'd':
            _d = float(child.find('*').get('value'))
            if d != _d:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `d`)
                updated = 1
        elif nm == 'A':
            _A = float(child.find('*').get('value'))
            if A != _A:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `A`)
                updated = 1
        elif nm == 'B':
            _B = float(child.find('*').get('value'))
            if B != _B:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `B`)
                updated = 1
        elif nm == 'C':
            _C = float(child.find('*').get('value'))
            if C != _C:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `C`)
                updated = 1
        elif nm == 'T':
            _T = float(child.find('*').get('value'))
            if T != _T:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `T`)
                updated = 1
        elif nm == 'v':
            _vinit = float(child.find('*').get('value'))
            if vinit != _vinit:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `vinit`)
                updated = 1
        elif nm == 'u':
            _uinit = float(child.find('*').get('value'))
            if uinit != _uinit:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `uinit`)
                updated = 1
        elif nm == 'Vpeak':
            _vpeak = float(child.find('*').get('value'))
            if vpeak != _vpeak:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `vpeak`)
                updated = 1
    if (updated > 0):
        tree.write(exptxml)

    # Execute the model
    import os

    # Put this in a loop, and do some analysis to extract the firing rate from the output.
    spinemlcmd = '/bin/bash -c "pushd '+spineml2brahms+' && '+'LD_LIBRARY_PATH=\"\" ./convert_script_s2b -m '+modeldir+' -e'+`expt`+' -cSebtest1:I:'+`constI`+' ; popd"';
    os.system(spinemlcmd);

    # load the data from the model run
    import load_sc_data as lsd
    v, v_count, t = lsd.load_sc_data (spinemltmp+'Sebtest1_v_log.bin');
    u, u_count, tu = lsd.load_sc_data (spinemltmp+'Sebtest1_u_log.bin');

    import numpy as np

    # Now let's plot stuff. We need a series for I.
    I = np.zeros(v_count)+constI;

    # Compute nullclines
    Vn = np.linspace (lowerV, upperV, 1000);

    nc_v = A*np.power(Vn, 2)+ B*Vn + C + I[:len(Vn)];
    nc_u = Vn*b;

    %matplotlib inline
    import matplotlib.pyplot as plt

    plt.figure(figsize=(18,10))
    plt.clf;

    # Compute vector field
    if qpscale != 0:
        thescale = abs(qvlowerv-qvupperv)/qpscale;
        Vgv = np.linspace(qvlowerv, qvupperv, thescale);
        ugv = np.linspace(qvloweru, qvupperu, thescale);
        Vg, ug = np.meshgrid(Vgv, ugv);
        vdot = T*A*Vg*Vg + T*B*Vg + T*C - T*ug + T*I[:len(Vg)];
        udot = T*a*(b*Vg - ug);
        Q = plt.quiver(Vg, ug, vdot, udot*10, pivot='mid', color='k', width=0.001, scale=50)
        lef,rgt,bot,top = plt.axis()
        plt.axis([lef, rgt, bot, top])
    else:
        plt.axis([qvlowerv, qvupperv, qvloweru, qvupperu])

    plt.plot(Vn, nc_v, color='b')
    plt.plot(Vn, nc_u, color='r')

    plt.title('STN candidate model')
    plt.xlabel('v');
    plt.ylabel('u');

    plt.plot(v, u, color='g')

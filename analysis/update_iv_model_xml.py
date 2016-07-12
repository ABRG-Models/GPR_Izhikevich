# Update the model in modeldir (experiment expt) using the given model
# parameters. Write out new model.xml file and updated experiment.xml
# file.
def update_iv_model_xml (modeldir,expt,a,b,c,d,k,Ca,vr,vt,SI,T,vpeak,vinit,uinit):

    modelxml = modeldir+'/model.xml';
    exptxml = modeldir+'/experiment'+`expt`+'.xml';

    # We have to deal with the namespace used in the model.xml file.
    ns = {'UL': 'http://www.shef.ac.uk/SpineMLNetworkLayer',
          'LL': 'http://www.shef.ac.uk/SpineMLLowLevelNetworkLayer'}
  
    # Parse the model to find the parameters.
    import xml.etree.ElementTree as et
    et.register_namespace('', "http://www.shef.ac.uk/SpineMLNetworkLayer")
    et.register_namespace('LL', "http://www.shef.ac.uk/SpineMLLowLevelNetworkLayer")
    tree = et.parse(modelxml)
    root = tree.getroot()

    updated = 0
    for child in root.findall('./*/LL:Neuron/', ns):
        nm = child.get('name')
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
        elif nm == 'k':
            _k = float(child.find('*').get('value'))
            if k != _k:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `k`)
                updated = 1
        elif nm == 'Ca':
            _Ca = float(child.find('*').get('value'))
            if Ca != _Ca:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `Ca`)
                updated = 1
        elif nm == 'vr':
            _vr = float(child.find('*').get('value'))
            if vr != _vr:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `vr`)
                updated = 1
        elif nm == 'vt':
            _vt = float(child.find('*').get('value'))
            if vt != _vt:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `vt`)
                updated = 1
        elif nm == 'SI':
            _SI = float(child.find('*').get('value'))
            if SI != _SI:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `SI`)
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
        elif nm == 'k':
            _k = float(child.find('*').get('value'))
            if k != _k:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `k`)
                updated = 1
        elif nm == 'Ca':
            _Ca = float(child.find('*').get('value'))
            if Ca != _Ca:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `Ca`)
                updated = 1
        elif nm == 'vr':
            _vr = float(child.find('*').get('value'))
            if vr != _vr:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `vr`)
                updated = 1
        elif nm == 'vt':
            _vt = float(child.find('*').get('value'))
            if vt != _vt:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `vt`)
                updated = 1
        elif nm == 'SI':
            _SI = float(child.find('*').get('value'))
            if SI != _SI:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `SI`)
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

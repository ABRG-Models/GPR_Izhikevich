# Update the model in modeldir, setting all instances of the parameter disable_sigI to the value given in the argument.
def update_bg1_model_xml (modeldir,disable_sigI):

    modelxml = modeldir+'/model.xml';
    #exptxml = modeldir+'/experiment'+`expt`+'.xml';

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
        #print 'Object named: ', nm;
        if nm == 'disable_sigI':
            _theval = float(child.find('*').get('value'))
            if disable_sigI != _theval:
                fixedvalue = child.find('UL:FixedValue', ns)
                fixedvalue.set('value', `disable_sigI`)
                updated = 1
    if (updated > 0):
        tree.write(modelxml)

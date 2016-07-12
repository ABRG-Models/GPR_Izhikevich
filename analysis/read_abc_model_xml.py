# Update the model in modeldir (experiment expt) using the given model
# parameters. Write out new model.xml file and updated experiment.xml
# file.
def read_abc_model_xml (modeldir,expt):

    # Init params:
    a=0; b=0; c=0; d=0;
    A=0; B=0; C=0; T=0;
    vpeak=0; vinit=0; uinit=0;

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

    for child in root.findall('./*/LL:Neuron/', ns):
        nm = child.get('name')
        #print 'Model file ', nm;
        if nm == 'a':
            a = float(child.find('*').get('value'))
        elif nm == 'b':
            b = float(child.find('*').get('value'))
        elif nm == 'c':
            c = float(child.find('*').get('value'))
        elif nm == 'd':
            d = float(child.find('*').get('value'))
        elif nm == 'A':
            A = float(child.find('*').get('value'))
        elif nm == 'B':
            B = float(child.find('*').get('value'))
        elif nm == 'C':
            C = float(child.find('*').get('value'))
        elif nm == 'T':
            T = float(child.find('*').get('value'))
        elif nm == 'v':
            vinit = float(child.find('*').get('value'))
        elif nm == 'u':
            uinit = float(child.find('*').get('value'))
        elif nm == 'Vpeak':
            vpeak = float(child.find('*').get('value'))

    # Parse the expt data to find the currents and any parameter overrides
    tree = et.parse(exptxml)
    root = tree.getroot()
    for child in root.findall('.//UL:Property', ns):
        nm = child.get('name')
        #print 'Expt file ', nm
        if nm == 'a':
            a = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'b':
            b = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'c':
            c = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'd':
            d = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'A':
            A = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'B':
            B = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'C':
            C = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'T':
            T = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'v':
            vinit = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'u':
            uinit = float(child.find('UL:FixedValue').get('value'))
        elif nm == 'Vpeak':
            vpeak = float(child.find('UL:FixedValue').get('value'))

    return a, b, c, d, A, B, C, T, vpeak, vinit, uinit

VertexSynth : VertexAbstract {
  classvar <>synthDict;
  var <>synthDef, <>pdefnDict;


  *initClass{
    synthDict = this.loadSynthDict;
  }

  *loadSynthDict{
    var path = PathName("".resolveRelative).parentLevelPath(2);
    var folder = path +/+ PathName("SynthDefs/*");
    var files = folder.pathMatch;
    var synthDict = files.collectAs({|file|
        this.extractSynth(file).name -> this.extractSynth(file) }, IdentityDictionary);
    ^ synthDict;
  }
  *extractSynth{|file|
    ^ Object.readArchive(file);
  }

  *makeClassInterface {
    VertexTypeClassInterface.makeGenericClassInterfaces(this)
  }

  makeInstanceInterfaces{
    VertexTypeInstanceInterface.makeInstanceInterface(this);
  }

  getVertexHost {
    ^ Mesh.thisHost;
  }

  initVertex{|msg|
    this.setInstanceVars(msg);
    isProxy = false;
    this.makeInstanceInterfaces;
  }

  initProxy {|msg|
    this.setInstanceVars(msg);
		isProxy = true;
  }

  proxyUpdateHandler {|args|
  }

  errorHandler {
  }

  freeHandler{
  }

  patchOutput {|vertexIn|
    "PATCHING % TO %. \n".postf(this.name, vertexIn);
    synthDef.load;
  }

  patchInput {|vertexOut|
		"PATCHING % FROM %. \n".postf(this.name, vertexOut);
	}

  setInstanceVars {|msg|
    name = msg.name;
    mesh = msg.mesh;
    synthDef = synthDict[msg.args[0]];
    pdefnDict = IdentityDictionary.new();

    synthDef.metadata.keysValuesDo({ |parameter, pattern|
        var pdefn = parameter.asString.firstToUpper;
        pdefn = (name ++ pdefn).asSymbol;
        pdefnDict.put(parameter, Pdefn(pdefn, pattern))
        })
  }

}

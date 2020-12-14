VertexPattern : VertexAbstract {
  var <>patternDict, <>pbind;

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
      patternDict = IdentityDictionary.with(*[\name -> msg.name]);
    this.makeInstanceInterfaces;
  }

  initProxy {|msg|
    this.setInstanceVars(msg);
		isProxy = true;
    this.makeInstanceInterfaces;
  }

  proxyUpdateHandler {|args|
  }

  setHandler{|args|
    var parameterName = args[0];
    var patternString = args[1].asString;
    var pattern = patternString.interpret;
    var pdefnName = patternDict.at(parameterName).key;
    "Updating %\n".postf(pdefnName);

    Pdefn(pdefnName, pattern);
  }

  errorHandler {
  }

  freeHandler{
  }

  playHandler{
    "PLAYING".postln;
    pbind = this.pbind.play;
  }

  stopPatHandler{
    "Stopping".postln;
    pbind.stop;
  }

  patchOutput {|vertexIn|
    var vertex = Vertex(vertexIn);
    "PATCHING % TO %. \n".postf(this.name, vertex.name);
    this.makePatternDict(vertex);
    this.makePbind(vertex);
  }

  makePatternDict {|vertex|
    var pdefnArray = vertex.pdefnDict.getPairs;
    patternDict.putPairs(pdefnArray);
  }

  makePbind {|vertex|
    var pdefnArray = vertex.pdefnDict.getPairs;
    "Adding pattern pdefns to pbind:".postln;
    pbind = Pbind.new(
      \instrument, vertex.synthDef.name,
      * pdefnArray);

  }

  patchInput {|vertexOut|
		"PATCHING % FROM %. \n".postf(this.name, vertexOut);
	}

  setInstanceVars {|msg|
    name = msg.name;
    mesh = msg.mesh;
  }

}

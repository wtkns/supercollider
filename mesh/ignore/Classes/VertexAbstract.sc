VertexAbstract {
  var <>name, <>mesh, <>isProxy;

  *sendNewVertex { |...args|
    MeshMessage.newVertexRequest(*args).sendRequest;
  }

  *newVertexHandler { |msg|
    if (this.vertexExists(msg))
       { this.sendError(msg, Error("VertexName already in use."))}

       { try { this.makeVertex(msg) }
             { |error| this.sendError(msg, error)};
       };
  }

  *makeVertex{ |msg|
    var vertex = super.new.initVertex(msg);
    //Error("This is a basic error.").throw;
    msg.mesh.vertexes.put(msg.name, vertex);
    msg.mesh.patchbay.addVertex(msg.name);
    this.sendConfirmation(msg);
    this.sendProxyRequest(msg);
  }


  *sendError { |msg, error|
    var errorString = error.errorString;
    msg.methodName = \error;
    msg.args = [errorString];
    msg.sendResponse;
  }

  *errorHandler { |msg|
    (msg.args[0]).postln
  }

  *sendConfirmation{ |msg|
    msg.methodName = \confirmation;
    msg.sendResponse;
  }

  *confirmationHandler {|msg|
    ("Successfully Created " ++ msg.name).postln;
  }

  *sendProxyRequest{ |msg|
    msg.methodName = \proxyRequest;
    msg.args = [\proxyVertex];
    msg.sendProxyRequest;
  }

  *proxyRequestHandler{ |msg|
   if (this.vertexExists(msg).not)
       { "received proxy request".postln;
         try { this.makeProxy(msg) }
             { |error| this.sendError(msg, error)};
       };
  }

  *makeProxy{ |msg|
    var proxy = super.new.initProxy(msg);
    var vertexes = msg.mesh.vertexes;
    //Error("This is a basic error.").throw;
    vertexes.put(msg.name, proxy);
    this.sendProxyConfirmation(msg);
  }

  *sendProxyConfirmation{ |msg|
    msg.methodName = \proxyConfirmation;
    msg.sendResponse;
  }

  *proxyConfirmationHandler { |msg|
      "proxy response received".postln;
      // from vertexResponseHandler
      // should track that all mesh hosts confirm proxy request
      // and resend if necessary?
  }

  sendMethodRequest { |selector, args|
    var vertexHost = this.getVertexHost;
    var msg = MeshMessage.newMethodRequest(this, vertexHost, selector, args).sendRequest;
  }

  sendProxyUpdate { |args|
    var msg = MeshMessage.newMethodRequest(this, Mesh.broadcastAddr, \proxyUpdate, args).sendRequest;
  }

  *vertexExists { |msg|
    ^ (msg.mesh).hasVertex(msg.name)
  }

  doesNotUnderstand {|selector ...args|
    this.sendMethodRequest(selector, args);
    ^ "sent method request";
  }

  // OVERLOADED:
  free {
    this.sendMethodRequest(\free)
  }

  // REQUIRED SUBCLASS RESPONSIBILITIES
  *makeClassInterface {
    this.subclassResponsibility(thisMethod);
	}

  *makeInstanceInterface {
    this.subclassResponsibility(thisMethod);
  }

  initVertex {
   this.subclassResponsibility(thisMethod);
  }

  initProxy {
   this.subclassResponsibility(thisMethod);
  }

  getVertexHost {
   this.subclassResponsibility(thisMethod);
  }

  proxyUpdateHandler {
   this.subclassResponsibility(thisMethod);
  }

	errorHandler {
    this.subclassResponsibility(thisMethod);
  }

  freeHandler {
    this.subclassResponsibility(thisMethod);
  }

  patchInput {
    this.subclassResponsibility(thisMethod);
  }

  patchOutput {
    this.subclassResponsibility(thisMethod);
  }

  /*printOn {|stream|
    stream << this.instVarDict.values.postln;
  }*/
}

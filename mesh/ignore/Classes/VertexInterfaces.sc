VertexTypeClassInterface {
// this enables calling Class methods on a remote machine
// needs more error handling
  *makeGenericClassInterfaces { |vertexType|
    var oscDefName = (vertexType.asSymbol ++ "Interface").asSymbol ;
    var oscDefPath = "/" ++ vertexType.asSymbol ++ "/interface" ;

    OSCdef(oscDefName, { |msg, time, host, recvPort|
      var method ;
      msg = MeshMessage.decode(host, msg) ;
      method = (msg.methodName++"Handler").asSymbol ;
      vertexType.tryPerform(method, msg) ;
    }, oscDefPath)
  }
}

VertexTypeInstanceInterface {
// this enables calling Instance methods on a remote machine
  *makeInstanceInterface { |vertex|
    var oscDefName = (vertex.name.asSymbol ++ "Interface").asSymbol ;
    var oscDefPath = "/" ++ vertex.name.asSymbol ++ "/interface" ;

    OSCdef(oscDefName, { |argMsg, time, host, recvPort|
      var msg = MeshMessage.decode(host, argMsg);
      var method = (msg.methodName++"Handler").asSymbol;
      var vertex = Vertex.at(msg.name);

      if (vertex.class.findMethod(method).isNil)
      { msg.methodName = \error;
        msg.args = [(method ++ " Method does not exist")];
        msg.sendResponse }

      { try {vertex.perform(method, msg.args)}{|error| "error".postln }};
    }, oscDefPath)
  }

}

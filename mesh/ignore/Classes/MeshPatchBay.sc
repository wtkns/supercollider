MeshPatchbay {
  var <>vertexList;

  *new  {
    ^super.new().init;
    }

  init {
    vertexList = MeshNamedList.new();
  }

  addVertex {|vertexName|
//    should  update proxies
    vertexList.addLast(vertexName, MeshNamedList.new());
  }

  addPatch {|vertexOut, vertexIn|
    // TODO: add error catching and validation, eg. not VertexA == VertexB, etc.
    //needs to update proxies

    if (this.hasVertex(vertexOut)){
      if (this.hasVertex(vertexIn)){
        (vertexList.at(vertexOut)).addLast(vertexIn, MeshPatch.new(vertexOut, vertexIn))
      }{("No such vertex:" ++ vertexIn).postln};
    }{("No such vertex:" ++ vertexOut).postln};
  }

  getPatch {|firstVertexName, secondVertexName|
    ^ vertexList.at(firstVertexName).at(secondVertexName);
  }

  hasVertex {|vertexName|
    ^ vertexList.includesKey(vertexName);
  }

  patchList { ^ vertexList }
}

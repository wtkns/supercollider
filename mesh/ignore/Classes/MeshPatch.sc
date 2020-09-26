MeshPatch {
  var <>rand;

  *new  { |vertexOut, vertexIn|
    ^super.new.init(vertexOut, vertexIn);
    }

  init {|vertexOut, vertexIn|
    rand = 5000.rand;
    Vertex(vertexOut).patchOutput(vertexIn);
    Vertex(vertexIn).patchInput(vertexOut);
    ("Mesh Patch created: " ++ rand).postln;
  }

  printOn { |stream| stream << this.class.name }

}

Vertex {
	classvar <vertexTypeDict;

	*initVertexTypes { // called by Mesh.initClass
		vertexTypeDict = VertexTypeDict.new;
	}

	*new {| vertexName, vertexTypeName, vertexHostName, meshName ...args|
		var vertex = this.at(vertexName, meshName);
		if (vertex == List.new)
			{	vertexTypeDict[vertexTypeName].sendNewVertex( vertexName, vertexTypeName, vertexHostName, meshName, args );
				^ "Sent new vertex request";
			};

		^ vertex
	}

	*at {|vertexName, meshName |
		var mesh = try {this.getMesh(mesh)} {|error| error.postln};
		var vertex = this.getVertex(vertexName, mesh);

		^ vertex // or empty List
	}

	*getHost{|vertexHostName, mesh|
		if (vertexHostName.isNil)
				{	^ Mesh.thisHost};
		^ mesh[vertexHostName];
	}

	*getMesh{|meshName|
		if (meshName.isNil)
				{	^ this.currentMesh };
		^ Mesh.at(meshName)
	}

	*currentMesh {
		if (Mesh.hasCurrent)
				{	^ Mesh.current};
		"nil Mesh".error; ^ Error;
	}

	*getVertex {|vertexName, mesh|
		var vertex = mesh.vertexes.at(vertexName);
		if (vertex.isNil)
				{^ List.new};
		^ vertex
	}

}

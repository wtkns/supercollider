TestVertex : UnitTest {
	var mesh, thisHost, hostName;

	setUp {
			"Testing Vertexes".postln;
			mesh = TestMesh.new.makeMesh;
			mesh.push;
			thisHost = Mesh.thisHost;
			hostName = thisHost.name.asSymbol;
	}

	tearDown {
	}

	test_vertex {|local = true|
		this.vertexInitialized;
		if (local == true)
			{this.setLocalBroadcastAddr};

			Vertex(\server1, \server, \rose, \mesh1);
//		this.makeVertex(\server1, \server, hostName, mesh);
		2.0.wait;
		this.vertexExists(mesh, \server1);
		2.0.wait;
		Vertex(\server1).boot;
	}

	setLocalBroadcastAddr {
		"Resetting broadcast address. local loopback testing only!".warn;
			Mesh.broadcastAddr.addr = MeshHostAddr("127.0.0.1", 57120 + (0..7))
	}

	vertexInitialized {
		this.assert( Vertex.vertexTypeDict.isKindOf(IdentityDictionary),
			"Vertex Type Dictionary created");
	}

	makeVertex { |name, type, hostName, mesh|
		Vertex.new(name, type, hostName, mesh);
	}

	vertexExists{ |mesh, key|
		this.assert( mesh.vertexes.includesKey(key),
			"Key Exists in mesh.vertexes");

	}

	makeOSCdefs {
		"setting up test OSCdef responder".postln;
		OSCdef(\TestVertexServerRequestor, {|msg, time, addr, recvPort|
		("VertexServerRequestor received message: " ++ msg).postln;
		}, '/VertexServer/request/new');
	}
}

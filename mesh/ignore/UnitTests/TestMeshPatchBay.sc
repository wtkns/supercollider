TestMeshPatchbay : UnitTest {
	var mesh, patchbay;

	setUp {
			"Testing Patchbay".postln;
			patchbay = MeshPatchbay.new;
	}

	tearDown {
		"Tearing down".postln;
		patchbay.free;
	}

	test_meshPatchbay {
		"Tests:".postln;
		Mesh(\mesh1, local:true).push;
		Mesh.current.hosts.beacon.start;
		mesh = Mesh(\mesh1);
		this.isPatchbay;
		1.0.wait;
		this.addVertexes;
		2.0.wait;
		this.addPatches;
		1.0.wait;
		this.testPatches;
		"Tests Completed!".postln
	}

	addVertexes{
		Vertex(\server1, \server, \rose, \mesh1);
		Vertex(\server2, \server, \rose, \mesh1);
		Vertex(\synth1, \synth, \rose, \mesh1);
		Vertex(\synth2, \synth, \rose, \mesh1);
		Vertex(\pattern1, \pattern, \rose, \mesh1);
		Vertex(\pattern2, \pattern, \rose, \mesh1);
	}

	addPatches {
		Mesh(\mesh1).patchbay.addPatch(\pattern1, \synth1);
		Mesh(\mesh1).patchbay.addPatch(\synth1, \server1);
		Mesh(\mesh1).patchbay.addPatch(\pattern2, \synth2);
		Mesh(\mesh1).patchbay.addPatch(\synth2, \server2);
	}

	isPatch {|patch|
		this.assert( patch.isKindOf(MeshPatch),
		"patch is Patch".postln);
	}

	isPatchbay {
		this.assert( mesh.patchbay.isKindOf(MeshPatchbay),
		"patchbay is Patchbay".postln);
	}

	testPatches{
		this.assert( Mesh(\mesh1).patchbay.getPatch(\pattern1, \synth1).isKindOf(MeshPatch),
		"patch is Patch".postln);

	}


}

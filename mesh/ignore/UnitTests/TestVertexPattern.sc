TestVertexPattern : UnitTest {
	var mesh, patchbay;

	setUp {
	Mesh(\mesh1, local:true).push;
	0.25.wait;
	Vertex(\localServer, \server, \rose, \mesh1);
	0.25.wait;
	Vertex(\localServer).boot;
	1.5.wait;
	Vertex(\sinSynth, \synth, \rose, \mesh1, \sin);
	0.25.wait;
	Vertex(\sawSynth, \synth, \rose, \mesh1, \saw);
	0.25.wait;
	Mesh(\mesh1).patchbay.addPatch(\sawSynth, \localServer);
	0.25.wait;
	Mesh(\mesh1).patchbay.addPatch(\sinSynth, \localServer);
	0.25.wait;
	Vertex(\sawPattern, \pattern, \rose, \mesh1);
	0.25.wait;
	Vertex(\sinPattern, \pattern, \rose, \mesh1);
	0.25.wait;
	Mesh(\mesh1).patchbay.addPatch(\sawPattern, \sawSynth);
	0.25.wait;
	Mesh(\mesh1).patchbay.addPatch(\sinPattern, \sinSynth);

	}

	tearDown {
		"Tearing down".postln;
		patchbay.free;
	}

	test_meshPatchbay {
		"Tests:".postln;

	Vertex(\sinPattern).play;
	Vertex(\sawPattern).play;
	5.0.wait;

	Vertex(\sinPattern).set(\dur, Pshuf([1/4, 1/4, 1/8, 1/8, 1/2, 1/2], inf) );
	5.0.wait;

	Vertex(\sawPattern).set(\dur, Pshuf([1/4, 1/4, 1/8, 1/8, 1/2, 1/2], inf) );
	5.0.wait;

	Vertex(\sinPattern).stopPat;
	0.25.wait;
	Vertex(\sawPattern).stopPat;

		"Tests Completed!".postln
	}



}

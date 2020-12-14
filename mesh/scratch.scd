MeshDebugMon.on;
MeshCommandParser.on;
~win.deactivate;

UnitTest.gui;
Mesh.test;
Vertex.test;
MeshPatchbay.test;
MeshHostsManager.test;


//Audio Test:
VertexPattern.test;


// MANUALLY:
Mesh(\mesh1, local:true).push;
Vertex(\localServer, \server, \rose, \mesh1);
Vertex(\localServer).boot;


Vertex(\sinSynth, \synth, \rose, \mesh1, \sin);
Mesh(\mesh1).patchbay.addPatch(\sinSynth, \localServer);
Vertex(\sinPattern, \pattern, \rose, \mesh1);
Mesh(\mesh1).patchbay.addPatch(\sinPattern, \sinSynth);
Vertex(\sinPattern).play;


Vertex(\sawSynth, \synth, \rose, \mesh1, \saw);
Mesh(\mesh1).patchbay.addPatch(\sawSynth, \localServer);
Vertex(\sawPattern, \pattern, \rose, \mesh1);
Mesh(\mesh1).patchbay.addPatch(\sawPattern, \sawSynth);
Vertex(\sawPattern).play;

Mesh(\mesh1).patchbay.patchList;

VertexSynth.synthDict.at(\sin).metadata.postcs;





Vertex(\sinPattern).set(\att, Pmeanrand(0.015,0.951, inf));
Vertex(\sinPattern).set(\pan, Pmeanrand(-1.0,1.0, inf));

Vertex(\sinPattern).set(\dur, Pshuf([1/4, 1/4, 1/8, 1/8, 1/2, 1/2], inf) );
Vertex(\sinPattern).set(\dur, Pshuf([1/14, 1/14, 1/18, 1/18, 1/12, 1/12]/4, inf) );

Vertex(\sinPattern).set(\mod1, Pmeanrand(0,0.0051, inf) );
Vertex(\sinPattern).set(\mod2, Pmeanrand(0,0.51, inf) );

Vertex(\sinPattern).set(\mod1, Pmeanrand(0,1.5, inf) );
Vertex(\sinPattern).set(\mod2, Pmeanrand(0,1.5, inf) );

Vertex(\sinPattern).set(\dur, Pmeanrand(0,5.0, inf) );
Vertex(\sinPattern).set(\freq, Pmeanrand(50,150, inf) );
Vertex(\sinPattern).set(\amp, Pmeanrand(0,1.5, inf));



Vertex(\sinPattern).stopPat;
Vertex(\sawPattern).stopPat;



// more info
VertexSynth.synthDict.postln;


Vertex(\fmSynth, \synth, \rose, \mesh1, \fm);
Mesh(\mesh1).patchbay.addPatch(\fmSynth, \localServer);
Vertex(\fmPattern, \pattern, \rose, \mesh1);
Mesh(\mesh1).patchbay.addPatch(\fmPattern, \fmSynth);

Vertex(\fmPattern).play;



SynthDescLib.global.browse; //synthDescs.postln

OSCdef.all.keys.postln



Mesh(\mesh1, local: true).push;


//boot the server
Vertex(\server1).boot;

//list available meshes
Mesh.list;

//list available vertexes
Mesh(\mesh1).vertexes.postln;

//list patches
Mesh(\mesh1).patchbay.patchList;


//see current mesh
Mesh.current;

// and examine the Mesh stack:
// the last one is the latest (we could reverse this)
Mesh.stack;

//pop it off the stack:
Mesh.pop;

// free it
Mesh(\mesh1).free;

// find out what hosts are available in the current mesh:
Mesh(\mesh1).hosts;

// ping all hosts
Mesh(\mesh1).ping;



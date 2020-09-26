//mesh file
//////////////////////////


// I. Initialize Mesh
//////////////////////////

// dont forget to set ~online in config.scd
~mesh = MeshManager.new(s);
~mesh.start;

~mesh.addSynthVertex(~host, \sawVertex, ~host, \saw);
~mesh.addControlVertex(~host, \sawPattern, ~host, \sawVertex);
~mesh.playControl(~host, \sawPattern);
~mesh.addSynthVertex(~host, \freeverbVertex, ~host, \freeverb);
~mesh.playSynth(~host, \freeverbVertex);
~mesh.vertexMgr.busList.reRouteBus(\sawVertex, \freeverbVertex);
~mesh.vertexMgr.findGroup(\freeverbVertex).set(\room, 0.75, \mix, 0.65);
~mesh.vertexMgr.busList.reRouteBus(\sawVertex, \masterOut);
~mesh.addSynthVertex(~host, \ringModVertex, ~host, \ringMod);
~mesh.playSynth(~host, \ringModVertex);
~mesh.vertexMgr.busList.reRouteBus(\sawVertex, \ringModVertex);
~mesh.vertexMgr.busList.reRouteBus(\sawVertex, \freeverbVertex);
~mesh.vertexMgr.busList.reRouteBus(\freeverbVertex, \ringModVertex);
~mesh.stopControl(~host, \sawPattern);



// goal:

Vertex.pattern(\name, \targetNode)
Vertex.synth(\name, \synthdef, \outVertex)
Vertex.effect(\name, \synthdef, \inVertex, \outVertex)

Vertex(\name).play;
Vertex(\name).stop;
Vertex(\name).free;

(
~mesh.addSynthVertex(~host, \fmGrainVertex, ~host, \fmGrain);
~mesh.addSynthVertex(~host, \clickVertex, ~host, \click);
~mesh.addSynthVertex(~host, \pulsarVertex, ~host, \pulsar);
~mesh.addSynthVertex(~host, \sawVertex, ~host, \saw);
~mesh.addSynthVertex(~host, \kickVertex, ~host, \kick);
~mesh.addSynthVertex(~host, \freeverbVertex, ~host, \freeverb);
~mesh.addSynthVertex(~host, \pulseVertex, ~host, \pulse);
~mesh.addSynthVertex(~host, \hihatVertex, ~host, \hihat);
~mesh.addSynthVertex(~host, \ringModVertex, ~host, \ringMod);
~mesh.addSynthVertex(~host, \rlpfVertex, ~host, \rlpf);
~mesh.addSynthVertex(~host, \freeverbVertex, ~host, \freeverb);
~mesh.addSynthVertex(~host, \ampModVertex, ~host, \ampMod);
~mesh.addSynthVertex(~host, \distVertex, ~host, \dist);
~mesh.addSynthVertex(~host, \sinVertex, ~host, \sin);
~mesh.addSynthVertex(~host, \fmVertex, ~host, \fm);
~mesh.addSynthVertex(~host, \ixibassVertex, ~host, \ixibass);
)





~mesh.buses;

// get pdefn
~mesh.vertexMgr.busList.getPdefn(\freeverbVertexIn);

// get actual bus
~mesh.vertexMgr.busList.getBus(\freeverbVertexIn);

// or
~mesh.vertexMgr.busList.getPdefn(\freeverbVertexIn).pattern;


~mesh.addControlVertex(~host, \sawPattern, ~host, \sawVertex);


~mesh.addControlVertex(~host, \freeverbPattern, ~host, \freeverbVertex);

/*

		// use busList Pdefn in pbind
		// item == \outBus and: { }; //.pattern.postcs

		// use busList Bus in pbind
		//		item == \inBus and: { busList.getBus((targetSynthNode++"In").asSymbol)};
		// FIX: Use targetSynthNode to copy OUT pdefn from busList for \outBus and \inBus




~name=\sin;

~pairs = [
	\instrument: ~name,
	\freq: Prand([1, 1.2, 2, 2.5, 3, 4], inf) * 200,
	\dur: 0.1
];

~pairs.postln
~pairs.asStream.play;

~pbind = Pbind(*~pairs);

~pbind.play





n = \rose

(d = SynthDef(\sin, {|
			outBus=(~masterOut),
			freq=440,
			dur=1.0,
			amp=0.25,
			pan=0,
			att=0.15,
			mod1=0.25,
			mod2=0.01|
			var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
			var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
	        var modulate = SinOsc.ar(XLine.kr((mod1*2000)+0.001, (mod2*2000)+0.001, dur), 0, 2pi);
			var sin = SinOsc.ar(freq, modulate, amp);
			Out.ar(outBus, Pan2.ar(sin * envGen, pan))},
metadata: (\nodeType: \PSynth, \author: "james watkins")
);


c = d.allControlNames.collect(_.name);

a = [];
e = c.collect{
	|item, index|
	a = a.add(item.asSymbol);
	a = a.add(Pdefn(n++d.name++item).asSymbol) };

c.postln;
a.postln;

u=Pbind(*a).play;
)


~sinsaw = PStream(
	Pbind(
		\target, Pdefn(\sinsawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsawInstrument),
		\outBus, Pdefn(\sinsawOutBus),
		\freq, Pdefn(\sinsawFreq),
		\dur, Pdefn(\sinsawDuration),
		\amp, Pdefn(\sinsawAmp),
		\pan, Pdefn(\sinsawPan),
		\att, Pdefn(\sinsawAtt),
		\mod1, Pdefn(\sinsawMod1),
		\mod2, Pdefn(\sinsawMod2)
	), Pdefn(\sinsawWait),
	~addrBook, ~clock, 1);









Pbind(*e).play;













PStream {	// pStream: pattern stream

    var <>bind, <>interval, <>addrBook, <>clock, <>quant, <>routine, <>isPlaying;

    *new {|streamName, synthName, target, outBus, interval, clock, quant|
        ^super.new.init(streamName, synthName, target, outBus, interval, clock, quant);
    }

	init {|streamName, synthName, target, outBus, interval, clock, quant|

		bind = Pbind.new;
		synthName = synthName;
		target = target;
		outBus = outBus; //get bus number from sphinctermanager
		interval = interval;
		clock = clock;
		quant = quant;

		"new stream creation:".postln;

		// Pstream.New(strName, synthName, target=~me, outBus=~master,
	    //             interval=0.05, clock=~clock, quant=1)

	}

	play {
		var bindStream = bind.asStream;
		var intervalStream = interval.asStream;
		isPlaying = true;
        routine = {
            loop({
                this.send(bindStream.next(()));
				intervalStream.next(()).wait
            })
        }.fork(clock, quant: quant)
    }

	stop {
		routine.stop;
		isPlaying = false;
	}

	step{
		var bindStream = bind.asStream;
		this.send(bindStream.next(()));
	}

    send {|msg|
        var target, path, sndMsg;
		target = (addrBook.at(msg.removeAt(\target))).addr;
        path = msg.removeAt(\oscpath);
        sndMsg = msg.getPairs;
        target.sendMsg(path, *sndMsg);
		sndMsg.postln;
    }


}
//// SYNTHDEF MANAGER STUFF

	listSynths{|key, value| ^synthdefMgr.listSynths(key, value)}

	addSynthdef{|synth| ^synthdefMgr.addSynthdef(synth)}

	removeSynthdef{|key| ^synthdefMgr.removeSynthdef(key)}



	////  NODE MANAGER STUFF

	newSynthNode {|nodeName, synthdefName, hostName|

		var synthdef, nodeType;
		(synthdefMgr.exists(synthdefName)).not and: {^ "No SynthDef exists with that name. Aborting!!"};
		(synthdefMgr.nodeType(synthdefName)).isNil and: {^ "Unknown SynthDef Node Type. Aborting!!"};
		(nodeMgr.exists(nodeName)) and: {^ "A node with that name already exists. Aborting!!"};

		synthdef = synthdefMgr.synth(synthdefName);
		nodeType = synthdefMgr.nodeType(synthdefName);
		synthdef.postln;
		nodeType.postln;
		nodeMgr.newSynthNode(nodeName, synthdef, nodeType, hostName);

	}

	newControlNode {|nodeName, targetNodeName, hostName|}

	listNodes {|hostName| ^nodeMgr.listNodes(hostName)}

	removeNode {|nodeName|}

	queryNodes {^nodeMgr.queryNodes}

	listGroups {^nodeMgr.listGroups}

	nodeType {|nodeName|}

	patch {|sphincter, stream|}


	listStreams {|key, value|
		//nodeName, or hostname?
	}

	playStream {|key|}

	listPlaying {|host|}

	stopStream {|key|}

	stopAllStreams {}

	setStream {|stream, control, newPattern|}

	setTarget {|stream, nodeName|}


	listSphincters {|node|}






//// OSC LISTENERS

	loadOSCDefs {

		OSCdef.newMatching(\testMsg,
			{|msg, time, addr, recvPort |
				addr.sendMsg("/testReply");
		}, "/testMsg"); // path matching
		("  testMsg Listener initialized").postln;

		OSCdef.newMatching(\testReply,
			{|msg, time, addr, recvPort |
				"Successful messaging test reply received from \\".post;
				(~addrBook.findname(addr)).postln;
		}, "/testReply"); // path matching
		("  testReply Listener initialized").postln;

		OSCdef.newMatching(\testAudio,
			{|msg, time, addr, recvPort |
				(~addrBook.findname(addr)).postln;
				~testTone = Synth.head(~synthGroup, \saw,
					[\freq, msg.at(1).midicps,
						\pan, -1, \dur, 5.0, \outBus, ~masterOut]);
				~testTone = Synth.head(~synthGroup, \saw,
					[\freq, msg.at(2).midicps,
						\pan, 1, \dur, 5.0, \outBus, ~masterOut]);
		}, "/testAudio"); // path matching
		("  testAudio Listener initialized").postln;

	}





MeshSynthdefManager.browse
*/
// create nodes, not streams or sphincters directly.
// types:
//                    nodetype: Key
//                              \PSynth
//                                 PSphinc
//                                 AStream
//                              \CSynth
//                                 CSphinc
//                                 AStream
//                              \ESynth
//                                 ASphinc
//                                 CSphinc
//                                 AStream
//                              \PNode (given a target PSphincter)
//                                 PStream
//                              \CNode (given a target CSphincter)
//
//
// PNode (PStream)                       -> pattern out
// ANode (AStream)                       -> from Audio.In
// PSynth (PSphinc : AStream)            -> Pattern Synth
// MSynth (SSphinc : AStream)            -> Mono Synth
// ESynth (SSphinc, ASphinc : AStream)   -> Effect Synth
// PtPNode (PSphinc : PStream)           -> Pattern Filter
//
// hostName

// Server.local.outputBus.post

/*  Stream Manager:

sessionMgr.newStream(strName, synthName, target=~me,
outBus=~master, interval=0.05, clock=~clock, quant=1)

*** output to post window to copy and paste
    ~strName.set(key, value);
for all controls) ***


~sessionMgr.addStream(\streamName, \synthName, target, outBus,
	                   interval, clock, quant);


~sessionMgr.listStreams;
~sessionMgr.listPlaying;

~sessionMgr.playStream(\streamName);
~sessionMgr.stopStream(\streamName);
~sessionMgr.stopAllStreams();
~sessionMgr.setStream(\streamName, controlName, newValue(eg. Pshuf, Prand(Pshuf()), etc));

-? or ?-

~strName.set(key, value);
~strName.start;
~strName.stop;
~strName.step;
~strName.free;


*/


/*

MeshStreamLibrary : IdentityDictionary {
	// this stores the stream with a name:
	// Dictionary (Stream Name -> Stream (any type))

	add {|streamName, type, synthName, target, outBus, interval, clock, quant|
		//(synthdefLib.at(synthName)).notNil and: {
		var stream;

		stream = PStream.new(streamName, type, synthName, target, outBus, interval, clock, quant);
		this.put(streamName, stream)
	}

	remove {|key|
	}

	getStreamType{|key|
		^this[key].class;
	}

	ofType{|type|
	}

	withTarget{|key|
	}

	update { }

	stopAll { }

	playAll { }

	playing {
		// ^ set this.isplaying == true
	}


}



SStream {	// sStream: synth Stream (eg monophonic synth)

	*new { ^super.new.init()}
	init { }
    stop { }
    start { }

}

MeshStreamManager{
	var <streamLib;

	*new { ^super.new.init }

	init {
		streamLib = MeshStreamLibrary.new;
	}

	addStream {
		|streamName, synthName, target, outBus, interval, clock, quant|

		streamLib.add(streamName, synthName, target, outBus, interval, clock, quant);
	}

	listStreams {^streamLib.keys}

	playStream {}

	listPlaying {}

	stopStream {}

	stopAllStreams {}

	setStream {}

	getStreamType  {|key| ^streamLib.getStreamType(key)}
}




/*

	testAudio {|peer|
		this.send(peer, "/testAudio", 50, 60 )
	}

	testAllAudio {
		"Testing peers audio:".postln;
		this.peers.do({arg item, i;
			this.send(item.name, "/testAudio",
				50+(2*i),
				60+(3*i) )});
	}

	testMsg{|peer|
		("  Test Message sent to \\"+peer).postln;
		this.send(peer, "/testMsg")
	}

	testAllMsg {
		"Testing peers messaging:".postln;
		this.peers.do({arg item, i;
			this.testMsg(item.name)})
	}

	findname{|addr|
		^(this.peers.detect({arg item, i; (item.addr==addr)})).name;
	}


*/



/*

	var <dict;

	*new { ^super.new.init }

	init {
		dict = IdentityDictionary.new;


		// // Effects
		// "Loading Effects".postln;
		// ~effectFiles = "effects/*".resolveRelative.pathMatch.collect {
		// 	|file|
		// 	file.loadPaths;
		// (file +/+ " loaded").postln };
		// ("Effects initialized: Success " + ~delim).postln;


		// CRUD Effect busses//

		// Create new effects bus
		OSCdef.newMatching(\addEffectOSC,
			{|msg, time, addr, recvPort |
				~addrBook.me.effectBank.addEffect(msg[1].asSymbol, msg[2]);
		}, "/addEffectOSC"); // path matching

		// Delete
		// request to free an effect bus
		OSCdef.newMatching(\freeEffectOSC,
			{|msg, time, addr, recvPort |
				~addrBook.me.effectBank.freeEffect(msg[1].asSymbol);
		}, "/freeEffectOSC"); // path matching

		// // receive, unpack, and update effectList
		OSCdef.newMatching(\updateEffectListOSC,
			{|msg, time, addr, recvPort |
				var name =(~addrBook.findname(addr));
				var newMsg = Dictionary.newFrom(msg.drop(1));
				~addrBook.at(name).effectList.dict=newMsg;
		}, "/updateEffectListOSC");

		// request to set effect bus
		OSCdef.newMatching(\setEffectOSC,
			{|msg, time, addr, recvPort |
				~addrBook.me.effectBank.setEffect(msg[1].asSymbol, msg[2], msg[3]);
		}, "/setEffectOSC"); // path matching

		// Request
		// //request to GET effect bus control values
		// OSCdef.newMatching(\effectGet,
		// 	{|msg, time, addr, recvPort |
		// 		//		~addrBook.me.effectSet(msg[1].asSymbol, msg[2], msg[3]);
		// }, "/effectGet"); // path matching

		// Get Bundle and send EffectList Update
		// OSCdef.newMatching(\fetchEffectList,
		// 	{|msg, time, addr, recvPort |
		// 		var reply=List.new;
		// 		~addrBook.me.effectBank.dict.keysValuesDo({|key, value|
		// 			reply.add(key);
		// 			reply.add(value[0].index);
		// 		});
		// 		addr.sendMsg("/updateEffectList", *reply);
		// 		"sending update reply".postln;
		// 		reply.postln;
		// }, "/fetchEffectList");
		//		}



	}
}

*/

	//effect handlers:
	// . Add Effect
	//    . take defaults for args
	//    . set different output bus
	// . Update List on local machine
	// . output list
	// . return bus.index
	// . delete effect
	// . get control value
	// . set control value

	addEffect {|key, effect|
		this.sendMsg("/addEffectOSC", key, effect)
	}

	freeEffect {|key|
		this.sendMsg("/freeEffectOSC", key)
	}

	setEffect {|key, control, value|
		this.sendMsg("/setEffectOSC", key, control, value)}



	//bankList { ^this.effectBank.bankList}

	//effectIndex {|key| ^this.effectList.effectIndex(key)}

	//effectsList { ^this.effectList.names}

	broadcastEffectList {
		var msg = ~me.bankList.getPairs;
		"updating Peers' EffectLists".postln;
		this.sendAll("/updateEffectListOSC", *msg);
	}



	//NOT done
	// effectGet {|key, control, value|
	// this.effectList.effectGet();}




*/



// probably junk: Not adding streams directly
// addStream {
// 	|streamName, synthName, target, outBus, interval, clock, quant|
//
// 	// check that synth exists
// 	// pass synthdef (or at least type) along for streamMgr
//
// 	synthdefMgr.exists(synthName)  and: {
// 		var type = synthdefMgr.type(synthName);
// 		^streamMgr.addStream (streamName, type, synthName, target, outBus, interval, clock, quant);
// 	}
// 	^ "Synthdef not found!"
//
//
//
//
// }
// getStreamType {|key| ^streamMgr.getStreamType(key)}
//
// listStreamsType {^streamMgr.listStreamsType}





// dev notes

// need to set up a way to use SynthDescLib to get control values from remote machines.

//
// old way:
//          ~me.effectSet(\distortion, \postGain, 0.12);
//
//          or on a remote peer with:
//          ~addrBook.send(\river, "/effectSet", \distortion, \postGain, 0.12);


// stacking effects?

// synths to set up:
//
// polysynth
// drum synth
//
// filters:
// bpf
// hpf
// formant
// vocoder


// midi to control effects
// midi to control pdefns
// encapsulating scales?


// lookup a named effect
SynthDescLib.global.at(~addrBook.me.effectBank.dict[\reverb][1].defName);

// GET All Effect Controls Names:

(
~addrBook.me.effectBank.dict.keysValuesDo{
	|key, value|
	var synth = value[1];
	(synth !== nil).if({(key ++ ":  ").post;
		SynthDescLib.global.at(synth.defName).controlNames.postln})}
)



// GET All Effect Controls AND Values:

(
~addrBook.me.effectBank.dict.keysValuesDo{
	|key, value|
	var synth = value[1];
	(synth !== nil).if({
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				(key ++ ":  ").post;
				(control++": "++value).postln})}})}
)

// GET ONE Effect Controls AND Values:

(
~effectLookup = {|name|
	var synth = ~addrBook.me.effectBank.dict[name][1];
	(synth !== nil).if({
		//(name ++ ":  ").post;
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				(control++": "++value).postln})}})}
)

// then:

~effectLookup.value(\distortion);
~effectLookup.value(\reverb);

~rose.setEffect(\reverb, \room, 0.99);
~rose.setEffect(\reverb, \mix, 0.99);
~rose.setEffect(\reverb, \damp, 0.99);


// Collect One Effect Controls AND Values into dict:

(
~effectLookupDict = {|name|
	var synth = ~addrBook.me.effectBank.dict[name][1];
	var dict = Dictionary.new;
	dict.postln;
	(synth !== nil).if({
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				dict.add(control -> value)})}});
	dict.postln;

})

// then:

a= ~effectLookupDict.value(\reverb);
a.postln;

// SET Effect Control Value:

~addrBook.me.effectBank.dict[\reverb][1].set(\mix, 0.5);
a= ~effectLookupDict.value(\reverb);
a.postln;

~addrBook.me.effectBank.dict[\reverb][1].set(\mix, 0.75);
a= ~effectLookupDict.value(\reverb);
a.postln;






{ Formlet.ar(Impulse.ar(20, SinOsc.ar(SinOsc.ar(0.25, 0, 2), 0, 2pi)), MouseY.kr(700,2000,1), 0.005, MouseX.kr(0.01,0.2,1)) }.play;

(
x = {
    MoogFF.ar(
        Pulse.ar([40,121], [0.3,0.7]),
        SinOsc.kr(LFNoise0.kr(0.42).range(0.001, 2.2)).range(30, 4200),
        0.83 * 4)}.play(s);
)
x.free;


SynthDef(\hello, {arg freq = 1000;
Out.ar(0, SinOsc.ar(Lag.kr(freq,3),mul: 0.8));
}).send(s);

s.sendMsg(\s_new, \hello, 1000, 0, 0);
s.sendMsg(\n_set, 1000, \freq, 500);
s.sendMsg(\n_set, 1000, \freq, 200);
s.sendMsg(\n_set, 1000, \freq, 600);
s.sendMsg(\n_set, 1000, \freq, 400);
s.sendMsg(\n_set, 1000, \freq, 1000);
s.sendMsg(\n_free, 1000);

s.boot;







// 2. Set up a Pstream with some basic defaults.
//    Assign a Pdefn for each arg you want to control.
//    You could do this multiple times for the same synth
//    assigning different ***(or the same!)*** Pdefns
//    for different voices with shared or separate control values


~sin = PStream(
	Pbind(
		\target, Pdefn(\sinTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinInstrument),
		\outBus, Pdefn(\sinOutBus),
		\freq, Pdefn(\sinFreq),
		\dur, Pdefn(\sinDuration),
		\amp, Pdefn(\sinAmp),
		\pan, Pdefn(\sinPan),
		\att, Pdefn(\sinAtt),
		\mod1, Pdefn(\sinMod1),
		\mod2, Pdefn(\sinMod2)
	), Pdefn(\sinWait),
	~addrBook, ~clock, 1);

~pulse = PStream(
	Pbind(
		\target, Pdefn(\sinTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\pulseInstrument),
		\outBus, Pdefn(\pulseOutBus),
		\freq, Pdefn(\pulseFreq),
		\dur, Pdefn(\pulseDuration),
		\amp, Pdefn(\pulseAmp),
		\pan, Pdefn(\pulsePan),
		\att, Pdefn(\pulseAtt),
		\mod1, Pdefn(\pulseMod1),
		\mod2, Pdefn(\pulseMod2),
		\int, Pdefn(\pulseInt)
	), Pdefn(\pulseWait),
	~addrBook, ~clock, 1);

~saw = PStream(
	Pbind(
		\target, Pdefn(\sawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sawInstrument),
		\outBus, Pdefn(\sinsawOutBus),
		\freq, Pdefn(\sawFreq),
		\dur, Pdefn(\sawDuration),
		\amp, Pdefn(\sawAmp),
		\pan, Pdefn(\sawPan),
		\att, Pdefn(\sawAtt)
	), Pdefn(\sawWait),
	~addrBook, ~clock, 1);


~ixibass = PStream(
	Pbind(
		\target, Pdefn(\ixiTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\ixiInstrument),
		\outBus, Pdefn(\ixiOutBus),
		\amp, Pdefn(\ixiAmp),
		\t_trig, Pdefn(\ixiTrig),
		\freq, Pdefn(\ixiFreq),
		\rq, Pdefn(\ixiRQ)
	), Pdefn(\ixiWait),
	~addrBook, ~clock, 1);

~granular = PStream(
	Pbind(
		\target, Pdefn(\granTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\granInstrument),
		\outBus, Pdefn(\granOutBus),
		\numChannels, Pdefn(\granNumChannels),
		\bufOffset, Pdefn(\granBufOffset),
		\bufPos, Pdefn(\granBufPos),
		\rate, Pdefn(\granRate),
		\granDurMin, Pdefn(\granDurMin),
		\granDurMax, Pdefn(\granDurMax),
		\playRateMin, Pdefn(\granPlayRateMin),
		\playRateMax, Pdefn(\granPlayRateMax),
		\envBuf, Pdefn(\granEnvBuf),
		\envLevels, Pdefn(\granEnvLevels),
		\envTimes, Pdefn(\granEnvTimes),
		\pan, Pdefn(\granPan),
		\amp, Pdefn(\granAmp),
		\noteDur, Pdefn(\granNoteDuration)
	), Pdefn(\granWait),
	~addrBook, ~clock, 1);


~sinsaw = PStream(
	Pbind(
		\target, Pdefn(\sinsawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsawInstrument),
		\outBus, Pdefn(\sinsawOutBus),
		\freq, Pdefn(\sinsawFreq),
		\dur, Pdefn(\sinsawDuration),
		\amp, Pdefn(\sinsawAmp),
		\pan, Pdefn(\sinsawPan),
		\att, Pdefn(\sinsawAtt),
		\mod1, Pdefn(\sinsawMod1),
		\mod2, Pdefn(\sinsawMod2)
	), Pdefn(\sinsawWait),
	~addrBook, ~clock, 1);


~fm = PStream(
	Pbind(
		\target, Pdefn(\fmTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\fmInstrument),
		\outBus, Pdefn(\fmOutBus),
		\freq, Pdefn(\fmFreq),
		\carPartial, Pdefn(\fmCar),
		\modPartial, Pdefn(\fmMod),
		\index, Pdefn(\fmIndex),
		\dur, Pdefn(\fmDuration),
		\amp, Pdefn(\fmAmp),
		\pan, Pdefn(\fmPan),
		\att, Pdefn(\fmAtt),
		\mod1, Pdefn(\fmMod1),
		\mod2, Pdefn(\fmMod2)
	), Pdefn(\fmWait),
	~addrBook, ~clock, 1);


~kick = PStream(
	Pbind(
		\target, Pdefn(\kickTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\kickInstrument),
		\outBus, Pdefn(\kickOutBus),
		\subFreq, Pdefn(\kickSubFreq),
		\hitFreq, Pdefn(\kickHitFreq),
		\dur, Pdefn(\kickDuration),
		\amp, Pdefn(\kickAmp),
		\pan, Pdefn(\kickPan),
	), Pdefn(\kickWait),
	~addrBook, ~clock, 1);

~hiHat = PStream(
	Pbind(
		\target, Pdefn(\hhTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\hhInstrument),
		\outBus, Pdefn(\hhOutBus),
		\lpFreq, Pdefn(\hhlpFreq),
		\hpFreq, Pdefn(\hhhpFreq),
		\dur, Pdefn(\hhDuration),
		\amp, Pdefn(\hhAmp),
		\pan, Pdefn(\hhPan),
	), Pdefn(\hhWait),
	~addrBook, ~clock, 1);



/*

//eg: a = ~scale.value(~keyC, ~minor, 5);
a = ~midiscale.value(~keyC, ~minor, 5);
b = [1,3,5];

c = a[[1,2,4,5]];
c = a[b];
c = a[b.scramble];


a =	Prand([
	Pseq([Pshuf(~midiscale.value(~keyC, ~minor, 5), 2), 800], 2),
	Pseq([Pshuf(~midiscale.value(~keyC, ~minor, 6), 1),800], 2),
	Pseq([Pshuf(~midiscale.value(~keyG, ~minor, 5), 2),800], 2)
], 4).asStream;

(
a =	Pseq([
	Pshuf(~midiscale.value(~keyC, ~minor, 5), 2),
	Pseq([200], 1)], 4).asStream;

x = a.asStream;
60.do({ x.next.postln; });
)

~midiscale.value(~keyC, ~minor, 5)[[1,3,5].stutter(3)].sputter(0.5, 16).scramble;



       | Notes
Octave |  C  C#  D   D#  E   F   F#  G   G#  A   A#  B
-------|------------------------------------------------
     0 |  0   1   2   3   4   5   6   7   8   9  10  11
     1 | 12  13  14  15  16  17  18  19  20  21  22  23
     2 | 24  25  26  27  28  29  30  31  32  33  34  35
     3 | 36  37  38  39  40  41  42  43  44  45  46  47
     4 | 48  49  50  51  52  53  54  55  56  57  58  59
     5 | 60  61  62  63  64  65  66  67  68  69  70  71
     6 | 72  73  74  75  76  77  78  79  80  81  82  83
     7 | 84  85  86  87  88  89  90  91  92  93  94  95
     8 | 96  97  98  99 100 101 102 103 104 105 106 107
     9 |108 109 110 111 112 113 114 115 116 117 118 119
    10 |120 121 122 123 124 124 126 127



AEOLIAN
{0, 2, 3, 5, 7, 8, 10}

BLUES
{0, 2, 3, 4, 5, 7, 9, 10, 11}

CHROMATIC
{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}

DIATONIC_MINOR
{0, 2, 3, 5, 7, 8, 10}

DORIAN
{0, 2, 3, 5, 7, 9, 10}

HARMONIC_MINOR
{0, 2, 3, 5, 7, 8, 11}

INDIAN
{0, 1, 1, 4, 5, 8, 10}

LOCRIAN
{0, 1, 3, 5, 6, 8, 10}

LYDIAN
{0, 2, 4, 6, 7, 9, 10}

MAJOR
{0, 2, 4, 5, 7, 9, 11}

MELODIC_MINOR
{0, 2, 3, 5, 7, 8, 9, 10, 11}

MINOR
{0, 2, 3, 5, 7, 8, 10}

MIXOLYDIAN
{0, 2, 4, 5, 7, 9, 10}

NATURAL_MINOR
{0, 2, 3, 5, 7, 8, 10}

PENTATONIC
{0, 2, 4, 7, 9}

PHRYGIAN
{0, 1, 3, 5, 7, 8, 10}

TURKISH
{0, 1, 3, 5, 7, 10, 11}

*/


MeshSynthdefLibrary : IdentityDictionary {


	// (Synthdef Name -> Identity Dictionary:
	//                   (synth: SynthDef
	//                    name: Key
	//                    controls: Array
	//                    nodetype: Key
	//                              \PSynth
	//                                 PSphinc
	//                                 AStream
	//                              \CSynth
	//                                 CSphinc
	//                                 AStream
	//                              \ESynth
	//                                 ASphinc
	//                                 CSphinc
	//                                 AStream
	//                    host
	//                    author
	//                    source)
	// )

	addSynthdef {|synth|

		var name, controls, nodeType, host, author, source;

		host = ~hostname;
		name = synth.name.asSymbol; // get the name

		(this.exists(name)) and: {"synth already exists, overwriting!!"};

		// creates an array of the control names
		controls = synth.allControlNames.collect(_.name);

		// tests to be sure metadata exists otherwise it will crash
		(synth.metadata).notNil and: {
			author = synth.metadata.at(\author);
			nodeType = synth.metadata.at(\nodeType);
		};

		source = synth.func.def.sourceCode;

		this.put( name, IdentityDictionary.newFrom(
			List[
				\def, synth,
				\controls, controls,
				\source, source,
				\nodeType, nodeType,
				\author, author,
				\host, host
			]
		));
		// used to add synth here, moved to node manager.

		this.changed(\add, synth)

	}

	nodeType {|key| ^(this.at(key)).at(\nodeType)}

	synth {|key| ^(this.at(key)).at(\def)}

	exists {|key| ^(this.at(key)).notNil}

	list{|key, value|
		var set = Set.new, valid = false;

		// empty arguments, return list of all synths
		key.isNil and: {value.isNil and: {^ this.keys}};

		// key is synth, return value from dict:
		this.at(key).notNil and:{
			((this.at(key)).at(value)).notNil and: {^ (this.at(key)).at(value)}
			^ "Valid Synth, no such parameter"};

		// not a synth? check for anything with that parameter type
		this.keysValuesDo{|name, def|
			def.keys.includes(key).if {valid = true};
			(def.at(key)==value).if {set.add(name)}
		};

		// nothing with that parameter type?
		(valid.not) and:{^ "Not a valid parameter"};

		// otherwise return set
		^set;
	}

	removeSynthdef {|key|

		this.at(key).notNil and:{
			this.removeAt(key);
			this.changed(\remove, key);
			SynthDef.removeAt(key);
			^ "removed"}
		^"Synthdef not found!"
	}

	update {|changed, what| this.changed(what, changed) }

TEMPSynthdefManager {
	var synthdefLibrary;

	*new {|host| ^super.new.init(host) }


	synth{|key| ^synthdefLib.synth(key)}

	removeSynthdef{|key| ^synthdefLib.removeSynthdef(key)}


	nodeType{|key| ^synthdefLib.nodeType(key)}

	listSynths{|key, value| ^synthdefLib.list(key, value)}

	loadOSCDefs {
		OSCdef.newMatching(\synthMsg,
			{|msg, time, addr, recvPort |
				var dict = Dictionary.newFrom(msg.drop(1));
				var inst = dict.removeAt(\instrument);
				var busnum = ~addrBook.me.effectBank.busIndex(dict[\outBus]);
				dict.add(\outBus -> busnum);
				Synth.head(~synthGroup, inst, dict.getPairs);
		}, "/synthMsg"); // path matching
	}






}




	newSynthNode {|nodeName, synthdef, nodeType, hostName|
		(nodeLib.exists(nodeName)) and: {^ "A Node exists with that name. Aborting!!"};
		nodeLib.addSynthNode(nodeName, synthdef, nodeType, hostName, groups, server)
	}

	newControlNode {|nodeName, targetNodeName, hostName|
		(nodeLib.exists(nodeName)) and: {^ "A Node exists with that name. Aborting!!"};
		(nodeLib.exists(nodeName)).not and: {^ "No Target Node exists with that name. Aborting!!"};
		nodeLib.addSynthNode(nodeName, targetNodeName, hostName)

	}

	queryNodes { server.queryAllNodes}

	listNodes {|hostName| ^nodeLib.listNodes(hostName)}

	listGroups {|hostName| ^groups.keys}

	exists {|key| ^nodeLib.exists(key) }


}

MeshGroupLibrary : IdentityDictionary {

	*new { ^super.new.init }

	init { }

	addGroup {|name, position, server|
		// FIX: tail, head, etc.
		//   \addToHead	(the default) add at the head of the group specified by target
		//   \addToTail	add at the tail of the group specified by target
		//   \addAfter	add immediately after target in its server's node order
		//   \addBefore	add immediately before target in its server's node order
		//   \addReplace	replace target and take its place in its server's node order
		var group = Group.new(server, position);
		this.put(name, group);
		// currentEnvironment.put(name.asSymbol, group)
	}

}

MeshNodeLibrary : IdentityDictionary {
	addSynthNode {|nodeName, synthdef, nodeType, hostName, groups, server|
		var typeCase = case
		    { nodeType == \PSynth }   {
			this.put(nodeName, MeshPSynthNode.new(nodeName, hostName, synthdef, server, groups));

		}
		{ nodeType == \MSynth }   { this.put(nodeName, MeshMSynthNode.new())}
		{ nodeType == \ESynth }   { this.put(nodeName, MeshESynthNode.new())};

		postf("creating new % Synth node from % synthdef on %, called %\n",
			nodeType, synthdef.name, hostName, nodeName);
		this.addGroup(\nodeName);

		synthdef.add;
		"loading synthdef to server: Success".postln;

	}

	addControlNode {|nodeName, targetNodeName, hostName|
		postf("creating new Control node for %", targetNodeName)

	}

	exists {|nodeName| ^this.includesKey(nodeName)}

	listNodes {|hostName| ^this.getPairs}
}

MeshNode {

	*new { ^super.new.init }

	init { }

}

MeshControlNode : MeshNode {

	*new { ^super.new.init }

	init {}

}
//Pattern Streams
MeshPNode : MeshControlNode {}

MeshANode : MeshControlNode {}

MeshP2PNode : MeshControlNode {}



MeshSynthNode : MeshNode{}

MeshPSynthNode : MeshSynthNode {
	var <>hostName, <>synthdef;

	*new {|nodeName, hostName, synthdef|
		^super.new.init(nodeName, hostName, synthdef) }

	init {|nodeName, host, synth|


		hostName = host;
		synthdef = synth;



		//("make new PSphincter with nodename: "++nodeName).postln;
		//("make new AStream with nodename: "++nodeName).postln;

	}


}

MeshMSynthNode : MeshSynthNode {
			// add synth to synthGroup

}

MeshESynthNode : MeshSynthNode {
			// add synth to effectGroup
	        // check node order for routing, etc

}
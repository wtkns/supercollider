// FIX: switch to parGroups, to allow parallel group processing in supernova
MeshVertexManager {
	var <vertexLibrary, groupList, <>busList;

	*new {|host| ^super.new.init(host) }

	init {|host|

		("Starting Vertex Manager").postln;
		vertexLibrary = MeshVertexLibrary.new;
		("  Vertex Library Created: Success").postln;
		this.addHost(host);
		("  Local Host Added: Success").postln;
		groupList = MeshGroupList.new();
		("  Vertex Group List Added: Success").postln;
		busList = MeshBusList.new();
		("  Vertex Bus List Added: Success").postln;
		busList.addMasterOut();
		("  Master Out Bus Added: Success").postln;
		("Vertex Manager initialized: Success\n").postln;

	}

	//FIX add initial AUDIO IN and AUDIO OUT buses
	addHost {|host|
		vertexLibrary.put(host, IdentityDictionary.new());
	}

	addSynthVertex {|host, vertexName, synthdef|
		(synthdef.metadata).notNil and: {
			var vertexType = synthdef.metadata.at(\vertexType);
			var numAudioInBuses = (synthdef.metadata.at(\inBusAr));
			var numAudioOutBuses = (synthdef.metadata.at(\outBusAr));

			// create buses for Audio Rate IN
			// in list, adds (\vertexNameIn -> (Pdefn(\vertexNameIn, newBusObject) -> newBusObject))
			numAudioInBuses.notNil and: {
				numAudioInBuses > 0 and: {
					busList.addInBus((vertexName++"In").asSymbol, numAudioInBuses)}
			};

			// create Pdefn for Audio Rate OUT default to -> \masterOut.
			// in list, adds (\vertexNameOut ->
			// (Pdefn(\vertexNameOut, Pdefn(\vertexNameIn) -> busList.getBus(\vertexNameIn))
			// extra mapping to bus not necessary currently, but maintains format and later ??
			numAudioOutBuses.notNil and: {
				numAudioOutBuses > 0 and: {
					busList.addOutBus((vertexName++"Out").asSymbol, \masterOut)} // use masterOut as default
			};

			case

			{vertexType == \PSynth} {
				var group=Group.head;
				groupList.addFirst(vertexName.asSymbol->group);
				vertexLibrary[host].put(vertexName, MeshPSynthVertex.new(synthdef, group))
			}

			{vertexType == \CSynth} {
				var group=Group.head;
				groupList.addFirst(vertexName.asSymbol->group);
				vertexLibrary[host].put(vertexName, MeshCSynthVertex.new(synthdef, group))
			}

			{vertexType == \ESynth} {
				var group=Group.tail;
				groupList.add(vertexName.asSymbol->group);
				vertexLibrary[host].put(vertexName, MeshESynthVertex.new(synthdef, group))
			};

			^ (vertexName++" Vertex Created")
		};
	}


	addControlVertex {|vertexhost, vertexName, targethost, targetSynthVertexName|
		var synthDef, outBusPdefn, targetGroup;
		"MVM started".postln;
		synthDef = vertexLibrary[targethost][targetSynthVertexName].synthdef;
		"synthdef retrieved".postln;
		outBusPdefn = busList.getPdefn((targetSynthVertexName++Out).asSymbol); //returns Pdefn
		"Pdefn retrieved".postln;
		targetGroup = this.findGroup(targetSynthVertexName);
		"group retrieved".postln;
		vertexLibrary[vertexhost].put(vertexName, MeshControlVertex.new(synthDef, vertexName, outBusPdefn, targetGroup));
	}


	removeVertex {|host, vertexName|
		this.findGroup(vertexName).freeAll;
		this.findGroup(vertexName).free;
		groupList.removeAt(this.findGroupIndex(vertexName));
		vertexLibrary[host][vertexName].removeMe;
		vertexLibrary[host].removeAt(vertexName);
	}

	listVertexs {|host| ^vertexLibrary[host].keys}

	buses { ^ busList.do{|item,index|
		index.post;
		(":  "++item.asCompileString).postln}}

	hosts { ^vertexLibrary.keys}

	groups { ^groupList.postln}

	vertexControls{|host, vertexName| ^vertexLibrary[host][vertexName].controls}

	playSynth {|host, vertexName|
		var outBus = busList.getOutBus(vertexName);
		var inBus = busList.getInBus(vertexName);
		^vertexLibrary[host][vertexName].playSynth(outBus, inBus) }

	synthdef {|host, vertexName| ^vertexLibrary[host][vertexName].synthdef}

	playControl {|host, vertexName| ^vertexLibrary[host][vertexName].playControl}

	stopControl {|host, vertexName| ^vertexLibrary[host][vertexName].stopControl}

	controlVertex {|host, vertexName| ^vertexLibrary[host][vertexName]}

	findGroup{|vertexName| ^ groupList.detect({|assn| assn.key == vertexName}).value}

	findGroupIndex{|vertexName| ^ groupList.detectIndex({|assn| assn.key == vertexName})}

	freeGroup {|vertexName| ^ groupList[(this.findGroupIndex(vertexName))].value.freeAll}

}

MeshVertexLibrary : IdentityDictionary {
}


MeshSynthVertex {
	var synthdef, group;

	newVertex {|newsynth, newgroup|
		synthdef = newsynth;
		group = newgroup;
		synthdef.add; //initialize on the server
	}

	playSynth {|outBus, inBus|  ^synthdef.play(group, [outBus: outBus, inBus: inBus] )}

	controls { ^synthdef.allControlNames.collect(_.name) }

	synthdefName { ^synthdef.name}

	synthdef { ^synthdef}

	removeMe { SynthDef.removeAt(this.synthdefName) }

}



// \addToHead	(the default) add at the head of the group specified by target
// \addToTail	add at the tail of the group specified by target
// \addAfter	add immediately after target in its server's vertex order
// \addBefore	add immediately before target in its server's vertex order
// \addReplace	replace target and take its place in its server's vertex order


MeshPSynthVertex : MeshSynthVertex {
	// Pattern Synth, P-Sphincter, A-Stream
	// each vertex should have its own group, and all
	// synths from the same vertex should be added there

	*new {|synth, group| ^super.new.init(synth, group)}

	init {|synth, group| this.newVertex(synth, group) }

}

MeshCSynthVertex : MeshSynthVertex {
	// Controlled(monophonic) Synth, C-Sphincter, A-Stream
	// can coexist in a group together

	*new {|synth, group| ^super.new.init(synth, group) }

	init {|synth, group| this.newVertex(synth, group) }

}


MeshESynthVertex : MeshSynthVertex {
	// Effect Synth, A-Sphincter, C-Sphincter, A-Stream
	// must go at tail

	*new {|synth, group| ^super.new.init(synth, group) }

	init {|synth, group| ^this.newVertex(synth, group) }

}

MeshGroupList : List {
	// FIX: On init, add masterOut and Audio In groups
	//      add new groups relative to these , eg. addAfter

}

MeshBusList : List {

	// (VertexNameIN -> (Pdefn -> BUS))
	// (VertexNameOut -> (Pdefn -> VertexNameIn)
	//
	// FIX: On init, add masterOut and Audio In Buses
	//      add new Buses relative to these , eg. addAfter

	// use item.value.pattern.postcs to get out contents of pdefn

	addMasterOut { this.add(\masterOut ->
		(Pdefn(\masterOut, Server.default.outputBus) -> Server.default.outputBus))}

	// Add ordering
	addInBus {|busname, numBuses|
		var newbus = Bus.audio(Server.default, numBuses);
		this.add(busname -> (Pdefn(busname, newbus)->newbus));
	}

	addOutBus {|busname, targetBus|
		var targetOut = this.getBus(targetBus);
		this.add(busname -> (Pdefn(busname, targetOut)-> targetOut));
	}

	getBus{|key| ^(this.detect{|item| item.key == key}).value.value}

	setBus{|key, bus| ^(this.detect{|item| item.key == key}).value.value = bus}

	getInBus{|key| ^(this.detect{|item| item.key == (key++"In").asSymbol}).value.value}

	getOutBus{|key| ^(this.detect{|item| item.key == (key++"Out").asSymbol}).value.value}

	getPdefn{|key| ^(this.detect{|item| item.key == key}).value.key}

	getInPdefn{|key| ^(this.detect{|item| item.key == (key++"In").asSymbol}).value.key}

	getOutPdefn{|key| ^(this.detect{|item| item.key == (key++"Out").asSymbol}).value.key}

	reRouteBus{|outVertex, newInVertex|
		Pdefn(this.getOutPdefn(outVertex).key, this.getInPdefn(newInVertex));
		this.setBus((outVertex++"Out").asSymbol, this.getInBus(newInVertex));
		^this.postln;
		// eg: Pdefn(~meshMgr.vertexMgr.busList.getOutPdefn(\sawVertex).key, ~meshMgr.vertexMgr.busList.getInPdefn(\freeverbVertex));

	}
}


MeshControlVertex {
	var <>pbind, stream, playing;

	*new {|synthdef, vertexName, outBusPdefn, targetGroup| ^super.new.init(synthdef, vertexName, outBusPdefn, targetGroup) }

	init {|synthdef, vertexName, outBusPdefn, targetGroup|
		pbind = this.makePbind(synthdef, vertexName, outBusPdefn, targetGroup); //vertexName for naming Pdefns
		pbind.postln;
	}

	makePbind {|synthdef, vertexName, outBusPdefn, targetGroup|
		var pairs = [\instrument, synthdef.name];
		pairs = pairs.add(\group);
		pairs = pairs.add(targetGroup);

	synthdef.allControlNames.collect(_.name).collect{|item|
			var defaultPattern, pdefn, src;

			if (item == \outBus)  {
				pairs = pairs.add(item.asSymbol);
				pairs = pairs.add(outBusPdefn)}

			{defaultPattern = synthdef.metadata.at(item.asSymbol);
				pdefn = Pdefn((vertexName++item).asSymbol, defaultPattern);
				src = (synthdef.metadata.at(item.asSymbol)).asCompileString;
				("Pdefn(\\"++vertexName++item++", "++src++")").postln;
				pairs = pairs.add(item.asSymbol);
				pairs = pairs.add(pdefn)}
		};

		pairs.postln;
		^ Pbind.new(*pairs);
	}


	playControl {
		stream = pbind.play;
		playing = true;
	}

	stopControl { pbind.stop;
		stream.stop;
		playing = false;
	}

	removeMe {}


}



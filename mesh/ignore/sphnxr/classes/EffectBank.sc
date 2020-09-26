EffectBank {
		// This only exists on the Server where its synths and buses are running
		// this is where effects are actually CRUD'ed
	var <>dict;

	*new { ^super.new.init }

	init { dict = Dictionary.newFrom(List[\masterOut, List[Server.local.outputBus, nil]]) }

	bus {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		^(this.dict[key.asSymbol]).at(0)
	}

	busIndex {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^0}); // return 0 for master bus
		^((this.dict[key.asSymbol]).at(0)).index
	}

	addEffect {|key, effect|
		var newBus = Bus.audio(Server.local,2);
		var newSynth = Synth.head(~effectGroup, effect.asSymbol,
			[\outBus, this.busIndex("masterOut"), \inBus, newBus]);
		dict.add(key.asSymbol -> List[newBus, newSynth]);
		~addrBook.broadcastEffectList
	}

	freeEffect {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		if (key==\masterOut, {"cannot free masterOut".postln; ^nil});
		this.dict[key.asSymbol].at(1).free; // free the bus first!
		this.dict.removeAt(key.asSymbol); // then delete the dictionary row
		(key + "Effect removed").postln;
		~addrBook.broadcastEffectList;
	}

	bankList {
		var reply=Dictionary.new;
		this.dict.keysValuesDo({|key, value|
			reply.add(key -> value[0].index);
		});
		^reply;
	}

	setEffect {|key, control, value|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		this.dict[key.asSymbol].at(1).set(control.asSymbol, value);
	}
	//
	// // get effect control values
	// effectGet { |key|
	//
	// 	/// NOT done:
	// 	/*	f = { |synth|
	// 	var x = (), d = SynthDescLib.global[synth.defName.asSymbol];
	// 	d.notNil.if { d.controls.do { |c| x.put(c.name, c.defaultValue) } };
	// 	x
	// 	};
	//
	// 	// asynchronous !
	//
	// 	g = { |synth|
	// 	var x = (), d = SynthDescLib.global[synth.defName.asSymbol];
	// 	d.notNil.if { d.controls.do { |c|  synth.get(c.name,  { |y|
	// 	x.put(c.name, y) }) } };
	// 	x
	// 	}*/
	//
	//
	// }
}
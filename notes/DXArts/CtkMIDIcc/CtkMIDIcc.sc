/************************************************************
                  stm 2012	(Stelios Manousakis)                 
************************************************************/
// a class to quickly interface with MIDI and Ctk

CtkMIDIcc	{
	
	var < responders; // a dictionary containing: respName -> [ [ccNr, env, round, action], [ccResp, bus.set(mappedVal), mappedVal, rawVal] ];
	var <dumpedState;
	var sevenBitRecip;
	
	*new {
		^super.new.init
	}

	// what the dictionary should contain, so that it's accessible
	// \name -> [ responder, busID, currentValue ]
	// then you could do this: CtkMIDIcc.dict[\knob1][1]
	// could be nice to do: c = CtkMIDIcc.new ... c.val(\knob1) OR c.bus(\knob1)	
	init {
		// a dictionary to store all channels
		responders = Dictionary.new;
		// a number of buses - the maximum alloted in this class instance
		//buses = channels.collect({CtkControl.play});
		sevenBitRecip = 127.reciprocal;
		// initialize midi client
		if(MIDIClient.initialized.not,{ MIDI.init; MIDIIn.connectAll });
		dumpedState = Dictionary.new;
	}

	// free a bus, remove the responder
	clear {|name|
		/// remove its responders
		this.ccresp(name) ?? this.ccresp(name).remove;
		// free the bus
		this.bus(name) ?? this.bus(name).free;
		// do I also need to remove it from the responders?
		//responders.removeAt(name);
	}

	// free all buses, remove all responders
	clearAll {
		responders.keysDo({|name|
			this.clear(name);
		})
	}
	
	// dump the current state of all responders
	// note: this may need to come out in a different format? Maybe a dictionary?
	dumpVals {
		var state = [];
		responders.keysDo({|key|
			state = state.add(this.val(key));
			dumpedState[key] = state
		});
		^state
	}

	// should also add the responder to the dictionary, so it can be removed
	startResp {|name, ccNr, env, round = 0.0078125, action, initVal = 0|
		var ccResp, curve, grid, func, bus;
		// store a bunch of things here for easy access: the ccnumber, the env for the mapping, round amount, the action
		
		// store the args into the dictionary, don't use as they are, to be able to change them later
		bus = CtkControl.play;
		bus.set(initVal);
		responders[name] = [ [ccNr, env, round, action], [nil, bus, initVal, nil ] ];
		
		ccResp = CCResponder({|src, chan, num, val|
			var mappedVal, rawVal;
			// the if statement here is redundant... will remove it soon
			if (num == ccNr, {
				rawVal = val;
				// map using the curve and grid
				mappedVal = this.env(name)[val * sevenBitRecip].round(this.round(name));
				// store a bunch of things here for easy access... the responder, the CtkControl, and the actual output value
				responders[name][1] = [ccResp, bus.set(mappedVal), mappedVal, rawVal];
				// pass the value to the provided function
				this.action(name).value(mappedVal)
			})
		},
		num: ccNr
		);
		ccResp; // return the responder to be able to message/free it
	}

	// this is a lite version, WITHOUT an internal bus running
	startResp0 {|name, ccNr, env, round = 0.0078125, action, initVal = 0|
		var ccResp, curve, grid, func, bus;
		// store a bunch of things here for easy access: the ccnumber, the env for the mapping, round amount, the action	
		responders[name] = [ [ccNr, env, round, action], [nil, nil, initVal, nil ] ];
		ccResp = CCResponder({|src, chan, num, val|
			var mappedVal, rawVal;
			// the if statement here is redundant... will remove it soon
			if (num == ccNr, {
				rawVal = val;
				// map using the curve and grid
				mappedVal = this.env(name)[val * sevenBitRecip].round(this.round(name));
				// store a bunch of things here for easy access... the responder, the CtkControl, and the actual output value
				responders[name][1] = [ccResp, nil, mappedVal, rawVal];
				// pass the value to the provided function
				this.action(name).value(mappedVal)
			})
		},
		num: ccNr
		);
		ccResp; // return the responder to be able to message/free it
	}
	
	// get the ccresponder
	ccresp {|name|
		^responders[name][1][0];
	}
	
	// get the bus
	bus {|name|
		^responders[name][1][1];
	}	
	
	// get the current value
	val {|name|
		^responders[name][1][2];
	}	
	
	// get the current raw value
	rawVal {|name|
		^responders[name][1][3];
	}		

	// get the cc nr
	ccnr {|name|
		^responders[name][0][0]
	}	
	
	// some of these should be settable as well!: env, round, action. Maybe when they contain an extra argument?
	// e.g. c.env(\knob1): is a getter
	// c.env(\knob1, Env([0, 1], [1], \sin)); is a setter	
	// get/set the mapping envelope curve
	env {|name, env|
		if(env.isNil, {
			^responders[name][0][1]},
			{
				^responders[name][0][1] = env
			});
	}
	
	// get/set the rounding grid
	round {|name, round|
		if(round.isNil, {
			^responders[name][0][2]},
			{
				^responders[name][0][2] = round
			});
	}	
	
	// get/set the action function
	action {|name, func|
		if(func.isNil, {
			^responders[name][0][3]},
			{
				^responders[name][0][3] = func
			});
	}
	
			
	// would be nice to be able to read/write (export/import of textfiles)			
}
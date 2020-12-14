+ Peer {

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

	bankList { ^this.effectBank.bankList}

	effectIndex {|key| ^this.effectList.effectIndex(key)}

	effectsList { ^this.effectList.names}

	setEffect {|key, control, value|
		this.sendMsg("/setEffectOSC", key, control, value)}

	//NOT done
	// effectGet {|key, control, value|
	// this.effectList.effectGet();}

}

+ AddrBook {
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

	broadcastEffectList {
		var msg = ~me.bankList.getPairs;
		"updating Peers' EffectLists".postln;
		this.sendAll("/updateEffectListOSC", *msg);
    }

}
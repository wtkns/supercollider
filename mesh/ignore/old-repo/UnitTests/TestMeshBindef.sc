TestMeshBindef : UnitTest {
	var meshBindef;
	var server;
	var cond;

	setUp {
		"Setting Up for Tests".postln;
		meshBindef=MeshBindef.new(\testBindef);
		cond = Condition.new;		
	}

	bootLocalServer {
		Server.default = Server.local;
		server = Server.default;
		server.reboot;
		server.doWhenBooted({
			cond.unhang
		});

	}
	
	makeTestSynthDef { |synthDefName=\test|

		synthDefName = synthDefName.asSymbol;
		
		SynthDef(synthDefName, {|
			freq,
			attack = 1,
			release = 5,
			t_gate = 1,
			sustain,
			amp = 0.1,
			lfoFreq = 1,
			midiVib = 0.5 |
   
			var envShape = Env.adsr(attack, 1, 0.75, release);
			var envGen = EnvGen.ar(envShape, t_gate);
			var vibRatio = midiVib.midiratio;
			var wave = PulseDPW.ar(
				freq * SinOsc.ar(lfoFreq).range(1/vibRatio, vibRatio),
				0.5,
				amp
			);
			
			Out.ar(0, wave * envGen ! 2);
		}).add;
		
	}

	tearDown {
		"Tearing down".postln;
		server.free;
		meshBindef.free;
	}

	test_meshBindef {
		"Running Tests:".postln;

		this.bootLocalServer;		
		cond.hang; // wait until server is booted
		
		this.makeTestSynthDef(\test2);
		this.synthDefExists(\test2);
		
		this.meshBindefIsMeshBindef(meshBindef);
		this.serverIsRunning(server);
			
		//		this.meshBindefIsMeshBindef("notBindef");		
		"Tests Completed!".postln;
	}

	synthDefExists {|synthDefName=\test|
		synthDefName=synthDefName.asSymbol;		
		SynthDescLib.global.at(synthDefName);
		"synthDef Exists".postln		
	}

	meshBindefIsMeshBindef{|bindefToTest|
		this.assert(bindefToTest.isKindOf(MeshBindef))
	}

	serverIsRunning{|serverToTest|
		this.assert(serverToTest.serverRunning)
	}

}

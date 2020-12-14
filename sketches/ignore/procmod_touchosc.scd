(
var sd, func, pevents, respFunc, kill, parseTouchOSC, touchOSC;

Server.default = s = Server.internal.boot;

touchOSC = nil;
parseTouchOSC = {arg msg, replyAddr;
	touchOSC.isNil.if({
		touchOSC = NetAddr(replyAddr.ip, 58100);
	});
	case
		{msg[0] == "/1/fader1".asSymbol}
		{	pevents.eventDict[\ev1].isRunning.if({
				pevents.eventDict[\ev1].amp_(msg[1]);
			})
		}
		{msg[0] == "/1/fader2".asSymbol}
		{	pevents.eventDict[\ev1].isRunning.if({
				pevents.eventDict[\ev2].amp_(msg[1]);
			})
		}
		{msg[0] == "/1/fader3".asSymbol}
		{	pevents.eventDict[\ev1].isRunning.if({
				pevents.eventDict[\ev3].amp_(msg[1]);
			})
		}
		{msg[0] == "/1/fader1/z".asSymbol}
		{
			(msg[1] == 0).if({
				touchOSC.sendMsg("/1/fader1/color", "red")
			}, {
				touchOSC.sendMsg("/1/fader1/color", "green")
			})
		}
		{msg[0] == "/1/fader2/z".asSymbol}
		{
			(msg[1] == 0).if({
				touchOSC.sendMsg("/1/fader2/color", "red")
			}, {
				touchOSC.sendMsg("/1/fader2/color", "green")
			})
		}
		{msg[0] == "/1/fader3/z".asSymbol}
		{
			(msg[1] == 0).if({
				touchOSC.sendMsg("/1/fader3/color", "red")
			}, {
				touchOSC.sendMsg("/1/fader3/color", "green")
			})
		}	
};

s.waitForBoot({
	
	// use the first part of the OSC address to check for touchOSC messages
	// and dispatch to a Function to parse
	respFunc = {arg time, replyAddr, msg;
		// filter out OSC from the server that has to do with status msgs
		(msg[0].asSymbol != "/status.reply".asSymbol).if({
			(msg[0].asString.contains("/1/")).if({
				parseTouchOSC.value(msg, replyAddr);
			});
		})  
	};
	
	// add it to the recvOSCfunc slot of Main. thisProcess is an instance
	// of Main that is, this instance of SuperCollider
	thisProcess.recvOSCfunc = thisProcess.recvOSCfunc.addFunc(respFunc);
	
	// when we are done, remove it!
	kill = {
		// remove from recvOSCfunc
		thisProcess.recvOSCfunc = thisProcess.recvOSCfunc.removeFunc(respFunc);
	};
	
	sd = CtkSynthDef(\singrain, {arg freq, amp, dur, outbus;
		Out.ar(outbus,Ê
			Pan2.ar(
				SinOsc.ar(freq, 0, amp) *Ê
					EnvGen.kr(Env.sine(dur, amp), doneAction: 2),
				-1.0.rrand(1.0)
			)
		) // read off the overall env control of the ProcMod
	});
	
	func = {arg id, amp, env, high, low, winsize, overlaps;
		var proc;
		proc = ProcModR.new(env, amp, 2, 0, id: id);
		proc.function_({arg group, routebus, server;
			Task({
				loop({
					// start a new synth... run it inside this ProcMod's group,
					// and read control values off the envbus
					sd.note(target: group).freq_(high.rrand(low)).amp_(1)
						.dur_(winsize).outbus_(routebus).play;
					(winsize / overlaps).wait;
					})
				});
			});
		};
	
	pevents = ProcEvents.new([
	/* 0 */		[   // assign a global variable so we can play with it a little!
					func.value(\ev1, 0.1, Env([0, 1, 0], [2, 10], \sin, 1), 
						high: 440, /* keyword arg passing */
						low: 880, 
						winsize: 0.3, 
						overlaps: 8),
					nil
				], 
	/* 1 */		[
					func.value(\ev2, 0.1, Env([0, 1, 0], [1, 10], \sin, 1), 
						high: 2200, 
						low: 4400, 
						winsize: 0.2, 
						overlaps: 8),
					nil
				],
	/* 2 */		[   
					func.value(\ev3, 0.1, 
						Env([0, 1, 0.5, 2, 0], [1, 1, 1, 1], \sin, 1), 
						low: 100, 
						high: 10000, 
						winsize: 1, 
						overlaps: 4),
					[\ev1, \ev2]
				],
	/* 3 */		[nil, \ev3]
				], 0.dbamp, killmod: kill, id: "test");
				
	// show the ProcModR GUIs
	pevents.showPMGUIs = true; 
	// show the performance GUI
	pevents.perfGUI;
})
)
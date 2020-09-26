/* simple ProcModR / ProcEvents example */

(
var sd, func, pevents;

Server.default = s = Server.internal.boot;

s.waitForBoot({
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
	/* 0 */		[   // create \ev1, release nothing
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
	/* 2 */		[   // release ev1 and ev2
					func.value(\ev3, 0.1, 
						Env([0, 1, 0.5, 2, 0], [1, 1, 1, 1], \sin, 1), 
						low: 100, 
						high: 10000, 
						winsize: 1, 
						overlaps: 4),
					[\ev1, \ev2]
				],
	/* 3 */		[nil, \ev3]
				], 0.dbamp, id: "test");
				
	// record to disk
	pevents.record("~/Desktop/test".standardizePath, true, 'aiff', 'float');
	// show the ProcModR GUIs
	pevents.showPMGUIs = true; 
	// show the performance GUI
	pevents.perfGUI;
})
	
)



/* simple ProcModR / ProcEvents example */

(
var sd, func, pevents;

Server.default = s = Server.internal.boot;

s.waitForBoot({
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
					~myVar = func.value(\ev1, 0.1, Env([0, 1, 0], [2, 10], \sin, 1), 
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
				], 0.dbamp, id: "test");
				
	// show the ProcModR GUIs
	pevents.showPMGUIs = true; 
	// show the performance GUI
	pevents.perfGUI;
})
	
)

/*
Functions and FunctionLists
*/

a = {"I am a Function".postln};
a.value;

b = {"I am another Function".postln};
b.value;

a = a.addFunc(b);

a.value;

a = a.removeFunc(b);

a.value;

/*
responding to OSC messages from TouchOSC
*/

/* First - we need to know our computer's IP to send to... this can be tricky, but this will help */

(
	~before = NetAddr.broadcastFlag;
	NetAddr.broadcastFlag = true;
	OSCresponder(nil, '/getMyIP', { arg t,r,msg,addr;
		NetAddr.broadcastFlag = ~before;
		("Set the IP in TouchOSC to: " ++ addr.ip ++ " and port: "++NetAddr.langPort).postln;
		r.remove;
	}).add;

	NetAddr("255.255.255.255", NetAddr.langPort).sendMsg('/getMyIP');
)		

(
var sd, func, pevents, respFunc, kill;

Server.default = s = Server.internal.boot;

s.waitForBoot({
	
	// post all incoming OSC messages, and look for TouchOSC messages
	respFunc = {arg time, replyAddr, msg;
		// filter out OSC from the server that has to do with status msgs
		if(msg[0].asSymbol != "/status.reply".asSymbol) {
			"At time %s received message % from %\n".postf( time, msg, replyAddr );
			case
				{msg[0] == "/1/fader1".asSymbol}
				{("Fader 1" + (msg[1])).postln;}
				{msg[0] == "/1/fader2".asSymbol}
				{("Fader 2" + (msg[1])).postln;}
				{msg[0] == "/1/fader3".asSymbol}
				{("Fader 3" + (msg[1])).postln;}
		}  
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

/* OscGroups */
// path to the OscGroupClient executable
OscGroupClient.program_("/Users/joshp/bin/OscGroupClient");

// change name and name password
a = OscGroupClient("realizedsound.mooo.com", "josh", "joshword", "test", "testword")

// join the Server
a.join;
Ê
// add a responder for OTHER people on the server to send messages to you
a.addResp(\test, {arg time, resp, msg;
	msg.postln;
	{SinOsc.ar(440.0.rrand(1760.0), 0, EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], \sin), doneAction: 2))}.play;
	});
	
// and remove your responder. This is an IdentityDictionary in the class, so you can have as 
// many responders with unique ids that you want
a.removeResp(\test);


// this sends a message to everyone else. You don't see anything though on your end
a.sendMsg(\test)

// you can send more then just the trigger id, just comma separate the stuff you are sending!):
a.sendMsg(\test,Ê"How much can I send?",Ê1232,Ê\etc);

// close your connection to the server, and clean up.Ê
a.close;

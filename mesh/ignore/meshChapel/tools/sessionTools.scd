//////////////////
// Session Toolkit
//
// these are code shortcuts and notes for tools, troubleshooting and
// other common code NOT unique to this session.
//////////////////

//////////////////
// Synths:
// must run sessionFunctions FIRST
"sessionFunctions.scd".loadRelative;

~reloadAllSynths.value;

// browse "add"ed synthdefs
SynthDescLib.global.browse;

// view a single one
SynthDescLib.at(\trigTest2)


x.free; y.free; z.free;

//////////////////
// Utopia:

//////////////////
// Server:

// Is the server running?
s.serverRunning


//dump all nodes to post window
s.queryAllNodes;

// show all nodes in gui window
s.plotTree

// kill a stuck node
s.sendMsg("/n_free", 201326593 );

// start a synth node
x=Synth.new(\trigTest, [freq: 800, dur: 0.75], s, \addToHead)

x.set(\t_trig, 1);
// or manually
// set a node:
s.sendMsg("/n_set", 201327595, \out, [2,3]);
x.free
//or, eg.
g=1122.asTarget;
g.free

s.queryAllNodes;

~nodeP = 1007;
~nodeQ = 1006;

// or like
g=1000.asTarget;
h=1000.asTarget;



//////////////////
// Network Stuff:

// IP address:
"ifconfig |grep inet".systemCmd;

// Port Number
NetAddr.langPort.postln;

// check maxLogins:
Server.local.options.maxLogins.postln;

//////////////////
// scsynth on server ONLY:
//////////////////

cd /Applications/SuperCollider.app/Contents/Resources/
./scsynth -u 57110

//to end:
Ctrl+d to stop, ctrl+c to exit

killall scsynth

s.clientID

s.queryAllNodes


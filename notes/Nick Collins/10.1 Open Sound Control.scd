
-----------------
Open Sound Control (OSC)

Server.default=s=Server.internal;

OSC is a communication protocol used for sending information across a computer network. It is promoted as the successor to MIDI (with greatly increased bandwidth and user-customisable representations), and is supported by most modern music software.


It is the lifeblood of SuperCollider since all communication from the language application to the localhost server uses OSC! You may also send messages to any other SuperCollider Servers for which you have an IP location. So SuperCollider is immediately equiped for network music. 


You can also use it to communicate with other applications like Max/MSP or PD.


















For OSC, you create your own OSC Address Space, a tree of methods that get called when their corresponding string is invoked. In practice, this means you can choose how to tag the messages you pass. 
 
(see http://www.cnmat.berkeley.edu/OpenSoundControl/OSC-spec.html for more)
 
You might use 

"/myparameters/object3/frequency" 
 
 Or any other string, where the forward slashes / split up the tree to be traversed.
 
OSC messages themselves are denoted by an address string, a typetag string that says whether the information passed is a float, two integers etc and actual values for each type in the type string:

address, typetags, values 

The message is passed to the appropriate method as soon as it arrives. 

A 'bundle' can also be sent, which is a set of OSC commands that are to be called simultaneously- an absolute time tag is also enclosed, to control exactly when the commands are carried out. 
















To send general OSC to a known IP use the NetAddr class:

[NetAddr]

//demo to send to the localhost Server
(
var n, id;

//loopback address is 127.0.0.1- try substituting the IP address of another user's machine
n=NetAddr("127.0.0.1", 57110); //57110 is the port number; this is the standard number used by the Server

id=s.nextNodeID;
n.sendMsg("s_new",\default,id,0,0); //sendMsg works out the correct OSC message for you

SystemClock.sched(1.0,{n.sendMsg("n_free",id); });
)























To send standard messages to control a SuperCollider server, the Server class is a better interface. Underneath, it uses NetAddr as above. 
[Server]



You can also use Julian Rorhuber's BroadcastServer class to send messages to a list of NetAddrs (usually other SuperCollider Servers on other machines)
[BroadcastServer] 
























To receive and react to OSC messages in SCLang you will use the OSCresponder class 
[OSCresponder]

(
// register to receive a trigger message
OSCresponder(s.addr,'/tr',{ arg time,responder,msg;

"received trigger!".postln;
Post << msg <<nl;

}).add; 

//send a trigger message whenever the impulse fires (once every 2 seconds)
{SendTrig.ar(Impulse.ar(0.5))}.play;
) 


//keep it running and now run these lines:
(
OSCresponder(s.addr,'/tr',{ arg time,responder,msg;

"new reaction!".postln;
Post << time <<nl;

}).add; 
) 


//remove the responder
OSCresponder.all.do({arg val; if(val.cmdName=='/tr',{OSCresponder.remove(val)}); })



OSCresponderNode can be used if you need more than one responder for a particular message. 
[OSCresponderNode]


(
// register to receive a trigger message
OSCresponderNode(s.addr,'/tr',{ arg time,responder,msg;

"received trigger!".postln;
Post << msg <<nl;

}).add; 

OSCresponderNode(s.addr,'/tr',{ arg time,responder,msg;

"different reaction!".postln;
Post << time <<nl;

}).add; 


//send a trigger message whenever the impulse fires (once every 2 seconds)
{SendTrig.ar(Impulse.ar(0.5))}.play;
) 

//clear all OSCresponderNodes for the trigger message
OSCresponder.all.do({arg val; if(val.cmdName=='/tr',{OSCresponder.remove(val)}); })

This would have been easier if we'd set each created OSCresponderNode into a variable x say, then we could go:

x=OSCresponderNode(s.addr,'/tr',{ arg time,responder,msg; "bang!".postln;}).add

then

x.remove; 











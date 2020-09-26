// On the designated SERVER, run the following, before the other computers join:
// 1. set options and boot the server

Server.default = Server.local;
o = Server.local.options;
o.device = "MOTU 828mk2";
o.numOutputBusChannels = 8;
o.outputStreamsEnabled = "11111111";
o.maxLogins = 16;
o.maxNodes = 1024;
o.maxSynthDefs = 1024;
//o.device = nil;  // use the system default soundcard

s.boot;

// 2. join Utopia, setup chat, SynthDescRelay and CodeRelay
"setup_utopia.scd".loadRelative;

// 3. get the ip and port information for THIS machine
// look for something like inet 10.0.1.x
// NOT  127.0.0.1

// print the IP address to the post window
// use this in client_session as ~remoteIP:
"Server I.P. Address: " ++ "ifconfig | grep \"inet \" | grep -v 127.0.0.1 | cut -d\" \" -f2".unixCmdGetStdOut;

//If the above doesn't work, use this to find the address:
"ifconfig | grep inet ".systemCmd;

// Port Number
NetAddr.langPort.postln;

// maxLogins:
Server.local.options.maxLogins.postln;

//4. use the above information to run client_session on all clients.

// 4. load any SynthDefs or other one time code
// saved in separate files

// 5. when you are finished, at the end of the session:
//    cleanup everything

"cleanup.scd".loadRelative;

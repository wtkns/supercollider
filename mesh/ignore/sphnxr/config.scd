Server.default = s = Server.local;
// thisThread.randSeed_(120);
// set server options here
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.latency = 0.05;

//jack setup
//s.options.device="JackRouter";
//s.options.outDevice = "JackRouter";
//s.options.inDevice = "JackRouter";

//fireface setup
/s.options.device = "Fireface 800 (3EC)";
//s.options.outDevice = "Fireface 800 (3EC)";
//s.options.inDevice = "Fireface 800 (3EC)";
//s.options.numOutputBusChannels = 10;
//s.options.outputStreamsEnabled = "1111111111";


~win = Window("network").minimize; //front; // network window status, eg: .minimize (to hide) or .front (to show)

~hostname = ("hostname".unixCmdGetStdOut.split($.)[0]).asSymbol;
("hostname: " +/+ ~hostname).postln;
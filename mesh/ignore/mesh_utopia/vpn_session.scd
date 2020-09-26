
// [OPTIONAL]
// If setting up a remote session using the mesher streisand VPN, set ~streisand variable
~streisand = NMLNetAddrMP("192.168.0.255", 57120 + (0..7));
// [OPTIONAL]
// To enable all code executed by all Peers to be executed on all machines
~enableRemoteCodeExecution = true;

// join Utopia, setup chat, SynthDescRelay and CodeRelay
"setup_utopia.scd".loadRelative;

// load any SynthDefs or other one time code
// saved in separate files


// cleanup everything
"cleanup.scd".loadRelative;

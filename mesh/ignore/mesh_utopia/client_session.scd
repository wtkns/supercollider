// 1. On the server, run server_session.

// 2. enter the following information FROM step 3 of server_session:
~remoteIP = "10.0.1.x";
// remote server port
~remotePort = 57110;
~maxLogins = 16;

// 4. choose a remote server name
~server = \mesher;

// 5. Connect to the remote server
~netAddr = NetAddr(~remoteIP, ~remotePort);
~serverOptions = ServerOptions.new;
~serverOptions.maxLogins_(~maxLogins);
Server.default = Server.remote(~server, ~netAddr, ~serverOptions);


// 6. join Utopia, setup chat, SynthDescRelay and CodeRelay
"setup_utopia.scd".loadRelative;

//7. load any SynthDefs or other one time code
// saved in separate files

// 8. when you are finished, at the end of the session:
//    cleanup everything
"cleanup.scd".loadRelative;

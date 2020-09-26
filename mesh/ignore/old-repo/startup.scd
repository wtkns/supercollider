
// // uncomment the following for basic mesh
// ~mesh_utopiaPath="/Users/james/git/jhuston/mesh_utopia/server_session.scd";
// ~synthDefLibraryPath="/Users/james/git/adadu/2018feb3_mesh/synths/";
// ~serverName = \mesher;
// ~remotePort = 57110;
// ~remoteIP = "192.168.0.19";
// ~maxLogins = 8;
// ~serverOptions = ServerOptions.new;
// ~serverOptions.maxLogins = ~maxLogins;
// ~mesh_utopiaPath.load;
// ~netAddr = NetAddr(~remoteIP, ~remotePort);//
// Server.default = Server.remote(~serverName, ~netAddr, ~serverOptions);




// // STOP!




// // CLIENT SESSION
// //
// // 1. On the server, run server_session.
// //
// // 2. enter the following information FROM step 3 of server_session:
// //
//

//s.doWhenBooted({
//7. loads any SynthDefs or other one time code from synthDefLibraryPath
// 	PathName.new(~synthDefLibraryPath).filesDo{
// 		|afile| afile.absolutePath.load;
// 	afile.postln};
//
//
// });
// // s.queryAllNodes;
//
// //
// //
// //
// // // STANDALONE SESSION
// // //
// // // // 2. enter the following information FROM step 3 of server_session:
// // ~synthDefLibraryPath="/Users/james/git/adadu/2018feb3_mesh/synths/";
// //
// // Server.default = Server.local;
// //
// // s.boot;
// //
// // s.doWhenBooted({
// // 	"SERVER BOOTED :".postln;
// // 	PathName.new(~synthDefLibraryPath).filesDo{
// // 		|afile| afile.absolutePath.load;
// // 		afile.postln;
// // 	};
// // 	"\n\nSYNTHDEFS LOADED".postln;
// // });
// //

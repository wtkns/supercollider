(
n = NetAddr("10.0.10.100", 57110);

o = ServerOptions.new;
o.maxLogins_(16);

Server.default = s = Server.remote(\mesher, n, o);
)


s.status

s.queryAllNodes(queryControls: true)
s.boot;
s.queryAllNodes; // note the root node (ID 0) and the default group (ID 1)
s.quit;



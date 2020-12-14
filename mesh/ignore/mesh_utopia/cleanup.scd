// remove coderelay and free its resources.
~codeRelay.free;
History.end;

// cleanup chat
~chatter.free; ~peers.close;
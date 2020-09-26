// session functions
//
// these are functions for tools, troubleshooting and
// other common code NOT unique to this session.

//////////////////

~reloadAllSynths={
	PathName.new(~synthDefLibraryPath).filesDo{
	|afile| afile.absolutePath.load;
	afile.postln;
	}
};

~cleanupUtopia={
	~codeRelay.free;
	History.end;
	~chatter.free;
	~peers.close;
	~addrBook.free;
};

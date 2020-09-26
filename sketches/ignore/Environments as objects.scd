(
// the environment/pseudo-class:
~myEnvir = ();

	// the equivalent of a class var
	~myEnvir.mulB = 10;
	
	
	// the equivalent of a class method; 
	// ATTN: the first arg these environment funcs return is themselves.
	~myEnvir.funcOne = {|self, mulA = 1|
		var result;
		//self.postln;
		result = mulA * ~myEnvir.mulB;
		result.postln;
	};

)

// call it: notice how it's called like a class method, rather than like a function! 
~myEnvir.funcOne(99)
~myEnvir.funcOne(10)

// change the 'pseudo- class var'
~myEnvir.mulB = pi
~myEnvir.funcOne(10)
~myEnvir.mulB = 10
~myEnvir.funcOne(10)

// see more on the help file
Environment
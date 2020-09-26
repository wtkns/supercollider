Strategy{

	*wave{arg position, velocity;
		var newPos;
		newPos = position+velocity; 
		// particles move one way
		^newPos;
	}
	
	*fall{arg position, velocity;
		var newPos;
		newPos = position-velocity; 
		// particles move one way
		^newPos;
	}	

}		
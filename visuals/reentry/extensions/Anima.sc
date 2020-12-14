Anima{
	var <>position, <>velocity, <age, <>size, <>color, <>strategy;

	*new{ 
		arg xPos = 0, yPos = 0, xVel = 0, yVel = 0, sizX = 5, sizY = 5, col=Color.red, strat;
		^super.new.init(xPos, yPos, xVel, yVel, sizX, sizY, col, strat);
	}

	init{ arg xPos, yPos, xVel, yVel, sizX, sizY, col, strat;
		color = col;
		position = Point.new(xPos, yPos);
		velocity = Point.new(xVel, yVel);
		size = Point.new(sizX, sizY);
		age = 0;
		strategy = strat
	}

	move{
		age = age+1;
		position.post; // print before
		position=strategy(position, velocity);
		position.post; // print after
	}	

}
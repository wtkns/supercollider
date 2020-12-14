Khora{
	var <xDomain, <yDomain;

	*new{ arg xDom = 500, yDom = 500;
		^super.new.init(xDom, yDom;);
	}

	init{ arg xDom, yDom;
		~xDomain = xDom;
		~yDomain = yDom;

		~window = Window("window", Rect(100, 50, ~xDomain, ~yDomain ), false);
		~userview = UserView(~window, Rect(0, 0, ~xDomain, ~yDomain));
		~userview.clearOnRefresh= true;
		~userview.background= Color.black;
		~window.onClose= {};
		~window.front;

		~userview.drawFunc= {
			for (0, ~animae.size-1,{arg i;
				Pen.fillColor = ~animae[i].color;
				Pen.fillRect(Rect(~animae[i].position.x, ~animae[i].position.y, ~animae[i].size.x, ~animae[i].size.y));			});
		};

	}

	dump{
		"this Khora".postln;
		"	xDomain:   ".post;
		~xDomain.postln;
		"	yDomain = ".post;
		~yDomain.postln;
	}
}


Anima{
	var <>position, <>velocity, <age, <>soundParameters, <>strategy, <>rhythm, <>color, <>size, <>type;

	*new{
		arg xPos = (~xDomain/2), yPos = (~yDomain/2), xVel = 0, yVel = 0, sndParam = Click, strtgy = Drift, rhyth = 50.rand, col = Color.yellow.alpha_(0.5), sizX = 5, sizY = 5;
		^super.new.init(xPos, yPos, xVel, yVel, sndParam, strtgy, rhyth, col, sizX, sizY);
	}

	init{ arg xPos, yPos, xVel, yVel, sndParam, strtgy, rhyth, col, sizX, sizY;
		position = Point.new(xPos, yPos);
		velocity = Point.new(xVel, yVel);
		soundParameters = sndParam;
		strategy = strtgy;
		rhythm = rhyth;
		color = col;
		size = Point.new(sizX, sizY);
		age = 0;
	}

	dump{
		"".postln;
		"	age:   ".post;
		age.postln;
		"	xcoordinate:   ".post;
		position.x.postln;
		"	yCoordinate = ".post;
		position.y.postln;
		"	xVelocity = ".post;
		velocity.x.postln;
		"	yVelocity = ".post;
		 velocity.y.postln;
		"	SoundParameters:   ".post;			soundParameters.postln;
		"	Strategy:   ".post;
		strategy.postln;
	}
	move{
		age = age + 1;
		strategy.move(this);
//		position.postln;

	}
}

Wave{
	*move{
		arg this_anima, next_position;
		next_position = this_anima.position + this_anima.velocity;		if ( (next_position.x < 0).or(next_position.x > ~width),
			{this_anima.velocity.x = this_anima.velocity.x * (-1);
			});

		if ( (next_position.y < 0).or(next_position.y > ~height),
			{this_anima.velocity.y = this_anima.velocity.y * (-1);
			});

		this_anima.position = this_anima.position + this_anima.velocity;


 	}
}

Drone{
	*playSound{arg this_anima;

		var noteObject, note;

		noteObject = CtkSynthDef(				\simplefm3, {arg dur = 0.125, amp = -32, carfreq = this_anima.position.y,
			cmratio = 0.25, index = 1;

			var env, mod, car, modfreq, deviation, pan;
			env = EnvGen.kr(
				Env([0.01, 1, 1, 0.01], [0.1, dur-0.2, 0.1], \exp));
			pan = 	this_anima.position.x;
			pan = (((pan / ~xDomain) * 2 ) - 1);
			modfreq = carfreq * cmratio;
			deviation = index * modfreq;
			mod = SinOsc.ar(modfreq, 0, deviation);
			car = SinOsc.ar(carfreq + mod, 0, amp.dbamp);
			Out.ar(0, Pan2.ar(car * env, pan));
		});

		note = noteObject.note(0.1, 0.25).dur_(0.25).carfreq_(( (~yDomain - this_anima.position.y)+100))
			.cmratio_(0.25).index_(4).play;
	}
}
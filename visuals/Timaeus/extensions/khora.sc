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
		~userview.background= Color.grey;
		~window.onClose= {};
		~window.front;
		
		~userview.drawFunc= {
			for (0, ~animae.size-1,{arg i; 
				Pen.fillColor = Color.white.alpha_(0.2);
				Pen.fillOval(Rect(~animae[i].position.x, ~animae[i].position.y, 20, 20));
				Pen.strokeColor = Color.black;
				Pen.strokeOval(Rect(~animae[i].position.x, ~animae[i].position.y, 25, 25));
				
			});
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
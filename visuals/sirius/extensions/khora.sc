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
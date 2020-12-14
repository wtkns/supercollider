Khora{
	var <size, <>animae, window, <>userview ;

	*new{ arg xSize = 500, ySize = 500, cnt = 20;
		^super.new.init(xSize, ySize, cnt);
	}

	init{ arg xSize, ySize, cnt;
		size = Point.new(xSize, ySize);
		animae = List.new(cnt);
		window = Window("window", Rect(100, 50, size.x, size.y ), false);
		userview = UserView(window, Rect(0, 0, size.x, size.y));
		userview.clearOnRefresh= true;
		userview.background= Color.black;
		window.onClose= {};
		window.front;
		
		userview.drawFunc= {
			for (0, animae.size-1,{arg i; 
				Pen.fillColor = animae[i].color;
				Pen.fillRect(Rect(animae[i].position.x, animae[i].position.y, animae[i].size.x, animae[i].size.y));			});
		};
	}
	
	dump{
		"this Khora".postln;
		"	xDomain:   ".post;		
		size.x.postln;
		"	yDomain = ".post;
		size.y.postln;
	}
}
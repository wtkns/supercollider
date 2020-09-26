Khora{
	var <>animae, <>bounds, <>bgColor, <>doClear, <>window, <>userview;
	classvar <>styles;
	
	*new{ arg cnt, bnds, bgCol, doClr ;
		^super.new.init(cnt, bnds, bgCol, doClr);
	}

	init{arg cnt, bnds, bgCol, doClr;
		animae = List.new(cnt);
		bounds = bnds;
		bgColor = bgCol;
		doClear = doClr;
		
		window = Window.new(\window, Rect(100, 50, bounds.x, bounds.y ), border:false);
		window.fullScreen;
		window.view.background_(Color.black);
		userview = UserView(window, Rect(350, 100, bounds.x, bounds.y+100));
		userview.clearOnRefresh= doClear;
		userview.background= bgColor;
		window.onClose= {};
		window.front;
		
		styles = Dictionary.new;
		styles.add(
			\rectangle -> {|part|
							 Pen.fillRect(Rect(part.position.x, part.position.y, part.size.x, part.size.y));
							}
		);
		styles.add(
			\circle -> {|part|
							 Pen.fillOval(Rect(part.position.x, part.position.y, part.size.x, part.size.y));
							}
		);		
		userview.drawFunc= {
			for (0, animae.size-1,{|part| 
				Pen.fillColor = (animae[part].color).multiply(animae[part].visible);
				styles[animae[part].style].value(animae[part]);
			});
		};

	}
	
}
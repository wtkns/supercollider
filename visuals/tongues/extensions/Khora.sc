Khora{
	var <>animae, <>bounds, <>bgColor, <>doClear, <>window, <>userview, <>fullScreen;
	classvar <>styles;
	
	*new{ arg cnt, bnds, bgCol, doClr, fllScrn;
		^super.new.init(cnt, bnds, bgCol, doClr, fllScrn);
	}

	init{arg cnt, bnds, bgCol, doClr, fllScrn;
		animae = List.new(cnt);
		bounds = bnds;
		bgColor = bgCol;
		doClear = doClr;
		fullScreen = fllScrn;
		
		window = Window.new(\window, Rect(100, 50, bounds.x, bounds.y ), border:fullScreen.not);
		if (fullScreen, {var screenBounds, offset;
			screenBounds = Window.screenBounds;
			offset = Point.new(((screenBounds.width/2)-(bounds.x/2)),((screenBounds.height/2)-(bounds.y/2))); 
			window.fullScreen;
			window.view.background_(Color.black);			userview = UserView(window, Rect(offset.x, offset.y, bounds.x, bounds.y));		},{
			userview = UserView(window, Rect(0, 0, bounds.x, bounds.y));
		});

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
		styles.add(
			\box -> {|part|
							 Pen.fillRect(Rect(part.position.x, part.position.y, part.size.x, part.size.y));
							 Pen.strokeColor = Color.white;
							 Pen.strokeRect(Rect(part.position.x, part.position.y, part.size.x, part.size.y));
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
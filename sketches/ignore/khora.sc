Khora{
	var <xDomain, <yDomain, <zDomain, <>animae;

	*new{ arg xDomain = 500, yDomain = 500, zDomain = 500, animaeNum = 3;
		^super.new.init(xDomain, yDomain, zDomain, animaeNum;);
	}

	init{ arg xDom, yDom, zDom, animaeNum;
		xDomain = xDom;
		yDomain = yDom;
		zDomain = zDom;
		animae = Array.new(animaeNum);
	}
	
	dump{
		"this Khora".postln;
		"	xDomain:   ".post;		
		xDomain.postln;
		"	yDomain = ".post;
		yDomain.postln;
		"	zDomain = ".post;
		zDomain.postln;
		" Number of Animae: ".post;
		animae.size.postln;
	}		

}
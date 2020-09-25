(

var createPartitionTable = { |duration, partitionCount|
	var partitionTable = Array.fill(partitionCount,
		{ var thisDuration = linrand(duration);
			duration = duration - thisDuration;
			thisDuration});
	partitionTable.scramble};


var durationsToPixels = {|partitionTable, plotWidth|
	var length = partitionTable.sum;
	partitionTable.collect({arg duration; (plotWidth * duration)/length})};

var initPartitionWindow = { |partitionTable, plotWidth|
	var pixelTable = durationsToPixels.value(partitionTable, plotWidth);
	drawPartitionWindow.value(partitionTable, pixelTable, plotWidth)};

var drawPartitionWindow = { |partitionTable, pixelTable, plotWidth|
	var plotHeight = plotWidth/4;
	var plotVCenter = plotHeight/2;
	var length = partitionTable.sum;
	var thisWindow = Window.new("durations",Rect.new(100,100,plotWidth,plotHeight)).front;

	thisWindow.view.background_(Color.white);

	thisWindow.drawFunc = {
		var cumulativePixels = 0;
		StaticText(thisWindow, Rect(0,plotVCenter,100,100)).string_("0s").align(\topLeft);
		StaticText(thisWindow, Rect(plotWidth-50,plotVCenter,100,100)).string_(length+ "s");

		Pen.strokeColor = Color.red;
		Pen.moveTo(0@plotVCenter);
		Pen.lineTo(plotWidth@plotVCenter);
		Pen.stroke;

		pixelTable.do({|thisPart, partNumber|
			Pen.line(Point.new(x: cumulativePixels, y: plotVCenter+10), Point.new(x: cumulativePixels, y: plotVCenter-10));
			Pen.stroke;
			Pen.fillOval(Rect.new(cumulativePixels-5, plotVCenter-5, 10,10));
			StaticText(thisWindow, Rect(cumulativePixels, partNumber*15, 300, 100)).string_(partitionTable[partNumber]);
			cumulativePixels = cumulativePixels + thisPart;
		});
	};
};



var length = 1000.0;
var parts = 20;
var partitionTable = createPartitionTable.value(length, parts);
var window = initPartitionWindow.value(partitionTable, 2000);

)




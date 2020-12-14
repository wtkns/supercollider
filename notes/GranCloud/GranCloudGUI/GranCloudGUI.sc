
GranCloudGUI {

	classvar <>infinity = 99999; // since GUI objects can't deal with infinity, substitute this val

	var 	<>name, 		// a name for the cloud
		<>cloud, 		// the cloud object
		<gui;
		
	*new { arg name, cloud;
		^super.newCopyArgs(name, cloud).init
	}
	
	*display { arg server, out=0, groupID=1, name, cloud;
		^super.newCopyArgs(name, cloud).init.display(server, out, groupID)
	}
	
	init {
		name    = name    ? "New Cloud";
		cloud   = cloud   ? GranCloud.new;
		cloud.updateStatus;
		cloud.defaultSpecs;
		cloud.nextGrainArgs;
	}
	
	display { arg server, out, groupID;
		
		var color, buildCompositeView, buildLabel, buildButton, buildPopUp;
		var buildNumberBox, buildTextField, buildSlider, buildMainAttrRow;
		var buildMainWindow, getDur, timesToEnv, envToTimes, buildTextView; 
		var window, objHeight, headerFormats, sampleFormats, updateDisplay, buildAttrTextView;
		var updateAttrRowDisplay, openAttrWindow, syncAttrWindow, buildAttrGUI, updateTime;
		var buildAttrDisplayGrid, buildVerticalAttrDisplayGrid, buildEnvEnvView;
		var buildAttrSliderView, buildAttrEnvView, reopenAttrWindow, rebuildAttrGUI;
		var viewLabels, currentViewIndex, recordBuf, recordSynth, recordIsPrepared, isRecording;
		var sync, syncCloud, syncObj, recordPath, buildViews, buildAttrCompileView;
		var viewMap, left, bottom, currentRowStart = 0, maxRows = 4;
				
		// the default object height
		objHeight = 18;
		left = 20;
		bottom = SCWindow.screenBounds.height - 600 - 65;
		currentViewIndex = 0;
		server = server ? Server.default;
		if(server.serverRunning.not && server.serverBooting.not, {
			server.boot;
		});
		
		server.doWhenBooted({
			SynthDef("GranCloud-Record", { arg bufnum;
				DiskOut.ar(bufnum, In.ar(out, cloud.numChannels));
			}).send(server);
		});
		isRecording = false;
		
		// initialize some colors
		color = IdentityDictionary.new;
		color[\blue]		= Color.new255(  45, 100, 180 );
		color[\blue2]		= Color.new255(  21,  49, 109 );
		color[\red]		= Color.new255( 224,  56,  48 );
		color[\red2]		= Color.new255( 192,  56,  48 );
		color[\lightred]	= Color.new255( 249, 182, 172 );
		color[\yellow]	= Color.new255( 242, 158,  40 );
		color[\yellow2]	= Color.new255( 192,  56,  48 );
		color[\green]		= Color.new255(  60, 150,  60 );
		color[\green2]	= Color.new255(  44,  94,  41 );
		color[\black]		= Color.new255(   0,   0,   0 );
		color[\grey]		= Color.new255( 140, 140, 140 );
		color[\white]		= Color.new255( 236, 236, 236 );
		color[\purple]	= Color.new255( 155, 125, 205 );
		color[\purple2]	= Color.new255(  75,  55, 205 );
		color[\blueGrad]    = Gradient( color[\blue2],   color[\blue],    \h, 128 );
		color[\purpleGrad]  = Gradient( color[\purple2], color[\purple],  \h, 128 );
		color[\purpleGrad2] = Gradient( color[\purple],  color[\purple2], \h, 128 );
		color[\greenGrad]   = Gradient( color[\green2],  color[\green],   \h, 128 );
		
		gui = MultiLevelIdentityDictionary.new;
		
		///// GENERIC GUI BUILDING FUNCTIONS /////	
		buildLabel = { arg view, width, string, stringColor, align;
			SCStaticText(view, Rect(0, 0, width, objHeight))
				.string_(string)
				.stringColor_(stringColor ? color[\black])
				.align_(align ? \left)
		};
		
		buildButton = { arg view, width, states, value, action;
			SCButton(view, Rect(0, 0, width, objHeight))
				.states_(states)
				.value_(value)
				.action_(action)		
		};
		
		buildPopUp = { arg view, width, items, value, action, backgroundColor;
			SCPopUpMenu(view, Rect(0, 0, width, objHeight))
				.items_(items)
				.background_(backgroundColor ? color[\white])
				.value_(value)
				.action_(action)
		};
		
		buildNumberBox = { arg view, width, value, action;
			SCNumberBox(view, Rect(0, 0, width, objHeight))
				.value_(value ? "")
				.action_(action)
		};
		
		buildTextField = { arg view, width, value, action;
			SCTextField(view, Rect(0, 0, width, objHeight))
				.string_(value ? "")
				.action_(action)
		};

		buildTextView = { arg view, width, height, value, action;
			SCTextView(view, Rect(0, 0, width, height))
				.string_(value ? "")
				.action_(action)
				.hasVerticalScroller_(true)
				.autohidesScrollers_(true)
				//.font_(Font("Monoco", 12))
				//.enterInterpretsSelection_(false)
		};
		
		buildSlider = { arg view, width, height, value, action;
			SCSlider(view, Rect(0, 0, width, height ? objHeight))
				.value_(value ? 0)
				.action_(action)
		};
		
		buildCompositeView = { arg view, backgroundColor, thisIndex, viewIndex, width, height;
			var new;
			new = SCCompositeView(view, Rect(0, 0, width, height));
			new.decorator_( FlowLayout(new.bounds, Point(3, 3), Point(3, 3)));
			new.background_(backgroundColor);
			new.visible_(if(viewIndex == thisIndex, { true }, { false }));
		};
				
		///// BUILD THE MAIN WINDOW ///// 
		
		buildMainWindow = { 
			
			// a container for all windows and gui objects				
			// create the window	
			window = SCWindow("GranCloud:" ++ name, Rect(left, bottom, 800, 600));
			window.view.background = color[\blueGrad];
			window.view.decorator  = FlowLayout(Rect(0, 0, 800, 600), Point(3, 3), Point(3, 3));
			window.onClose = { 
				if(gui[\windows, \attr].notNil, {
					gui[\windows, \attr].keysValuesDo({ arg key;
						if(gui[\windows, \attr, key, \window].notNil, {
							gui[\windows, \attr, key, \window].close
						})
					})
				})
			};
			gui[\window] = window;
			
			// add the window buttons
			gui[\closeButton] = buildButton.value(window.view, 40, 
				[ [ "Close", color[\black], color[\red] ] ],
				0,
				{ 	gui[\window].close; 
					if(gui[\windows, \attr].notNil, {
						gui[\windows, \attr].keysValuesDo({ arg key;
							if(gui[\windows, \attr, key, \window].notNil, {
								gui[\windows, \attr, key, \window].close
							})
						});
					})
				}
			);
			
			window.view.decorator.shift(20);
	
			//gui[\loadButton] = buildButton.value(window.view, 40,
//				[ [ "Load", color[\black], color[\yellow] ] ],
//				0,
//				{ 	var new;
//					CocoaDialog.getPaths({ arg paths;
//						syncObj = Object.readArchive(paths[0]);
//						sync.value(syncObj);
//						("GranCloudGUI Loaded: " ++ paths[0]).inform
//					}); 
//				}
//			);
//			
//			gui[\saveButton] = buildButton.value(window.view, 40,
//				[ [ "Save", color[\black], color[\yellow] ] ],
//				0,
//				{ 	CocoaDialog.savePanel({ arg path;
//						this.writeArchive(path);
//						("GranCloudGUI Saved: " ++ path).inform
//					});
//				}
//			);
					
	
			gui[\loadCloudButton] = buildButton.value(window.view, 80,
				[ [ "Load Cloud", color[\black], color[\yellow] ] ],
				0,
				{ 	CocoaDialog.getPaths({ arg paths;
						cloud = Object.readArchive(paths[0]);
						syncCloud.value(true);
						("GranCloud Loaded: " ++ paths[0]).inform
					}); 
				}
			);
			
			gui[\saveCloudButton] = buildButton.value(window.view, 80,
				[ [ "Save Cloud", color[\black], color[\yellow] ] ],
				0,
				{ 	CocoaDialog.savePanel({ arg path;
						cloud.writeArchive(path);
						("GranCloud Saved: " ++ path).inform
					});
				}
			);
	
			window.view.decorator.shift(106);
			
			gui[\playButton] = buildButton.value(window.view, 40,
				[ 	[ "Play", color[\black], color[\green] ], 
					[ "Stop", color[\black], color[\red]   ] ],
				0,
				{ arg button; 
					if ( button.value == 0, { 
						cloud.stop;
						if(gui[\scrubButton].value == 0, { gui[\playRoutine].stop })
					}, { 
						cloud.play(server, out, groupID, gui[\playTimeNumberBox].value);
						if(gui[\scrubButton].value == 0, {
							gui[\playRoutine] = Routine({
								{
									{ updateTime.value(cloud.playTime) }.defer;
									0.15.wait
								}.loop
							}).play
						})
					});
					if(gui[\windows, \attr].notNil, {
						gui[\windows, \attr].keysValuesDo({ arg attr;
							gui[\windows, \attr, attr, \playButton].value = button.value
						})
					})
				}
			);
	
			gui[\recordButton] = buildButton.value(window.view, 80,
				[ 	[ "Prepare Rec", color[\black], color[\green]  ], 
					[ "Record",      color[\black], color[\yellow] ],
					[ "Stop" ,       color[\black], color[\red]    ],
					[ "Wait",		   color[\black], color[\yellow] ] ],
				0,
				{ arg button;
					var routine, listen;
				
					if(button.value == 1, {
						CocoaDialog.savePanel({ arg path;
							recordPath = path;
							recordBuf  = recordBuf ? Buffer.alloc(server, 65536, cloud.numChannels);

							// create an output file for this buffer, leave it open
							recordBuf.write(
								recordPath, 
								headerFormats[gui[\headerPopUpMenu].value], 
								sampleFormats[gui[\samplePopUpMenu].value], 
								0, 0, true
							);
							recordIsPrepared = true;
							("Prepared for Record: " ++ path).inform
						}, {
							button.value = 0;
							button.doAction;
						})
					},{
						if(button.value == 2, {
							if(recordIsPrepared, {
								recordSynth = Synth.tail(0, "GranCloud-Record", ["bufnum", recordBuf.bufnum]);
								cloud.play(server, out, groupID, gui[\playTimeNumberBox].value);
								isRecording = true;
								"Recording...   ".post;
								
								// listen for the cloud to stop
								listen = Routine({
									while({ cloud.isStopped.not }, {
										0.1.wait
									});
									cloud.stop;
									button.value = 3;
									button.doAction;
								});
								AppClock.play(listen);
							}, {
								button.value == 0;
							})
						}, {
							if(isRecording, {
								routine = Routine({
									cloud.stop;
									
									while({ cloud.isStopped.not }, {
										0.1.wait;
									});
									
									isRecording = false;
									recordSynth.free;
									recordBuf.close;
									recordBuf.free;
									recordBuf = nil;
									button.value = 0;
									"done.".postln
								});
								AppClock.play(routine)
							})
						})
					})
				}
			);
			
			
			headerFormats = #[ "AIFF", "WAV", "RIFF","Sun","IRCAM","raw" ];
			gui[\headerPopUpMenu] = buildPopUp.value(window.view, 60, headerFormats, 0 );
			
			sampleFormats = #[ "int8","int16","int24","int32","mulaw","alaw","float32" ];
			gui[\samplePopUpMenu] = buildPopUp.value(window.view, 60, sampleFormats, 1 );
			
			window.view.decorator.shift(10);
			
			buildLabel.value(window.view, 55, "Play Time", color[\white], \right);
			gui[\playTimeNumberBox] = buildNumberBox.value(window.view, 40,
				action: { arg box, skipSet=false;
					cloud.playTime = box.value;
					updateTime.value(box.value);
					updateDisplay.value
				}
			);
			
			buildLabel.value(window.view, 50, "Duration", color[\white], \right);
			gui[\durationNumberBox] = buildNumberBox.value(window.view, 40,
				action: { arg box;
					cloud.duration = box.value;
					gui[\scrubSlider].value = gui[\playTimeNumberBox].value / getDur.value;
					updateDisplay.value
				}
			);
			window.view.decorator.nextLine.shift(335);
	
			gui[\scrubButton] = buildButton.value(window.view, 40,
				[ 	[ "Scrub", color[\black], color[\green] ], 
					[ "Off",  color[\black], color[\red]   ] ],
				0,
				{ arg button;
					if ( button.value == 0, 
						{ cloud.isScrub = false }, 
						{ cloud.isScrub = true  }
					);
					if(gui[\windows, \attr].notNil, {
						gui[\windows, \attr].keysValuesDo({ arg attr;
							gui[\windows, \attr, attr, \scrubButton].value = button.value
						})
					})
				}
			);
			
			gui[\scrubSlider] = buildSlider.value(window.view, 413, objHeight,
				action: { arg slider;
					cloud.playLoops = true;
					gui[\playTimeNumberBox].value = slider.value * getDur.value;
					gui[\playTimeNumberBox].doAction;
				}
			);	
	
			window.view.decorator.nextLine.shift(0, 10);
			
			viewMap = IdentityDictionary[
				0 -> \main,
				1 -> \attr
			];
			gui[\viewPopUpMenu]  = buildPopUp.value(window.view, 100, 
				#[ "Main View", "Attribute View" ], 
				currentViewIndex, 
				{ arg menu;
					gui[\views, viewMap[currentViewIndex]].visible  = false; 
					gui[\views, viewMap[menu.value]].visible = true;
					currentViewIndex = menu.value;
					updateDisplay.value;
				}
			);
		
			window.view.decorator.shift(242, -10);
	
			buildLabel.value(window.view, 30, "Loop", color[\white], \left);
			gui[\loopCheckBox] = buildButton.value(window.view, 27,
				[ 	[ "off", color[\black], color[\blue] ], 
					[ "on", color[\black],  color[\red]  ]  ],
				0,
				{ arg button;
					cloud.loopAll = if( button.value == 1, 
						{ [ 	gui[\loopStartNumberBox].value, 
							gui[\loopStopNumberBox].value, 
							gui[\loopNumTimesNumberBox].value ]  }, 
						{ nil }
					)
				}
			);
					
			buildLabel.value(window.view, 30, "Start", color[\white], \right);
			gui[\loopStartNumberBox] = buildNumberBox.value(window.view, 40, 
				nil, 
				{ arg box;
					if(cloud.loopAll.notNil, { cloud.loopAll[0] = box.value })
				}
			);
					
			buildLabel.value(window.view, 30, "Stop", color[\white], \right);
			gui[\loopStopNumberBox] = buildNumberBox.value(window.view, 40, 
				nil, 
				{ arg box;
					if(cloud.loopAll.notNil, { cloud.loopAll[1] = box.value })
				}
			);
					
			buildLabel.value(window.view, 50, "Number", color[\white], \right);
			gui[\loopNumTimesNumberBox] = buildNumberBox.value(window.view, 40, 
				nil, 
				{ arg box;
					if(cloud.loopAll.notNil, { cloud.loopAll[2] = box.value })
				}
			);
			
			window.view.decorator.shift(0, 10);
			
			syncCloud.value(true);
			window.front;

		};
		
		
		///// USEFUL FUNCTION DEFS /////
		getDur = {
			// the GUI doesn't deal well with an infinite duration, so set use a high # for inf
			if(cloud.duration == inf, { GranCloudGUI.infinity }, { cloud.duration})
		};
		
		// functions to build and rebuild the views
		buildViews = { arg currentRowStart, maxRows;
		
			var views;
			
			views = Array.newClear(2);		
						
			// remove any existing views
			gui[\views].do({ arg item;
				item.remove;
				item = nil;
			});
			
			// build the composite views
			[ \main, \attr ].do({ arg viewType, i;
				views[i] = buildCompositeView.value(window.view, color[\purpleGrad], i, currentViewIndex, 794, 500);
				gui[\views, viewType] = views[i];
				window.view.decorator.shift(-794, -503);
			});
			
			// add the attributes labels
			views[0].decorator.shift(23);
			
			buildLabel.value(views[0], 75, "Attribute", color[\white], \center);
			buildLabel.value(views[0], 40, "State", color[\white], \center);

			views[0].decorator.shift(10);
			
			buildLabel.value(views[0], 90, "Center", color[\white], \center);
			buildLabel.value(views[0], 90, "Deviation", color[\white], \center);

			views[0].decorator.shift(10);
			
			buildLabel.value(views[0], 30, "Loop", color[\white], \center);
			buildLabel.value(views[0], 40, "Start", color[\white], \center);
			buildLabel.value(views[0], 40, "Stop", color[\white], \center);
			buildLabel.value(views[0], 40, "Num", color[\white], \center);

			views[0].decorator.shift(10);

			buildLabel.value(views[0], 40, "Min", color[\white], \center);
			buildLabel.value(views[0], 40, "Max", color[\white], \center);
			buildLabel.value(views[0], 40, "Warp", color[\white], \center);
			buildLabel.value(views[0], 40, "Step", color[\white], \center);			//buildLabel.value(views[0], 40, "Default", color[\white], \center);
			buildLabel.value(views[0], 40, "Units", color[\white], \center);
			
			views[0].decorator.nextLine;
						
			cloud.order.do({ arg attr;
				buildMainAttrRow.value(views[0], attr);
			});
			buildMainAttrRow.value(views[0], \addNewAttr);

			views.do({ arg view; view.refresh });
			gui[\window].refresh;		
			
		};	
		
		// set up function to get the attribute rows
		buildMainAttrRow = { arg view, attr;
			
			view.decorator.shift(4, 0);
			
			if(attr == \addNewAttr, {
				gui[\main, \attr, attr, \addAttrButton] = buildButton.value(view, 12,
					[ [  "+", color[\black], color[\green] ] ],
					0,
					{ {	var test, newName, newUnits, isExp, name, center, min, max, warp, step;
				
						test = true;
						// check required fields
						name    = gui[\main, \attr, attr, \newAttrNameTextField];
						center  = gui[\main, \attr, attr, \centerNumberBox];
						min     = gui[\main, \attr, attr, \minNumberBox];
						max     = gui[\main, \attr, attr, \maxNumberBox];
						warp    = gui[\main, \attr, attr, \warpTextField];
						step    = gui[\main, \attr, attr, \stepNumberBox];
						newName = name.string;
						newUnits = gui[\main, \attr, attr, \unitsTextField].string ? "";
												
						[ name, center, min, max, warp, step ].do({ arg item;
							if((item.value.size >= 1) || 
								((item.value.asString.size >= 1) && (item.value.asString != "nil")), {
								item.setProperty(\boxColor, color[\white]);
							}, {
								item.setProperty(\boxColor, color[\lightred]);
								test = false;
							})
						});
						
						if(test && (newName.size >= 1), { 
							newName = newName.asSymbol;
							cloud.center[newName] = center.value;
							cloud.dev[newName] = 
								gui[\main, \attr, attr, \devNumberBox].value;
							cloud.spec[newName] = 
								[ min.value,
								  max.value,
								  if(warp.string == "0", {
							 		0
								  }, { 
									if(warp.string.asFloat == 0, {
									  // box has letters
									  warp.string.asSymbol
									}, {
									  // box is a number
									  warp.string.asFloat 
									})
								  }),
								  step.value,
								  center.value,
								  newUnits
								 ].asSpec;
							if(gui[\main, \attr, attr ,\loopCheckBox].value == 1, {
								cloud.loop[newName] = [
								  gui[\main, \attr, attr, \loopStartNumberBox].value,
								  gui[\main, \attr, attr, \loopStopNumberBox].value,
								  gui[\main, \attr, attr, \loopCheckBox].value
								];
							});
							syncCloud.value(true);
						})
					}.value }
				)
			}, {
				gui[\main, \attr, attr, \delAttrButton] = buildButton.value(view, 12,
					[ [  "-", color[\black], color[\red] ] ],
					0,
					{ 
						cloud.center.removeAt(attr);
						cloud.dev.removeAt(attr);
						cloud.spec.removeAt(attr);
						cloud.centerSpec.removeAt(attr);
						cloud.centerSpec.removeAt(attr);
						cloud.loop.removeAt(attr);
						cloud.dist.removeAt(attr);
						syncCloud.value(true);
					}
				)
			});
			
			view.decorator.shift(4, 0);
		
			if(attr == \addNewAttr, {
				gui[\main, \attr, attr, \newAttrNameTextField] = buildTextField.value(view, 75)			}, {
				gui[\main, \attr, attr, \attrButton] = buildButton.value(view, 75,
					[ [ attr, color[\black], color[\purple] ] ],
					0,
					{ openAttrWindow.value(attr, false) }
				)
			});

			gui[\main, \attr, attr, \currStateNumberBox] = buildNumberBox.value(view, 40);			
			view.decorator.shift(10);

			gui[\main, \attr, attr, \centerNumberBox] = buildNumberBox.value(view, 40);			gui[\main, \attr ,attr ,\centerTypeLabel] = buildLabel.value(view, 47, if(attr == \addNewAttr, { "Float" }, { "" }), color[\black], \left);
			
			gui[\main, \attr, attr, \devNumberBox] = buildNumberBox.value(view, 40);			gui[\main, \attr, attr, \devTypeLabel] = buildLabel.value(view, 47, if(attr == \addNewAttr, { "Float" }, { "" }), color[\black], \left);
			
			view.decorator.shift(10);
			
			gui[\main, \attr, attr, \loopCheckBox] = buildButton.value(view, 40,
				[ 	[ "off", color[\black], color[\purple] ], 
					[ "on", color[\black],  color[\red]  ] 
				],
				0,
				{ arg loop;
					if(cloud.loop[attr].notNil, {
						if( loop.value == 1, {
							cloud.loop[attr] =
								[ gui[\main, \attr, attr, \loopStartNumberBox].value,
							    	  gui[\main, \attr, attr, \loopStopNumberBox].value, 
							    	  gui[\main, \attr, attr, \numLoopsNumberBox].value ]  
						}, { 
							cloud.loop[attr] = nil;
						})
					});
					if(gui[\windows, \attr, attr].notNil, {
						if(gui[\windows, \attr, attr, \loopCheckBox].notNil, {
							gui[\windows, \attr, attr, \loopCheckBox].value = 
								gui[\main, \attr, attr, \loopCheckBox].value;
						})
					})
				}
			);
					
			gui[\main, \attr, attr, \loopStartNumberBox] = buildNumberBox.value(view, 40,
				nil,
				{ arg box;
				if(cloud.loop[attr].notNil, { cloud.loop[attr][0] = box.value });
					if(gui[\windows, \attr, attr].notNil, {
						if(gui[\windows, \attr, attr, \loopStartNumberBox].notNil, {
							gui[\windows, \attr, attr, \loopStartNumberBox].value = 
								gui[\main, \attr, attr, \loopStartNumberBox].value;
						})
					})
				}
			);
					
			gui[\main, \attr, attr, \loopStopNumberBox] = buildNumberBox.value(view, 40,
				nil,
				{ arg box;
					if(cloud.loop[attr].notNil, { cloud.loop[attr][1] = box.value });
					if(gui[\windows, \attr, attr].notNil, {
						if(gui[\windows, \attr, attr, \loopStopNumberBox].notNil, {
							gui[\windows, \attr, attr, \loopStopNumberBox].value = 
								gui[\main, \attr, attr, \loopStopNumberBox].value;
						})
					})
				}
			);
					
			gui[\main, \attr, attr, \loopNumTimesNumberBox] = buildNumberBox.value(view, 40,
				nil,
				{ arg box;
					if(cloud.loop[attr].notNil, { cloud.loop[attr][2] = box.value });
					if(gui[\windows, \attr, attr].notNil, {
						if(gui[\windows, \attr, attr, \loopNumTimesNumberBox].notNil, {
							gui[\windows, \attr, attr, \loopNumTimesNumberBox].value = 
								gui[\main, \attr, attr, \loopNumTimesNumberBox].value;
						})
					});
				}
			);
			
			view.decorator.shift(10);

			gui[\main, \attr, attr, \minNumberBox] = buildNumberBox.value(view, 40,
				nil,
				{ arg box;
					if(cloud.spec[attr].notNil, { 
						if((box.value == 0) && (cloud.spec[attr].warp.asSpecifier.asSymbol == \exp) || (cloud.spec[attr].warp.asSpecifier.asSymbol == \exponential), {
							box.value = 0.00001 
						}); 
						cloud.spec[attr].minval = box.value; 
					});
				}
			);
					
			gui[\main, \attr, attr, \maxNumberBox] = buildNumberBox.value(view, 40,
				nil,
				{ arg box;
					if(cloud.spec[attr].notNil, { 
						if((box.value == 0) && (cloud.spec[attr].warp.asSpecifier.asSymbol == \exp) || (cloud.spec[attr].warp.asSpecifier.asSymbol == \exponential), {
							box.value = -0.00001 
						}); 
						cloud.spec[attr].maxval = box.value; 
					});
				}
			);
					
			gui[\main, \attr, attr, \warpTextField] = buildTextField.value(view, 40,
				nil,
				{ arg box;
					var isExp;
					isExp = if((box.value.asSymbol == \exp) || (box.value.asSymbol == \exponential), { true }, { false });
				
					if(cloud.spec[attr].notNil, { 
						if(box.value == "0", {
							 cloud.spec[attr].warp = 0.asWarp(cloud.spec[attr])
						}, { 
							if(box.value.asFloat == 0, {
								// box has letters
								cloud.spec[attr].warp = 
									box.value.asSymbol.asWarp(cloud.spec[attr]);
								if(isExp && (gui[\main, \attr, attr, \minNumberBox].value == 0), { gui[\main, \attr, attr, \minNumberBox].value = 0.00001; cloud.spec[attr].minval == 0.00001 });
								if(isExp && (gui[\main, \attr, attr, \maxNumberBox].value == 0), { gui[\main, \attr, attr, \maxNumberBox].value = -0.00001; cloud.spec[attr].maxval == -0.00001 });
							}, {
								// box is a number
								cloud.spec[attr].warp = 
									box.value.asFloat.asWarp(cloud.spec[attr]) 
							})
						})
					})	
				}
			);
			
			gui[\main, \attr, attr, \stepNumberBox] = buildNumberBox.value(view, 40,
				nil,
				{ arg box;
					if(cloud.spec[attr].notNil, { cloud.spec[attr].step = box.value });
				}
			);
				
//			gui[\main, \attr, attr, \defaultNumberBox] = buildNumberBox.value(view, 40, 
//				nil,
//				{ arg box;
//					if(cloud.spec[attr].notNil, { cloud.spec[attr].default = box.value });
//				}
//			);
				
			gui[\main, \attr, attr, \unitsTextField] = buildTextField.value(view, 40,
				nil, 
				{ arg box;
					if(cloud.spec[attr].notNil, { cloud.spec[attr].units = box.value });
				}
			);
						
			view.decorator.nextLine;

		};


		///// ATTRIBUTE WINDOW CODE /////
		
		openAttrWindow = { arg attr, reopen=false;
		
			var left=70, bottom=150, maxLeft, minBottom, currMaxLeft, currMinBottom;
			var height = 550, width = 700, window;
						
			if((gui[\windows, \attr, attr].isNil || reopen), {
				
				if(reopen, {
					left = gui[\windows, \attr, attr, \window].bounds.left;
					bottom = gui[\windows, \attr, attr, \window].bounds.top;
				}, {
					// figure out where to open it
					minBottom = 0;
					maxLeft   = SCWindow.screenBounds.width - width;
					currMaxLeft = left - 25;
					currMinBottom = bottom + 20;
					
					if(gui[\windows, \attr].notNil, {
						gui[\windows, \attr].keysValuesDo({ arg key;
							if (currMaxLeft < gui[\windows, \attr, key, \window].bounds.left, {
								currMaxLeft = gui[\windows, \attr, key, \window].bounds.left;
							});
							if (currMinBottom > gui[\windows, \attr, key, \window].bounds.top,{
								currMinBottom = gui[\windows, \attr, key, \window].bounds.top;
							});
						})
					});
					if((currMaxLeft + 25) < maxLeft, {
						left = currMaxLeft + 25;
					});
					if((currMinBottom - 20) > minBottom, {
						bottom = currMinBottom - 20;
					});

				});
								
				gui[\windows, \attr, attr] = IdentityDictionary.new;
//				gui[\windows, \spec, attr] = gui[\windows, \spec, attr] ? IdentityDictionary.new;
				
//				[\center, \dev].do({ arg type;
//					var array;
//					
//					if(gui[\windows, \spec, attr, type].isNil, {
//						// the way the warp stores the spec, .copy won't work here
//						// so break it down and rebuild it
//						array = cloud.spec[attr].storeArgs;
//						if(type == \dev, {
//							// don't let a deviation be exponential because it must go to zero
//							array[0] = 0;
//							array[1] = array[1] / 2;
//							if(array[2] == \exp, {
//								array[2] = 'lin';
//							});
//							
//						});
//						gui[\windows, \spec, attr, type] = array.asSpec;
//					})
//				});
				
				// open the window, this is a local copy
				window = SCWindow(gui[\window].name ++ ": " ++ attr, Rect(left, bottom, width, height));
				window.view.background = color[\greenGrad];
				window.view.decorator  = FlowLayout(Rect(0, 0, width, height), Point(3, 3), Point(3, 3));
				window.onClose = { gui[\windows, \attr].removeAt(attr) };
				gui[\windows, \attr, attr, \window] = window;
				
				gui[\windows, \attr, attr, \closeButton] = buildButton.value(window.view, 40, 
					[ [ "Close", color[\black], color[\red] ] ],
					0,
					{ window.close }
				);
				
				window.view.decorator.shift(20);
		
				gui[\windows, \attr, attr, \playButton] = buildButton.value(window.view, 40,
					[ 	[ "Play", color[\black], color[\green] ], 
						[ "Stop", color[\black], color[\red] ] ],
					gui[\playButton].value,
					{ arg button;
						gui[\playButton].value = button.value; 
						gui[\playButton].doAction;
					}
				);
				
				gui[\windows, \attr, attr, \scrubButton] = buildButton.value(window.view, 40,
					[ 	[ "Scrub", color[\black], color[\green] ], 
						[ "Off", color[\black], color[\red] ] ],
					gui[\scrubButton].value,
					{ arg button;
						gui[\scrubButton].value = button.value;
						gui[\scrubButton].doAction; 
					}
				);
		
				buildLabel.value(window.view, 30, "Time", color[\white], \right);
				gui[\windows, \attr, attr, \playTimeNumberBox] = 
					buildNumberBox.value(window.view, 33, 
						gui[\playTimeNumberBox].value,
						{ arg box;
							gui[\playTimeNumberBox].value = box.value;
							gui[\playTimeNumberBox].doAction
						}
					);

				window.view.decorator.shift(20, 0);
								
				buildLabel.value(window.view, 30, "Loop", color[\white], \center);
				buildLabel.value(window.view, 40, "Start", color[\white], \center);
				buildLabel.value(window.view, 40, "Stop", color[\white], \center);
				buildLabel.value(window.view, 40, "Num", color[\white], \center);
	
				window.view.decorator.shift(10);
	
				buildLabel.value(window.view, 40, "Min", color[\white], \center);
				buildLabel.value(window.view, 40, "Max", color[\white], \center);
				buildLabel.value(window.view, 40, "Warp", color[\white], \center);
				buildLabel.value(window.view, 40, "Step", color[\white], \center);
				//buildLabel.value(window.view, 40, "Default", color[\white], \center);
				buildLabel.value(window.view, 40, "Units", color[\white], \center);

				window.view.decorator.nextLine;

				gui[\windows, \attr, attr, \scrubSlider] = buildSlider.value(window.view, 219, 
					objHeight, 
					gui[\scrubSlider].value, 
					{ arg slider;
						gui[\scrubSlider].value = slider.value;
						gui[\scrubSlider].doAction;
					}
				);
				
				window.view.decorator.shift(20, 0);

						
				gui[\windows, \attr, attr, \loopCheckBox] = buildButton.value(window.view, 30,
					[ 	[ "off", color[\black], color[\green] ], 
						[ "on", color[\black],  color[\red]  ] 
					],
					gui[\main, \attr, attr, \loopCheckBox].value,
					{ arg loop;
						gui[\main, \attr, attr, \loopCheckBox].value = loop.value;
						gui[\main, \attr, attr, \loopCheckBox].doAction
					}
				);
						
				gui[\windows, \attr, attr, \loopStartNumberBox] = 
					buildNumberBox.value(window.view, 40,
						gui[\main, \attr, attr, \loopStartNumberBox].value,
						{ arg box;
							gui[\main, \attr, attr, \loopStartNumberBox].value = box.value;
							gui[\main, \attr, attr, \loopStartNumberBox].doAction;
						}
				);
						
				gui[\windows, \attr, attr, \loopStopNumberBox] = 
					buildNumberBox.value(window.view, 40,
						gui[\main, \attr, attr, \loopStopNumberBox].value,
						{ arg box;
							gui[\main, \attr, attr, \loopStopNumberBox].value = box.value;
							gui[\main, \attr, attr, \loopStopNumberBox].doAction;
						}
				);
						
				gui[\windows, \attr, attr, \loopNumTimesNumberBox] = 
					buildNumberBox.value(window.view, 40,
						gui[\main, \attr, attr, \loopNumTimesNumberBox].value,
						{ arg box;
							gui[\main, \attr, attr, \loopNumTimesNumberBox].value = box.value;
							gui[\main, \attr, attr, \loopNumTimesNumberBox].doAction;
						}
				);

				window.view.decorator.shift(10);

				gui[\windows, \attr, attr, \minNumberBox] = buildNumberBox.value(window.view, 40,
					cloud.centerSpec[attr].minval,
					{ arg box;
						if((box.value == 0) && ((cloud.centerSpec[attr].warp.asSpecifier.asSymbol == \exp) || (cloud.centerSpec[attr].warp.asSpecifier.asSymbol == \exponential)), { 
							box.value = 0.00001
						});
						cloud.centerSpec[attr].minval = box.value;						rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);					}
				);
						
				gui[\windows, \attr, attr, \maxNumberBox] = buildNumberBox.value(window.view, 40,
					cloud.centerSpec[attr].maxval,
					{ arg box;
						if((box.value == 0) && ((cloud.centerSpec[attr].warp.asSpecifier.asSymbol == \exp) || (cloud.centerSpec[attr].warp.asSpecifier.asSymbol == \exponential)), { 
							box.value = -0.00001
						});
						cloud.centerSpec[attr].maxval = box.value;
						rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
					}
				);
								
				gui[\windows, \attr, attr, \warpTextField] =
					buildTextField.value(window.view, 40,
						cloud.centerSpec[attr].warp.asSpecifier.asString,
						{ arg box;
							var isExp;
							isExp = if((box.value.asSymbol == \exp) || (box.value.asSymbol == \exponential), { true }, { false });
						
							if(box.value == "0", {
								 cloud.centerSpec[attr].warp = 
								 	0.asWarp(cloud.centerSpec[attr])
							}, { 
								if(box.value.asFloat == 0, {
									// box has letters
									cloud.centerSpec[attr].warp = 
										box.value.asSymbol.asWarp(cloud.centerSpec[attr]);
									if(isExp && (gui[\windows, \attr, attr, \minNumberBox].value == 0), { gui[\windows, \attr, attr, \minNumberBox].value = 0.00001; cloud.centerSpec[attr].minval = 0.00001 });
									if(isExp && (gui[\windows, \attr, attr,  \maxNumberBox].value == 0), { gui[\windows, \attr, attr, \maxNumberBox].value = -0.00001;  cloud.centerSpec[attr].maxval = -0.00001 });

								}, {
									// box is a number
									cloud.centerSpec[attr].warp = 
										box.value.asFloat.asWarp(cloud.centerSpec[attr]) 
								});
							});
							rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
						}
				);
									
				gui[\windows, \attr, attr, \stepNumberBox] = 
					buildNumberBox.value(window.view, 40,
						cloud.centerSpec[attr].step,
						{ arg box;
							cloud.centerSpec[attr].step = box.value;
							rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
						}
				);
									
//				gui[\windows, \attr, attr, \defaultNumberBox] = 
//					buildNumberBox.value(window.view, 40,
//						cloud.centerSpec[attr].default,
//						{ arg box;
//							cloud.centerSpec[attr].default = box.value;
//							rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
//						}
//				);
						
				gui[\windows, \attr, attr, \unitsTextField] = 
					buildTextField.value(window.view, 40,
						cloud.centerSpec[attr].units,
						{ arg box;
							cloud.centerSpec[attr].units = box.value;
							rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
						}
				);				
											
				window.view.decorator.nextLine.shift(414);

				gui[\windows, \attr, attr, \minNumberBoxDev] = buildNumberBox.value(window.view, 40,
					cloud.devSpec[attr].minval,
					{ arg box;
						if((box.value == 0) && ((cloud.devSpec[attr].warp.asSpecifier.asSymbol == \exp) || (cloud.devSpec[attr].warp.asSpecifier.asSymbol == \exponential)), { 
							box.value = 0.00001
						});
						cloud.devSpec[attr].minval = box.value;
						rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);					}
				);
						
				gui[\windows, \attr, attr, \maxNumberBoxDev] = buildNumberBox.value(window.view, 40,
					cloud.devSpec[attr].maxval,
					{ arg box;
						if((box.value == 0) && ((cloud.devSpec[attr].warp.asSpecifier.asSymbol == \exp) || (cloud.devSpec[attr].warp.asSpecifier.asSymbol == \exponential)), { 
							box.value = -0.00001
						});
						cloud.devSpec[attr].maxval = box.value;						rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
					}
				);
						
				gui[\windows, \attr, attr, \warpTextFieldDev] = 
					buildTextField.value(window.view, 40,
						cloud.devSpec[attr].warp.asSpecifier.asString,
						{ arg box;
							var isExp;
							isExp = if((box.value.asSymbol == \exp) || (box.value.asSymbol == \exponential), { true }, { false });

							if(box.value == "0", {
								 cloud.devSpec[attr].warp = 
								 	0.asWarp(cloud.devSpec[attr])
							}, { 
								if(box.value.asFloat == 0, {
									// box has letters
									cloud.devSpec[attr].warp = 
										box.value.asSymbol.asWarp(cloud.devSpec[attr]);
									if(isExp && (gui[\windows, \attr, attr, \minNumberBoxDev].value == 0), { gui[\windows, \attr, attr, \minNumberBoxDev].value = 0.00001; cloud.devSpec[attr].minval = 0.00001 });
									if(isExp && (gui[\windows, \attr, attr, \maxNumberBoxDev].value == 0), { gui[\windows, \attr, attr, \maxNumberBoxDev].value = -0.00001;  cloud.devSpec[attr].maxval = -0.00001 });

								}, {
									// box is a number
									cloud.devSpec[attr].warp = 
										box.value.asFloat.asWarp(cloud.devSpec[attr]) 
								})
							});
							rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
						}
				);
					
				gui[\windows, \attr, attr, \stepNumberBoxDev] = 
					buildNumberBox.value(window.view, 40,
						cloud.devSpec[attr].step,
						{ arg box;
							cloud.devSpec[attr].step = box.value;
							rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
						}
				);
									
//				gui[\windows, \attr, attr, \defaultNumberBoxDev] = 
//					buildNumberBox.value(window.view, 40,
//						cloud.devSpec[attr].default,
//						{ arg box;
//							cloud.devSpec[attr].default = box.value;
//							rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
//						}
//				);
						
				gui[\windows, \attr, attr, \unitsTextFieldDev] = 
					buildTextField.value(window.view, 40,
						cloud.devSpec[attr].units,{ arg box;
							cloud.devSpec[attr].units = box.value;
							rebuildAttrGUI.value(window.view, attr, width, (height - 91) / 2);
						}
				);
									
				window.view.decorator.nextLine.shift(0, -10);
				buildAttrGUI.value(window.view, attr, \center, "Center", width, (height - 91) / 2);
				buildAttrGUI.value(window.view, attr, \dev, "Deviation", width, (height - 91) / 2);
				window.view.decorator.nextLine;
		
				
			});
			
			
			
			syncAttrWindow.value(attr);
			gui[\windows, \attr, attr, \window].refresh.front;
			

		};
		
		rebuildAttrGUI = { arg view, attr, width, height;

			[\center, \dev].do({ arg type;
				gui[\windows, \attr, attr, type, \typeLabel].remove;
				gui[\windows, \attr, attr, type, \dataTypePopUpMenu].remove;
				gui[\windows, \attr, attr, type, \views].do({ arg item;
					item.remove;
				});
			});			
			gui[\windows, \attr, attr, \window].view.decorator.shift(0, ((height * 2) + 30 ).neg);
			buildAttrGUI.value(view, attr, \center, "Center", width, height);
			buildAttrGUI.value(view, attr, \dev, "Deviation", width, height);
			gui[\windows, \attr, attr, \window].refresh.front
		};
		
		buildAttrGUI = { arg view, attr, type, label, width, height;
		
			var viewMap, classIndex, views, currentAttrViewIndex;
			
			if(this.isPlaying.not, {
				cloud.nextGrainArgs(gui[\playTimeNumberBox].value);
			});	
			
			
			views  = Array.newClear(5);
			gui[\windows, \attr, attr, type] = IdentityDictionary.new;
			
			// build the view selection popup menu
			viewMap = IdentityDictionary[ 
				0 -> \Number, 
				1 -> \Env,
				2 -> \CompileString
			];
			
			classIndex = IdentityDictionary[
				\Float   -> 0,
				\Integer -> 0,
				\Env     -> 1
			];
						
			gui[\windows, \attr, attr, type, \typeLabel] = 
				buildLabel.value(view, 55, label, color[\white], \left);
			gui[\windows, \attr, attr, type, \dataTypePopUpMenu] = buildPopUp.value(view, 100, 
				#[ "Number", "Envelope", "Compile String" ],
				classIndex[cloud.instVarAt(type)[attr].class.asSymbol] ? 2,
				{ arg menu;
					views[currentAttrViewIndex].visible  = false; 
					views[menu.value].visible = true;
					currentAttrViewIndex = menu.value;
					if(currentAttrViewIndex == 2, {
						buildAttrTextView.value(attr, type);
					}, {
						if(gui[\windows, \attr, attr, type, \CompileString, \textView].notNil, {
							gui[\windows, \attr, attr, type, \CompileString, \textView].remove;
							gui[\windows, \attr, attr, type, \CompileString, \textView] = nil;
						})
					});
					views[menu.value].refresh;
				},
				color[\white]
			);
			currentAttrViewIndex = gui[\windows, \attr, attr, type, \dataTypePopUpMenu].value;

			view.decorator.nextLine;
			
			// build the Views
			[ \Number, \Env, \CompileString ].do({ arg dataType, i;
				views[i] = buildCompositeView.value(view, color[\green], i, currentAttrViewIndex, width - 6, height - 9);
				gui[\windows, \attr, attr, type, dataType] = IdentityDictionary.new;
				gui[\windows, \attr, attr, type, \views, dataType] = views[i];
				if(i < 2, {
					view.decorator.shift(view.decorator.maxRight.neg, view.decorator.maxHeight.neg - 3).nextLine;
				})
			});
			
			buildAttrSliderView.value(views[0], attr, type, \Number, width - 12, height - 12);
			buildAttrEnvView.value(views[1],    attr, type, \Env, width - 12, height - 12);
			buildAttrCompileView.value(views[2], attr, type, width - 12, height - 12, currentAttrViewIndex);
			window.view.decorator.nextLine;
			
		
		};

		
		buildAttrSliderView = { arg view, attr, type, dataType, width, height;

			var spec;
			
			spec = if(type == \center, { cloud.centerSpec[attr] }, { cloud.devSpec[attr] });

			buildLabel.value(view, 5, "");
			view.decorator.nextLine.shift(30, 0);
			
			buildAttrDisplayGrid.value(view, attr, type, dataType, width - 30);			
			view.decorator.nextLine.shift(30);

			gui[\windows, \attr, attr, type, dataType, \attrSlider] = buildSlider.value(view,
				width - 66, 2 * objHeight,
				spec.unmap(
					if(type == \center, 
						{ cloud.centerArgs[attr] }, 
						{ cloud.devArgs[attr]    }
					)
				),
				{ cloud.instVarAt(type)[attr] = 
					spec.constrain(
						spec.map(		
							gui[\windows, \attr, attr, type, dataType, \attrSlider].value
						)
					);
					gui[\windows, \attr, attr, type, dataType, \attrNumberBox].value =
						cloud.instVarAt(type)[attr];
					updateDisplay.value
				});
		
			view.decorator.nextLine.shift(30, 0);
			
			gui[\windows, \attr, attr, type, dataType, \attrNumberBox] = 
				buildNumberBox.value(view, 100, 
					cloud.instVarAt(type)[attr],
					{ arg box;
						gui[\windows, \attr, attr, type, dataType, \attrSlider].value = 
							spec.unmap(box.value);
						gui[\windows, \attr, attr, type, dataType, \attrSlider].doAction;
					}
			);
			
			gui[\windows, \attr, attr, type, dataType, \unitsLabel] = buildLabel.value(view, 50,
				" " ++ spec.units.asString,
				color[\white],
				\left
			)
			
		};
		
		buildAttrEnvView = { arg view, attr, type, dataType, width, height;
			var views, viewMap, currentEnvViewIndex, spec;
						
			currentEnvViewIndex = gui[\windows, \var, attr, type, dataType, \currentEnvViewIndex] ? 0;
			
			views = Array.newClear(2);			
			viewMap = IdentityDictionary[ 0 -> \env, 1 -> \table ];
			gui[\windows, \attr, attr, type, dataType, \viewPopUpMenu] = 
				buildPopUp.value(view, 100,
					#[ "Env View", "Table View" ],
					currentEnvViewIndex,
					{ arg menu;
						views[currentEnvViewIndex].visible  = false; 
						views[menu.value].visible = true;
						gui[\windows, \var, attr, type, dataType, \resolution, currentEnvViewIndex] = gui[\windows, \attr, attr, type, dataType, \resolution].value.asInteger;
						
						currentEnvViewIndex = menu.value;
						gui[\windows, \var, attr, type, dataType, \currentEnvViewIndex] = currentEnvViewIndex;
						gui[\windows, \attr, attr, type, dataType, \resolution].value = 
							gui[\windows, \var, attr, type, dataType, \resolution, currentEnvViewIndex];
						
					},
					color[\white]
			);

			view.decorator.shift(20);

			// initialize the resolution vars
			gui[\windows, \var, attr, type, dataType, \resolution, 0] = 
				if(cloud.instVarAt(type)[attr].class.asSymbol == \Env, {
					cloud.instVarAt(type)[attr].levels.size;
				}, {
					10
				});

			gui[\windows, \var, attr, type, dataType, \resolution, 1] = 
				if(cloud.instVarAt(type)[attr].class.asSymbol == \Env, {
					(gui[\windows, \var, attr, type, dataType, \resolution, 1] ? 200)
				}, {
					200
				});
				
			buildLabel.value(view, 75, "Resolution", color[\white], \right);
			gui[\windows, \attr, attr, type, dataType, \resolution] = 
				buildNumberBox.value(view, 50, 
					gui[\windows, \var, attr, type, dataType, \resolution, currentEnvViewIndex],
					{ arg box;
					
						var times, states, curves, newTimes, newStates, newCurves, size;
						var points, newTime, env, elapsedTime;
						
						gui[\windows, \attr, attr, type, dataType, viewMap[currentEnvViewIndex], \envView].doAction;
						
						env = cloud.instVarAt(type)[attr];
						points = box.value.asInteger;
						
						gui[\windows, \var, attr, type, dataType, \resolution, currentEnvViewIndex] = points;
						
						if(env.class.asSymbol == \Env, {
							
							times  = cloud.instVarAt(type)[attr].times;
							states = cloud.instVarAt(type)[attr].levels;
							curves = cloud.instVarAt(type)[attr].curves;
							size = states.size;
							newTimes = Array.new(points);
							newStates = Array.new(points);
							newCurves = if(curves.isArray, { Array.new(points) }, { curves });
							
							if(currentEnvViewIndex == 0, {
								newTime = (getDur.value - times.sum) / (points - size);
								points.do({arg i;
									if(i < size, {
										newStates = newStates.add(states[i]);
										
										if(i > 0, {
											newTimes = newTimes.add(times[i - 1]);
											if(curves.isArray, { 
												newCurves = newCurves.add(curves[i - 1]) 
											})
										})
									}, {
										newStates = newStates.add(states[size - 1]);
										newTimes = newTimes.add(newTime);
										
										if(curves.isArray, { newCurves = newCurves.add(curves[size - 2] ) })
									})
								})
							}, {
								newTime = getDur.value / points;
								elapsedTime = 0;
								points.do({ arg i;
									newStates = newStates.add(env.at(elapsedTime));
									if(i > 0, {
										newTimes = newTimes.add(newTime);
									});
									elapsedTime = elapsedTime + newTime;
								});
								newCurves = if(curves.isArray, { curves[0] }, { curves });
								gui[\windows, \attr, attr, type, dataType, \table, \envView].xOffset_(gui[\windows, \attr, attr, type, dataType, \table, \envView].bounds.width / points);
							});
							cloud.instVarAt(type)[attr] = Env.new(newStates, newTimes, newCurves);
						}, {
							times  = Array.fill(points, { arg i; i / points });
							states = Array.fill(points, if(env.isNumber, { env }, { 0 }));
							curves = \lin;
							cloud.instVarAt(type)[attr] = Env.new(states, times, curves);
						});

						rebuildAttrGUI.value(gui[\windows, \attr, attr, \window].view, attr, gui[\windows, \attr, attr, \window].view.bounds.width, (gui[\windows, \attr, attr, \window].view.bounds.height - 91) / 2);
					}
					
			);
			
			view.decorator.shift(20);
			
			spec = if(type == \center, { cloud.centerSpec[attr] }, { cloud.devSpec[attr] });
			
			buildLabel.value(view, 10, "y", color[\white], \right);
			gui[\windows, \attr, attr, type, dataType, \y] = 
				buildNumberBox.value(view, 50, 0, { });
			buildLabel.value(view, 20, spec.units, color[\white], \right);	
			view.decorator.shift(10);
						
			buildLabel.value(view, 10, "x", color[\white], \right);
			gui[\windows, \attr, attr, type, dataType, \x] = 
				buildNumberBox.value(view, 50, 0, { });
			buildLabel.value(view, 20, "sec", color[\white], \right);
				
			view.decorator.shift(20);
			
			gui[\windows, \attr, attr, type, dataType, \plot] = buildButton.value(view, 50, 
				[ [ "Plot", color[\black], color[\green] ] ], 
				0,
				{ cloud.instVarAt(type)[attr].plot }
			);
			
			view.decorator.nextLine;
			
			// build the Views
			[ \env, \table ].do({ arg envType, i;
				views[i] = buildCompositeView.value(view, color[\green], 0, currentEnvViewIndex, width - 6, height - 30);
				gui[\windows, \attr, attr, type, dataType, envType] = IdentityDictionary.new;
				gui[\windows, \attr, attr, type, dataType, envType, \view] = views[i];
				if(i < 1, {
					view.decorator.shift(view.decorator.maxRight.neg, view.decorator.maxHeight.neg - 3).nextLine;
				})
			});
			
			buildEnvEnvView.value(views[0], attr, type, dataType, \env, width - 6, height - 51);
			buildEnvEnvView.value(views[1], attr, type, dataType, \table, width - 6, height - 51);
			
			// make sure the correct view is on top
			views.do({ arg view; view.visible = false });
			views[currentEnvViewIndex].visible = true;
			
		};
		
		buildEnvEnvView = { arg view, attr, type, dataType, envType, width, height;
			
			var env, envView, times, values, resolution, spec, envWidth, curves, curveObj, typeIndex;
			typeIndex = if(envType == \env, { 0 }, { 1 });
			envWidth = width - 69 - 33;
			buildVerticalAttrDisplayGrid.value(view, attr, type, dataType, 50, height);
			
			
			spec = if(type == \center, { cloud.centerSpec[attr] }, { cloud.devSpec[attr] });
			env = cloud.instVarAt(type)[attr];
			
			if(envType == \env, {
				resolution = gui[\windows, \var, attr, type, dataType, \resolution, 0].value;
				if(env.class.asSymbol == \Env, {
					times  = envToTimes.value(env.times);
					values = env.levels.collect({ arg item; spec.unmap(item) });
					curves = env.curves;
				}, {
					times  = Array.fill(resolution, { arg i; i / resolution });
					values = Array.fill(resolution, if(env.isNumber, { env }, { 0 }));
					curves = \lin;
					env = Env.new(values, times, curves);
				});

			
				envView = SCEnvelopeView(view, Rect(0, 0, envWidth, height));
				envView.thumbSize_(5)
					.drawLines_(true)
					.fillColor_(color[\green2])
					.selectionColor_(color[\red])
					.drawRects_(true)
					.value_([ times, values ])
					.editable_(true)
					.action_({ arg obj;
						var times, levels, time;
						#times, levels = obj.value;
						cloud.instVarAt(type)[attr] = Env.new(
							levels.collect({ arg level; spec.map(level) }), 
							timesToEnv.value(times),
							curveObj.string.interpret
						);
						time = obj.x * getDur.value;
						gui[\windows, \attr, attr, type, dataType, \x].value = time;
						gui[\windows, \attr, attr, type, dataType, \y].value = spec.map(obj.y);
						if(cloud.isScrub, { 
							cloud.playLoops = false;
							gui[\playTimeNumberBox].value = time;
							gui[\playTimeNumberBox].doAction
						})
					});
			}, {
			
				resolution = gui[\windows, \var, attr, type, dataType, \resolution, 1].value;
				times  = Array.fill(resolution,{ arg i; (i * getDur.value) / resolution });
				if(env.class.asSymbol == \Env, {
					values = times.collect({ arg item; spec.unmap(env.at(item)) });
					curves = if(env.curves.isArray, { env.curves[0] }, { env.curves });
				}, {
					values = Array.fill(resolution, if(env.isNumber, { env }, { 0 }));
					curves = \lin;
					env = Env.new(values, times, curves);
				});
				envView = SCMultiSliderView(view, Rect(0, 0, envWidth, height));
				envView.showIndex = true;
				envView.value_(values);
				envView.strokeColor_(color[\black]);
				envView.drawLines_(true);
				envView.drawRects_(false);
				envView.indexThumbSize_((envView.bounds.width / values.size) - 1);
				envView.valueThumbSize_(1);
				envView.action_({ arg obj;
						var newTimes, newLevels, newCurves, time;
						newLevels = envView.value.collect({ arg item; spec.map(item) });
						newTimes  = Array.fill(newLevels.size - 1, getDur.value / resolution );
						newCurves = curveObj.string.interpret;
						cloud.instVarAt(type)[attr] = Env.new(newLevels, newTimes, newCurves);
						time = obj.index * (getDur.value / resolution);
						gui[\windows, \attr, attr, type, dataType, \x].value = time;
						gui[\windows, \attr, attr, type, dataType, \y].value = spec.map(obj.currentvalue);
						if(cloud.isScrub, { 
							cloud.playLoops = false;
							gui[\playTimeNumberBox].value = time;
							gui[\playTimeNumberBox].doAction
						})
						
					});			
			
				gui[\windows, \attr, attr, type, dataType, \recSlider, typeIndex] = buildSlider.value(view, 30, height,
					action: { arg slider;
						if( gui[\windows, \attr, attr, type, dataType, \rec, typeIndex].value == 1, {
							cloud.instVarAt(type)[attr] = spec.map(slider.value);
						});
					}
				); 
			
			});
			
			view.decorator.nextLine;
			
			buildLabel.value(view, 50, "Curve(s)", color[\white], \left);
			curveObj = buildTextField.value(view, envWidth, 
				curves.asCompileString, 
				{ arg box;
					cloud.instVarAt(type)[attr].curves = box.value.interpret;
				}
			);
			
			if(typeIndex == 1, { 
			
				gui[\windows, \attr, attr, type, dataType, \rec, typeIndex] = buildButton.value(view, 30,
					[ [ "Rec", color[\black], color[\red] ], [ "Stop", color[\black], color[\green] ] ],
					0,
					{ arg button;
						var resolution, timeIncrement, exactOffset, offset, startTime, recSlider;
						if(button.value == 1, {
							// record from slider
							resolution = gui[\windows, \var, attr, type, dataType, \resolution, typeIndex].value;
							recSlider = gui[\windows, \attr, attr, type, dataType, \recSlider, typeIndex];
							gui[\windows, \attr, attr, type, dataType, \recArray, typeIndex] = envView.value;
							
							timeIncrement = getDur.value / resolution;
							startTime = cloud.playTime;
							exactOffset = startTime / timeIncrement;
							offset = exactOffset.asInteger;
							recSlider.value = gui[\windows, \attr, attr, type, dataType, \recArray, typeIndex].at(startTime);
							recSlider.doAction;
							if(cloud.isPlaying.not, { 
								cloud.play(server, out, groupID, startTime);
								gui[\windows, \attr, attr, type, dataType, \recWasPlaying, typeIndex] = false;
							}, {
								gui[\windows, \attr, attr, type, dataType, \recWasPlaying, typeIndex] = true;
							});
							gui[\windows, \attr, attr, type, dataType, \recRoutine, typeIndex] = 						Routine({
								(exactOffset - offset).wait;
								(resolution - offset).do({ arg i;
									{ 
										gui[\windows, \attr, attr, type, dataType, \recArray, typeIndex][i + offset] = recSlider.value;
										envView.value = gui[\windows, \attr, attr, type, dataType, \recArray, typeIndex];
										updateTime.value(cloud.playTime)
									}.defer;
									timeIncrement.wait;
								});
								{
									button.value = 0;
									button.doAction;
								}.defer
							}).play;
							gui[\windows, \attr, attr, type, dataType, \recTimes, typeIndex] = Array.fill(gui[\windows, \attr, attr, type, dataType, \recArray, typeIndex].size - 1, timeIncrement);
						}, {
							// stop recording
							gui[\windows, \attr, attr, type, dataType, \recRoutine, typeIndex].stop;
							if(gui[\windows, \attr, attr, type, dataType, \recWasPlaying, typeIndex].not, {
								cloud.stop;
							});
							cloud.instVarAt(type)[attr] = Env.new( envView.value.collect({ arg item; spec.map(item) }), gui[\windows, \attr, attr, type, dataType, \recTimes, typeIndex], 'lin');
							
						});
					}
				)
			});

						
			gui[\windows, \attr, attr, type, dataType, envType, \curveObj] = curveObj;
			gui[\windows, \attr, attr, type, dataType, envType, \envView]  = envView;

			
			//envView.refresh
			
		};
		
		buildAttrCompileView = {arg view, attr, type, width, height, currentAttrViewIndex;
			
			var textView, submit;
			
			submit = SCButton(view, Rect(0, 0, 100, objHeight));
			submit.states = [ [ "Submit", color[\black], color[\red] ] ];
			submit.action = {
				cloud.instVarAt(type)[attr] = gui[\windows, \attr, attr, type, \CompileString, \textView].string.interpret ? "Error";
				"Compile String Submitted".inform;
			};
			
			if(currentAttrViewIndex == 2, {
				buildAttrTextView.value(attr, type, width - 20, height - 40);
			});

			
		};
		
		buildAttrTextView = { arg attr, type, width=650, height=180;
		
			gui[\windows, \attr, attr, type, \CompileString, \textView] = 
				buildTextView.value(
					gui[\windows, \attr, attr, type, \views, \CompileString], 
					width, 
					height, 
					cloud.instVarAt(type)[attr].asCompileString, 
					{}
				);
				
			gui[\windows, \attr, attr, type, \views, \CompileString].decorator.nextLine.shift(0, height.neg - 3);
			
		};
		
		envToTimes = { arg array;
			var sum = 0;
			([ 0 ] ++ array.copy.collect({ arg item; sum = sum + item })) / getDur.value;
		};
		
		timesToEnv = { arg array;
			Array.fill(array.size - 1, { arg i; array[i + 1] - array[i] }) * getDur.value;
		};
		
		syncAttrWindow = { arg attr;
		
		};
		
		buildAttrDisplayGrid = { arg view, attr, type, dataType, width;
		
			var spec, array, shift;
			
			spec  = if(type == \center, { cloud.centerSpec[attr] }, { cloud.devSpec[attr] });
			array = (0, 0.2 .. 1.0);
			shift = (width - (75 * array.size) - (3 * (array.size - 1))) / array.size;
		
			array.do({ arg item;
				 
				gui[\windows, \attr, attr, type, dataType, ("l" ++ item ++ "Label").asSymbol] = 
					buildLabel.value(view, 75,
					 	spec.constrain(spec.map(item)).round(spec.maxval/10000).asString,
						color[\white],	
						\center
				);
				
				view.decorator.shift(shift, 0);
			
			})

		};
		
		buildVerticalAttrDisplayGrid = { arg view, attr, type, dataType, width, height;
			
			var spec, array, shift, gridView;
			
			spec = if(type == \center, { cloud.centerSpec[attr] }, { cloud.devSpec[attr] });
			array = (0, 0.2 .. 1.0).reverse;
			shift = (height - 6  - (array.size * objHeight) - (3 * (array.size - 1))) / array.size;
			gridView =  SCCompositeView(view, Rect(0, 0, width, height));
			gridView.decorator_( FlowLayout(gridView.bounds, Point(3, 3), Point(3, 3)));
			gridView.background_(color[\green]);

			array.do({ arg item;
			
				gui[\windows, \attr, attr, type, dataType, ("l" ++ item ++ "Label").asSymbol] = 
					buildLabel.value(gridView, width - 6,
						spec.constrain(spec.map(item)).round(spec.maxval/10000).asString,
						color[\white],
						\right
				);
				
				gridView.decorator.nextLine.shift(0, shift);
				
			})
			
		};

	
		///// SYNC AND INITIALIZATION FUNCTIONS /////
		sync = { arg syncObj;
			// sync the gui variables to those of another gui in syncObj
			name  = syncObj.name;
			gui[\window].name = "GranCloud: " ++ name;
			cloud = syncObj.cloud;
			syncCloud.value(true);
		};
		
		syncCloud = { arg rebuildViews;
		
			// this may have been done before in some cases, but just to make sure
			this.init;
		
			// sync the gui variable to the state of the cloud
			gui[\playTimeNumberBox].value = cloud.playTime;
			gui[\durationNumberBox].value = cloud.duration;
			gui[\scrubSlider].value = gui[\playTimeNumberBox].value /  getDur.value;

			if(cloud.loopAll.notNil, {
				gui[\loopCheckBox].value          = 1;
				gui[\loopStartNumberBox].value    = cloud.loopAll[0];
				gui[\loopStopNumberBox].value     = cloud.loopAll[1];
				gui[\loopNumTimesNumberBox].value = cloud.loopAll[2];
			}, {
				gui[\loopCheckBox].value          = 0;
				gui[\loopStartNumberBox].value    = "";
				gui[\loopStopNumberBox].value     = "";
				gui[\loopNumTimesNumberBox].value = "";
			});
			
			if(rebuildViews, {
				buildViews.value;
			});			
			updateDisplay.value;

			if(currentViewIndex == 0, {
								
				cloud.order.do({ arg attr;
					if(cloud.loop[attr].isNil, {
						gui[\main, \attr, attr, \loopCheckBox].value = 0;
						gui[\main, \attr, attr, \loopStartNumberBox].value = "";
						gui[\main, \attr, attr, \loopStopNumberBox].value  = "";
						gui[\main, \attr, attr, \loopNumTimesNumberBox].value = "";
					}, {
						gui[\main, \attr, attr, \loopCheckBox].value = 1;
						gui[\main, \attr, attr, \loopStartNumberBox].value = 
							cloud.loop[attr][0];
						gui[\main, \attr, attr, \loopStopNumberBox].value  = 
							cloud.loop[attr][1];
						gui[\main, \attr, attr, \loopNumTimesNumberBox].value = 
							cloud.loop[attr][2];
					});
					
//					if(cloud.spec[attr].isNil, {
//						// here we must have a spec, use a default
//						cloud.spec[attr] = [ 0, 1, 'lin', 0, 0, "" ].asSpec;
//					});
					gui[\main, \attr, attr, \minNumberBox].value = cloud.spec[attr].minval;
					gui[\main, \attr, attr, \maxNumberBox].value  = cloud.spec[attr].maxval;
					gui[\main, \attr, attr, \warpTextField].string = cloud.spec[attr].warp.asSpecifier.asString;
					
					gui[\main, \attr, attr, \stepNumberBox].value = cloud.spec[attr].step;
					//gui[\main, \attr, attr, \defaultNumberBox].value = 
						cloud.spec[attr].default;
					gui[\main, \attr, attr, \unitsTextField].string  = 
						cloud.spec[attr].units.asString;
				})
			});
			
			gui[\window].refresh;
			
		};
		
		// this just update values that change as time is changed
		updateDisplay = { 
			updateAttrRowDisplay.value
		};
				
		updateAttrRowDisplay = { 
			var relTime, attrRelTime;
			
			if(currentViewIndex == 0, {
				// sync the attr row values
				
				if(cloud.isPlaying.not, {
					cloud.nextGrainArgs(cloud.playTime);
				});
				
				cloud.order.do({ arg attr;
										
					gui[\main, \attr, attr, \currStateNumberBox].value = cloud.grainArgs[attr];
					gui[\main, \attr, attr, \centerNumberBox].value = cloud.centerArgs[attr];
					gui[\main, \attr, attr, \centerTypeLabel].string = 
						cloud.center[attr].class.asString.copyRange(0, 7);
					gui[\main, \attr, attr, \devNumberBox].value = cloud.devArgs[attr];
					gui[\main, \attr, attr, \devTypeLabel].string = 
						cloud.dev[attr].class.asString.copyRange(0, 7);
					
				});
			});
		};
		
		updateTime = { arg time;
			var envView;
			gui[\playTimeNumberBox].value = time;
			gui[\scrubSlider].value = time / getDur.value;
			if(gui[\windows, \attr].notNil, {
				gui[\windows, \attr].keysValuesDo({ arg attr;
					gui[\windows, \attr, attr, \playTimeNumberBox].value = time;
					gui[\windows, \attr, attr, \scrubSlider].value = gui[\scrubSlider].value;
					[ \center, \dev ].do({ arg type;
						envView = gui[\windows, \attr, attr, type, \Env, \table, \envView];
						if(envView.notNil, { 
							envView.index = ( envView.size * gui[\scrubSlider].value ).asInteger;
							
						})
					})
				})
			})
		};
		
		// Start her up
		buildMainWindow.value;	
		
	}



}
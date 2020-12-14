
server already running
internal
ERROR: Primitive '_SCView_New' failed.
Operation cannot be called from this Process. Try using AppClock instead of SystemClock.
RECEIVER:
Instance of SCTopView {    (0x109e2b2a8, gc=F8, fmt=00, flg=00, set=05)
  instance variables [18]
    dataptr : nil
    parent : nil
    action : nil
    background : instance of Color (0x10e4f6968, size=4, set=2)
    mouseDownAction : nil
    mouseUpAction : nil
    mouseOverAction : nil
    mouseMoveAction : nil
    keyDownAction : nil
    keyUpAction : nil
    keyTyped : nil
    keyModifiersChangedAction : nil
    beginDragAction : nil
    canReceiveDragHandler : nil
    receiveDragHandler : nil
    onClose : nil
    children : nil
    decorator : nil
}
CALL STACK:
	MethodError:reportError   0x10a06fee8
		arg this = <instance of PrimitiveFailedError>
	Nil:handleError   0x107593a18
		arg this = nil
		arg error = <instance of PrimitiveFailedError>
	Thread:handleError   0x107301418
		arg this = <instance of Thread>
		arg error = <instance of PrimitiveFailedError>
	Thread:handleError   0x107495c18
		arg this = <instance of Routine>
		arg error = <instance of PrimitiveFailedError>
	Object:throw   0x10a045518
		arg this = <instance of PrimitiveFailedError>
	Object:primitiveFailed   0x108755d38
		arg this = <instance of SCTopView>
	SCView:init   0x109f81808
		arg this = <instance of SCTopView>
		arg argParent = nil
		arg argBounds = <instance of Rect>
	SCContainerView:init   0x10e3fec38
		arg this = <instance of SCTopView>
		arg argParent = nil
		arg argBounds = <instance of Rect>
	SCWindow:initSCWindow   0x10f7c0248
		arg this = <instance of SCWindow>
		arg argName = 'window'
		arg argBounds = <instance of Rect>
		arg resizable = true
		arg border = true
		arg scroll = false
		arg appmodal = false
	Khora:init   0x10f9fbaa8
		arg this = <instance of Khora>
		arg cnt = 100
		arg bnds = <instance of Point>
		arg bgCol = <instance of Color>
		arg doClr = true
		arg fllScrn = false
	< FunctionDef in closed FunctionDef >   0x10f785868
		var bgColor = <instance of Color>
		var doClear = true
		var fullScreen = false
		var count = 100
		var bounds = <instance of Point>
	Routine:prStart   0x10a4b9c08
		arg this = <instance of Routine>
		arg inval = -7.6273999866316e-05
For advice: [http://supercollider.sf.net/wiki/index.php/PrimitiveFailedError]
ERROR: Message 'maxCnt' not understood.
RECEIVER:
   nil
ARGS:
PATH: /Users/jameswatkins/Repositories/cosmognosis/graphicsOnlyBroken.scd

PROTECTED CALL STACK:
	Meta_MethodError:new	0x1071291c0
		arg this = DoesNotUnderstandError
		arg what = nil
		arg receiver = nil
	Meta_DoesNotUnderstandError:new	0x10712b0c0
		arg this = DoesNotUnderstandError
		arg receiver = nil
		arg selector = maxCnt
		arg args = [  ]
	Object:doesNotUnderstand	0x1058b9380
		arg this = nil
		arg selector = maxCnt
		arg args = nil
	a FunctionDef	0x10f954df8
		sourceCode = <an open Function>
	Routine:prStart	0x1066ae140
		arg this = a Routine
		arg inval = 1832.542221277

CALL STACK:
	DoesNotUnderstandError:reportError   0x10a002368
		arg this = <instance of DoesNotUnderstandError>
	< closed FunctionDef >   0x10a005388
		arg error = <instance of DoesNotUnderstandError>
	Integer:forBy   0x10f7b9248
		arg this = 0
		arg endval = 2
		arg stepval = 2
		arg function = <instance of Function>
		var i = 0
		var j = 0
	SequenceableCollection:pairsDo   0x105af74f8
		arg this = [*4]
		arg function = <instance of Function>
	Scheduler:seconds_   0x108750628
		arg this = <instance of Scheduler>
		arg newSeconds = 1832.552397735
	Meta_AppClock:tick   0x1078e53f8
		arg this = <instance of Meta_AppClock>
		var saveClock = <instance of Meta_SystemClock>
	Process:tick   0x105a99388
		arg this = <instance of Main>
For advice: [http://supercollider.sf.net/wiki/index.php/DoesNotUnderstandError#maxCnt]
ERROR: Message 'animae' not understood.
RECEIVER:
   nil
ARGS:
PATH: /Users/jameswatkins/Repositories/cosmognosis/graphicsOnlyBroken.scd

PROTECTED CALL STACK:
	Meta_MethodError:new	0x1071291c0
		arg this = DoesNotUnderstandError
		arg what = nil
		arg receiver = nil
	Meta_DoesNotUnderstandError:new	0x10712b0c0
		arg this = DoesNotUnderstandError
		arg receiver = nil
		arg selector = animae
		arg args = [  ]
	Object:doesNotUnderstand	0x1058b9380
		arg this = nil
		arg selector = animae
		arg args = nil
	a FunctionDef	0x10f648338
		sourceCode = <an open Function>
	Float:do	0x1062acb00
		arg this = inf
		arg function = a Function
		var i = 0
	Routine:prStart	0x1066ae140
		arg this = a Routine
		arg inval = 1832.542239749

CALL STACK:
	DoesNotUnderstandError:reportError   0x10879a4b8
		arg this = <instance of DoesNotUnderstandError>
	< closed FunctionDef >   0x109fab788
		arg error = <instance of DoesNotUnderstandError>
	Integer:forBy   0x10f7b9248
		arg this = 0
		arg endval = 2
		arg stepval = 2
		arg function = <instance of Function>
		var i = 2
		var j = 1
	SequenceableCollection:pairsDo   0x105af74f8
		arg this = [*4]
		arg function = <instance of Function>
	Scheduler:seconds_   0x108750628
		arg this = <instance of Scheduler>
		arg newSeconds = 1832.552397735
	Meta_AppClock:tick   0x1078e53f8
		arg this = <instance of Meta_AppClock>
		var saveClock = <instance of Meta_SystemClock>
	Process:tick   0x105a99388
		arg this = <instance of Main>
For advice: [http://supercollider.sf.net/wiki/index.php/DoesNotUnderstandError#animae]


-----------------
Dealing with large projects


There comes a point with SuperCollider when your code begins to grow and grow


If you find yourself writing one huge file for your piece, you must start to consider spreading work over multiple files.






























You can bring in further files within the current one:

Create a file called extrafile.rtf by making a new window and copying in the following code

{SinOsc.ar(440,0,0.1)}.play

then save the file in your SuperCollider application directory under that name. 

Now run

"extrafile.rtf".loadPath; //after creating extrafile.rtf

which runs the interpreter on that file:

//put in appropriate pathname
thisProcess.interpreter.executeFile("extrafile.rtf");
 
This is often useful in particular for loading large datasets. There are also specific file reading and writing capabilities (ie File, see the main help page).
 
In terms of breaking up complex programs, a better approach is to use classes. You should always aim to encapsulate and modularise re-usable code. See the tutorial chapters on writing classes, and read up on object-oriented design. 





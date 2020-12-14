
-----------------
Global variables and Environments

The interpreter provides a-z for free

a=9;

This is not recommended for anything other than simple code because it is too easy to overwrite contents accidentally, say by running multiple patches which use such variables. 

(
var a;

a=9; //sets local a, NOT global
)

would have a variable called a which remains local to the patch scope without overwriting the global. 

You should never use these variables for large projects, though they are occasionally helpful for small short examples.



















There is another place global data might be stored. 

The currentEnvironment is a special collection which can be used as a big storage space for name tagged data- see the [Environment] help file.

currentEnvironment; //run this line to the current state of the currentEnvironment

You use the currentEnvironment via the ~ sign

~myvar= 0.9;

The ~ and = is a shortcut here for 

currentEnvironment.put(\myvar, 0.9);

You can access the variable wherever you need it by 

~myvar

Which is the same as 

currentEnvironment.put(\myvar, 0.9);











The currentEnvironment uses a special collection called an IdentityDictionary. 

The shortcut to make one in SuperCollider is

a= (); //make a new IdentityDictionary

a.put(\hello, 67)

a.at(\hello)

b= (a:8, fortune:"darmstadt", hello:10); //shortcut to set one up















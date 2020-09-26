(some suggestion without digging very deep into your code...)

did you look at the the sort of universal perform method. Êhere are two examples...
a= \yellow;
Color.perform(a)
a= \rand;
Color.perform(a)

so using this trick you could just save the strategies as symbols and call the corresponding method when you update each particle. Êsomething like this...
//anima.strategy= \fall;
move {
Ê Ê Ê Êposition= Strategy.perform(strategy, this);
}


or, as i do it in my redUniverse system, use functions. Êeach particle have a variable set to whatever strategy function. Êsay we have these two...
riseStratFunc= {|part| part.position= part.position+Point(0, 1)};
fallStartFunc= {|part| part.position= part.position+Point(0, -1)};

and then you assign one of them to a particle...
anima.strategy= riseStratFunc;

last you just call with .value whichever stored function and pass along this as an argument...
move {
Ê Ê Ê Êposition= strategy.value(this);
}


the reason your setup isn't working i believe is because of this...
> tempPart=strategy(this);

what you've stored in the strategy variable is the result of Strategy.rise, and then you're trying to call () on that - which doesn't make sense. Êyou'll need some kind of selector here like strategy.value(this) for functions or Strategy.perform(strategy) for the perform trick. Êa dictionary lookup would also work. Êdict[strategy].value(this) for example if you have symbol-function pairs stored in the dict.


and i'd stay away from letting Strategy modify the particles. Êdon't know but just a gut feeling. Êso things like this...
> //thisPart.postition.set(thisPart.position.x, thisPart.position.y + 1);

i'd code differently letting the Anima class do the updating of it's own variables. Êthe Strategy class would in this case work more like a calculator for the next position. Êso from inside Anima i'd ask the Strategy class... here's where i'm at (giving it position as an argument), now figure out where my next position will be and return that as a point.

//pseudocode
Anima {
Ê Ê Ê Êmove {
Ê Ê Ê Ê Ê Ê Ê Êthis.position= Strategy.perform(this.strategy, this.position);
Ê Ê Ê Ê}
}

or if you go the function route...
Anima {
Ê Ê Ê Êmove {
Ê Ê Ê Ê Ê Ê Ê Êthis.position= this.strategy.value(this.position);
Ê Ê Ê Ê}
}

hope that helped somewhat and wasn't too confusing. Êthere are other ways to do it as well.
_f

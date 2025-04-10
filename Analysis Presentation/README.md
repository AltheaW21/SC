# Analysis Presentation

For my analysis project I'm working on analysing Tara Rodgers's piece "Butterfly Effects". According to [her website](https://www.analogtara.net/butterfly-effects/), this piece's structure "is derived from behavioral aspects and ecosystem dynamics of migratory monarch butterflies", and the snippet of code provided that I will be analyzing is an interpretation of one of these behavioral aspects. She describes the codes function as: "circadian routine: controls timing of events in overall composition, and triggers sun, light & cricket synths." What this means is that different synths and functions are triggered based on the time of "day" as defined by the code, which we will get into later. The synthesized butterflys do different things at different times of day, and the crickets only make sounds based on the time of day and certain weather conditions, just like in real life. 

First, Tara defines her variables: 

`~circadian = Routine({
	~flapping.play; ~flapping.reset;
	~daylight=12;
	~sunrise=6;
	~dayNum=1;`
	
I learned that tildes in SuperCollider can be used to define global variables and functions. The variable "circadian" is established to be a Routine. According to the [Supercollider help page](https://doc.sccode.org/Classes/Routine.html), "A Routine runs a Function and allows it to be suspended in the middle and be resumed again where it left off." You can pause the circadian routine, and instead of starting from day 1 when you start it again, it goes from whichever day it was paused on. the dayNum variable is described as a counter of days, starting at day 1. 

	inf.do({
		"day ".post; ~dayNum.post; " hour ".post; ~i.postln;
		if ( ~i == 23, { ~i=0; dayNum=~dayNum+1 })
		
In this piece of code, for as long as the code is running, SuperCollider will print the day and the hour according to the counter, so the viewer will be able to see the day and time. The if statement shows that if global variable i gets to 23, or the end of the day, the hour will reset, and the day counter will change the number of the day by the value of 1. For example, if it reaches 23 hours on day 3, the hour counter will reset to 0 and the day counter will display day 4. 

`case
{ (~i<= ~sunrise) || (~i> (~daylight + ~sunrise)) }
{ ~night.play; ~nightTime = true; ~night.reset }
{ (~i> ~sunrise) && (~i<= (~daylight + ~sunrise)) }
{ ~day.play; ~nightTime = false; ~day.reset }
;`

According to the [SuperCollider help page](https://depts.washington.edu/dxscdoc/Help/Reference/Control-Structures.html), a case statement is a type of function method "which allows for conditional evaluation with multiple cases. Since the receiver represents the first case this can be simply written as pairs of test functions and corresponding functions to be evaluated if true." In other words, it functions very similarly to nested if statements, but does so more elegantly. This case determines whether it is daytime or nightime. If the hour is less than or equal to 6, (see first block of variable defining code) OR if the hour is greater than 18 (12+6, see variable defining block again) (6pm), it is considered nighttime. If the inverse is true, it is daytime. I wondered if this could've been done with an if/else statement, but I think it would be more difficult to implemenet if sunrise and daylight variables were set to different values, say, like if Tara decided this code was running in winter versus summer.

`case
{ ~i == 4 } { ~conserve.play; ~conserve.reset }
{ ~i == 10} { ~disperse.play; ~disperse.reset }
{ ~i == (~sunrise+6) } { ~light.play; ~light.reset }
{ ~i == 13 } { ~fly.play; ~fly.reset }
;`

This one triggers synths and/or functions (hard to tell because these are not defined in this block of code) based on which hour it is. At 4, "conserve" is executed, at 10, "disperse", etc. I was wondering why in all these cases the variables must be played and then reset. I assume this is so they don't keep playing indefinitely, and because this is a Routine, SuperCollider can constantly check whether these cases are true.

`case
{ (~raining == false) && ( (~i == 2) || (~i == 20) || (~i == 22)) }
{ ~crix.play; "not raining, crickets start".postln; ~crix.reset }
{ (~i == 5 && ~crix.isPlaying == true) || ((~raining == true) && ~crix.isPlaying == true) }
{ ~crix.stop; "crickets stop".postln}
;`

This block is all about triggering the cricket synth. According to this code, crickets play whenever it is not raining and the hour is 2, 20, or 22. They stop playing when the hour is five, or if it starts raining.

`~hr.wait;
~i=~i+1;
)}
)}.play;``

This just wraps up Tara's code, and plays it. This is the counter that determines which hour it is. I assume there is a seperate function outside of this excerpt that determines how long an hour lasts, but this code waits until the hour is changed to up the ~i hour counter.

Pretty cool!
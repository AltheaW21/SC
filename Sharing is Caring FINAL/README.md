# Sharing is Caring Final Project

My concept for this project was to use SuperCollider as a compositional tool. The performer of my piece would be experimenting with launching variations of a main sequence in different combinations, and using modulating effects to add depth and orchestrational effects.

The first thing I had to do was code a synth that would make my sequences audible. I started by coding a basic subtractive synthesizer, but it was pointed out to me that it would be much easier to add effects to an FM synth, because there's more interactive variables. This was my final synth: 

`SynthDef.new(\fmsynth, {
	arg freq=200, amp=0.5, atk=0.2, dec=0.3, fm1atk=0.0001, fm1dec=0.1, fmin=~modBusA, multin=~modBusB;
	var sig, op1, ampenv, fm1env, fmlfo, multlfo;
	multlfo=In.kr(multin, 1);
	fmlfo=In.kr(fmin, 1);
	fm1env = EnvGen.kr(Env.new([0,1,0],[fm1atk, fm1dec],-2));
	op1 = SinOsc.ar(freq*multlfo)*fmlfo;
	ampenv = EnvGen.kr(Env.new([0,1,0],[atk, dec],-2), doneAction: 2);
	sig = SinOsc.ar(freq*(op1+1))!2*ampenv*amp;
	Out.ar(0, sig);
}).add;`

I don't think that the fm1 envelope does anything, but this was a template for an FM synthesizer, and decided to keep it in case I wanted to add more operators later. What makes this a little different is that I replaced the FM amount variable with "fmlfo", and the ratio with "multlfo" because those are what I add effects to later. This will make more sense once I get to my modulator SynthDefs.

I then coded my original sequence, using a Pbind:

`a = Pbind(
	\scale, Scale.major(t),
	\degree, Pseq([1, 1, 1, 1, 2, 1, 2, 1, 2], inf),
	\dur, Pseq([0.2, 0.2, 0.2, 0.2, 0.5, 0.2, 0.5, 0.2, 1], inf),
	\instrument, \fmsynth,
).play;

a.stop;`

This sequence is based off of the Julius Eastman composition Femenine, which is what inspired me to make a project like this. Notice that I had to add to assign the Pbind to a variable and stop it within the same block of code. I put all the SynthDefs and Pbinds within the same parentheses so that the performer could launch them all without hassle. For some reason, I couldn't stop the Pbind outside of this code block unless I stopped it within as well. I don't know why that is.

The second Pbind is the same as the first, but they're able to be launched at different times, which I hope will produce an interesting phasing effect. For the third, I just put Prand instead of Pseq on both the degree and duration, which randomizes the sequence indefinitely. For the fourth, I used Prand on the values 1-5, but kept the duration the same Pseq as the original motif. My hope is that the performer will combine these different variations of the sequence in inventive ways. 

The hardest part of this project was coding the Mod Synths.

`SynthDef.new(\modA, {
	arg rate = 0.03, atk=0.2, dec, out=~modBusA;
	var lfo1, ampenv;
	lfo1 = SinOsc.kr(rate)*2;
	Out.kr(out, lfo1);
}).add;

SynthDef.new(\modB, {
	arg rate = 0.03, amp=5, out=~modBusB;
	var lfo1;
	lfo1 = SinOsc.kr(rate)*amp;
	lfo1=lfo1.round(1);
	Out.kr(out, lfo1);
}).add;`

They both use a basic lfo formula, but the first controls the FM amount and the second, the FM ratio. A lot of what made this difficult came down to bus allocation. The LFOs had to be sent to control busses instead of audio busses, so that they would affect the audio source without making sound of its own. In order to avoid accidentally overlapping busses, I made the busses equal to global variables:

`~modbusA=Bus.audio(s, 1);
~modbusB=Bus.audio(s, 1);`

After wondering why everything sounded awful for a while, I realized my mistake. By using Bus.audio instead of Bus.control, I was sending them to audio busses instead of private busses, even though they technically should've still been private busses. I don't know why that is. Regardless, I changed the syntax to Bus.control, and made two arguments in the original FM synth for fmin and multin, setting them equal to modbusA and modbusB. That way, these mod SynthDefs would actually affect the FM synth without having to launch them within the actual block of code that houses the FM synth.

To make this performable, I organized a performance block, that allows the player to launch all the Pbinds and modulators and stop them at their discretion.

Hope it sounds good!
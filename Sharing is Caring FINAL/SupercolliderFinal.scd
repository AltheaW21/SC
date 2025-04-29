s.plotTree;
s.meter;
//EXECUTE BEFORE PERFORMING

//FM synth
(
SynthDef.new(\fmsynth, {
	arg freq=200, amp=0.5, atk=0.2, dec=0.3, fm1atk=0.0001, fm1dec=0.1, fmin=~modBusA, multin=~modBusB;
	var sig, op1, ampenv, fm1env, fmlfo, multlfo;
	multlfo=In.kr(multin, 1);
	fmlfo=In.kr(fmin, 1);
	fm1env = EnvGen.kr(Env.new([0,1,0],[fm1atk, fm1dec],-2));
	op1 = SinOsc.ar(freq*multlfo)*fmlfo;
	ampenv = EnvGen.kr(Env.new([0,1,0],[atk, dec],-2), doneAction: 2);
	sig = SinOsc.ar(freq*(op1+1))!2*ampenv*amp;
	Out.ar(0, sig);
}).add;

//First sequence
a = Pbind(
	\scale, Scale.major(t),
	\degree, Pseq([1, 1, 1, 1, 2, 1, 2, 1, 2], inf),
	\dur, Pseq([0.2, 0.2, 0.2, 0.2, 0.5, 0.2, 0.5, 0.2, 1], inf),
	\instrument, \fmsynth,
).play;

a.stop;

//Second sequence
b = Pbind(
	\scale, Scale.major(t),
	\degree, Pseq([1, 1, 1, 1, 2, 1, 2, 1, 2], inf),
	\dur, Pseq([0.2, 0.2, 0.2, 0.2, 0.5, 0.2, 0.5, 0.2, 1], inf),
	\instrument, \fmsynth,
).play;

b.stop;

//Randomizes sequence
c = Pbind(
	\scale, Scale.major(t),
	\degree, Prand([1, 1, 1, 1, 2, 1, 2, 1, 2], inf),
	\dur, Prand([0.2, 0.2, 0.2, 0.2, 0.5, 0.2, 0.5, 0.2, 1], inf),
	\instrument, \fmsynth,
).play;

c.stop;

d = Pbind(
	\scale, Scale.major(t),
	\degree, Prand([1, 3, 5, 6], inf),
	\dur, Pseq([0.2, 0.2, 0.2, 0.2, 0.5, 0.2, 0.5, 0.2, 1], inf),
	\instrument, \fmsynth,
).play;

d.stop;

//First modulator synth
SynthDef.new(\modA, {
	arg rate = 0.03, atk=0.2, dec, out=~modBusA;
	var lfo1, ampenv;
	lfo1 = SinOsc.kr(rate)*2;
	Out.kr(out, lfo1);
}).add;

//Second modulator synth
SynthDef.new(\modB, {
	arg rate = 0.03, amp=5, out=~modBusB;
	var lfo1;
	lfo1 = SinOsc.kr(rate)*amp;
	lfo1=lfo1.round(1);
	Out.kr(out, lfo1);
}).add;
)

//Execute these after ONLY ONCE
~modbusA=Bus.control(s, 1);
~modbusB=Bus.control(s, 1);

//FOR PERFORMER

//Main motif - should begin and end the piece
a.play;
a.stop;

//Also the main motif - use this module to create new, phasing rhythms with the original motif
b.play;
b.stop;

//Randomizes original sequence
c.play;
c.stop;

//Random pitches NOT in sequence, same duration as original sequence
d.play;
d.stop;

//FM amount modulator - applies to all sequences: WARNING: sequence will continue at FM amount you stop at
l = Synth.new(\modA, addAction: \addToTail);
l.free;

//FM ratio step modulator - Same warning applies.
m = Synth.new(\modB, addAction: \addToTail);
m.free;
# 140 Character Assignment

Bear with me on this one because I had a lot of trouble with this assignment!

This was my final code: 
 
`{FreeVerb.ar(LFPulse.ar(LFNoise0.kr(4).exprange(200,800).round(75), 0, 0.25, 0.75), 0.75)+(WhiteNoise.ar(SinOsc.kr(0.05))*0.5)}.play;`
 
 Starting to the left of the "+", I wanted to create a square wave that looped random pitches. To do that, I made first made a square wave with the UGen LFPulse and had to figure out how to make random frequencies. I decided on using the UGen LFNoise0 to do so, and remembered to set it to a control rate instead of an audio rate, because it was controlling frequencies. I had it generate a new frequency every quarter note. At this point, I had this code:
 
`(LFPulse.ar(LFNoise0.kr(4))`

I now had to decide parameters, and picked frequencies between 200 and 800Hz. Instead of using .range, I used .exprange to get a more even distribution of values. That left me with this:

`(LFPulse.ar(LFNoise0.kr(4).exprange(200,800))`

This was all fine and good, but a lot of my values sounded too close together and I wanted to make them more distinct, so I added a .round parameter so that they'd round to distinct values. After experimenting with rounding to different values, I decided to round to multiples of 75Hz, giving me this code:

`(LFPulse.ar(LFNoise0.kr(4).exprange(200,800).round(75))`

This sounded kind of terrible, so I wanted to change the width of my square wave as well as the amplitude. I decided on a width of 0.25 and an amplitude of 0.75:

`(LFPulse.ar(LFNoise0.kr(4).exprange(200,800).round(75), 0, 0.25, 0.75)`

I still had some characters left to experiment with, and my puny SuperCollider code and the effort it took to create it was making me kind of sad, so I thought to myself, "what would make me feel happier?" and it hit me: the ocean. I thought I'd code a sound that sounded like the tide coming in, because I have a microkorg patch I like that does that. Now we're working to the right of the "+". I started with a WhiteNoise UGen at audio rate:

`WhiteNoise.ar()`

Because it's meant to emulate an ocean wave, I set the amplitude to a SinOsc UGen at a very slow rate, that I experimented with, and landed on 0.05:

`(WhiteNoise.ar(SinOsc.kr(0.05))`

Now the problem was that it was super loud compared to my square wave, so I cut the amplitude of the SinOsc in half (and remembered I could do so with a handy "*" outside the parentheses!)

`(WhiteNoise.ar(SinOsc.kr(0.05))*0.5)`

I put them together with a handy trick I learned from the ["micromoog" SuperCollider tweet:](https://ccrma.stanford.edu/wiki/SuperCollider_Tweets#micromoog) the aforementioned "+":

`(LFPulse.ar(LFNoise0.kr(4).exprange(200,800).round(75), 0, 0.25, 0.75)+(WhiteNoise.ar(SinOsc.kr(0.05))*0.5)`

I still had some characters to experiment with so I threw a reverb on there to hopefully make it sound better:

`{FreeVerb.ar((LFPulse.ar(LFNoise0.kr(4).exprange(200,800).round(75), 0, 0.25, 0.75), 0.75)+(WhiteNoise.ar(SinOsc.kr(0.05))*0.5))}`

Now my code didn't work and I couldn't figure out why! Then I realized putting the white noise inside the reverb using the "+" made it think that whatever code came after the "+" was a displacement parameter. I figured the ocean sound didn't need reverb, so I put it outside the reverb: 

`{FreeVerb.ar(LFPulse.ar(LFNoise0.kr(4).exprange(200,800).round(75), 0, 0.25, 0.75), 0.75)+(WhiteNoise.ar(SinOsc.kr(0.05))*0.5)}`

I wanted the room to sound a little bigger so I set the room parameter to 0.75:

`{FreeVerb.ar(LFPulse.ar(LFNoise0.kr(4).exprange(200,800).round(75), 0, 0.25, 0.75), 0.75)+(WhiteNoise.ar(SinOsc.kr(0.05))*0.5)}`

Add a .play function to that and you have something that sounds like a very dinky day at the beach!
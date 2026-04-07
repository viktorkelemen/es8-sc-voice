// ES-8 Crush — bitcrushed FM with sample rate reduction
// Digital destruction, aliasing as timbre
//
// ES-8 Input 1 (bus 8): Gate/Trigger
// ES-8 Input 2 (bus 9): V/Oct Pitch CV
// ES-8 Output 1 (bus 0): Audio out

// ---- SYNTHDEF ----
(
SynthDef(\es8_crush, {
    arg out = 0, amp = 0.4;
    var pitch, trig, freq, gate;
    var fm, crushed, decimated, sig;

    pitch = In.ar(9);
    trig = In.ar(8);
    freq = 200 + (pitch * 3000);
    gate = Schmidt.ar(trig, 0.1, 0.2);

    // 2-op FM base
    fm = SinOsc.ar(freq + SinOsc.ar(freq * 3.51, mul: freq * 2));

    // Bitcrush — quantize amplitude
    crushed = (fm * 8).round(1) / 8;

    // Sample rate reduction — aliasing
    decimated = Latch.ar(fm, Impulse.ar(freq * 6));

    // Ring mod the two destructions
    sig = (crushed * 0.5) + (decimated * 0.3) + (crushed * decimated * 0.2);
    sig = sig.clip(-0.95, 0.95);
    sig = sig * gate * amp;

    Out.ar(out, sig);
}).add;
)

// ---- PLAY ----
x = Synth(\es8_crush);

// ---- STOP ----
x.free;

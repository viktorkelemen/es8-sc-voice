// ES-8 Glass — brittle additive/FM hybrid
// Rapidly decaying harmonics, bell-like partials, phase interference
//
// ES-8 Input 1 (bus 8): Gate/Trigger
// ES-8 Input 2 (bus 9): V/Oct Pitch CV
// ES-8 Output 1 (bus 0): Audio out

// ---- SYNTHDEF ----
(
SynthDef(\es8_glass, {
    arg out = 0, amp = 0.4;
    var pitch, trig, freq, gate;
    var partials, fm, phase, sig;

    pitch = In.ar(9);
    trig = In.ar(8);
    freq = 200 + (pitch * 3000);
    gate = Schmidt.ar(trig, 0.1, 0.2);

    // Additive partials at prime ratios — inharmonic bell
    partials = SinOsc.ar(freq * 1.0, SinOsc.ar(freq * 2.01, mul: 0.3))
        + SinOsc.ar(freq * 3.03, SinOsc.ar(freq * 5.07, mul: 0.5)) * 0.6
        + SinOsc.ar(freq * 7.11) * 0.3
        + SinOsc.ar(freq * 11.13) * 0.15
        + SinOsc.ar(freq * 13.17) * 0.08;

    // Phase modulated carrier — glassy
    phase = SinOsc.ar(freq * 0.999, SinOsc.ar(freq * 1.001, mul: pi));
    fm = SinOsc.ar(freq + SinOsc.ar(freq * 4.01, mul: freq * 0.5));

    sig = (partials * 0.4) + (phase * 0.35) + (fm * 0.25);
    sig = sig.clip(-0.95, 0.95);
    sig = sig * gate * amp;

    Out.ar(out, sig);
}).add;
)

// ---- PLAY ----
x = Synth(\es8_glass);

// ---- STOP ----
x.free;

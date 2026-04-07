// ES-8 Additive Down — 16 sines with sweeping filter and comb resonance
// Inspired by additiveDown SynthDef — adapted for ES-8 modular control
//
// ES-8 Input 1 (bus 8): Gate/Trigger
// ES-8 Input 2 (bus 9): V/Oct Pitch CV
// ES-8 Output 1 (bus 0): Audio out

// ---- SYNTHDEF ----
(
SynthDef(\es8_additive_down, {
    arg out = 0, amp = 0.2;
    var pitch, trig, freq, gate;
    var ratios, snd;

    pitch = In.ar(9);
    trig = In.ar(8);
    freq = (200 + (pitch * 3000)).clip(30, 8000);

    gate = Schmidt.ar(trig, 0.1, 0.2);
    gate = Lag.ar(gate, 0.02);

    ratios = [0.5, 0.75, 1, 1.5, 2, 2.5, 3, 4, 5, 6, 7, 8, 10, 12, 15, 20];
    snd = SinOsc.ar(freq * ratios);
    snd = snd.sum / 16;

    snd = RLPF.ar(snd, LFSaw.ar(0.2, 1).range(200, 3000), 0.4);

    snd = snd + (CombC.ar(snd, 0.05, (1 / freq).clip(0.001, 0.05), 0.06) * 0.2);

    snd = LeakDC.ar(snd);
    snd = snd.tanh;
    snd = snd * gate * amp;

    Out.ar(out, snd);
}).add;
)

// ---- PLAY ----
x = Synth(\es8_additive_down);

// ---- STOP ----
x.free;

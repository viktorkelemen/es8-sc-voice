// ES-8 Swarm — dense microdetuned oscillator cloud
// 12 detuned sines that beat against each other, phasing texture
//
// ES-8 Input 1 (bus 8): Gate/Trigger
// ES-8 Input 2 (bus 9): V/Oct Pitch CV
// ES-8 Output 1 (bus 0): Audio out

// ---- SYNTHDEF ----
(
SynthDef(\es8_swarm, {
    arg out = 0, amp = 0.4;
    var pitch, trig, freq, gate;
    var ratios, sig;

    pitch = In.ar(9);
    trig = In.ar(8);
    freq = 200 + (pitch * 3000);
    gate = Schmidt.ar(trig, 0.1, 0.2);

    // 12 slightly detuned sines — beating swarm
    sig = SinOsc.ar(freq * 0.993)
        + SinOsc.ar(freq * 0.996)
        + SinOsc.ar(freq * 0.999)
        + SinOsc.ar(freq * 1.001)
        + SinOsc.ar(freq * 1.004)
        + SinOsc.ar(freq * 1.007)
        + SinOsc.ar(freq * 1.993)
        + SinOsc.ar(freq * 2.003)
        + SinOsc.ar(freq * 2.997)
        + SinOsc.ar(freq * 3.005)
        + SinOsc.ar(freq * 4.994)
        + SinOsc.ar(freq * 5.008);

    sig = sig * 0.083;

    // Soft fold for density
    sig = (sig * 2).fold(-1, 1);

    sig = sig * gate * amp;

    Out.ar(out, sig);
}).add;
)

// ---- PLAY ----
x = Synth(\es8_swarm);

// ---- STOP ----
x.free;

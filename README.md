# sml-acoustics

Zero-dependency Standard ML library for room acoustics and audio signal-level calculations.

## API

```sml
signature ACOUSTICS =
sig
  val dbFromAmplitude : real -> real   (* 20·log10(ratio) *)
  val amplitudeFromDb : real -> real   (* 10^(dB/20) *)
  val dbFromPower     : real -> real   (* 10·log10(ratio) *)
  val powerFromDb     : real -> real   (* 10^(dB/10) *)

  val splFromPressure : {pPa:real, prefPa:real} -> real
  val pressureFromSpl : {splDb:real, prefPa:real} -> real

  val aWeighting : real -> real   (* fHz -> dB *)
  val cWeighting : real -> real   (* fHz -> dB *)

  val sabineRT60  : {volumeM3:real, totalAbsorptionSabins:real} -> real
  val eyringRT60  : {volumeM3:real, surfaceM2:real, avgAbsorption:real} -> real

  val inverseSquareSpl : {splRef:real, dRef:real, d:real} -> real

  val speedOfSoundAir : real -> real   (* tC -> m/s *)
end
```

## Usage example

```sml
(* Sound pressure level of 1 Pa relative to 20 µPa reference *)
val spl = Acoustics.splFromPressure {pPa=1.0, prefPa=20.0e~6}
(* ~93.98 dB SPL *)

(* Sabine reverberation time for a 1000 m³ room with 200 sabins *)
val rt60 = Acoustics.sabineRT60 {volumeM3=1000.0, totalAbsorptionSabins=200.0}
(* ~0.805 s *)

(* Speed of sound at room temperature *)
val sos = Acoustics.speedOfSoundAir 20.0
(* ~343 m/s *)
```

## Example

`make example` builds and runs [`examples/demo.sml`](examples/demo.sml), which
exercises dB/amplitude and dB/power round-trips, sound pressure level
conversions, A/C-weighting at two frequencies, Sabine/Eyring reverberation
time, the inverse-square law, and the speed of sound in air (output is
byte-identical under MLton and Poly/ML):

```
=== sml-acoustics demo ===

dB <-> amplitude/power round-trips:
  dbFromAmplitude 2.0        = 6.021 dB
  amplitudeFromDb (above)    = 2.000
  dbFromPower 2.0            = 3.010 dB
  powerFromDb (above)        = 2.000

Sound pressure level (1 Pa relative to 20 uPa reference):
  splFromPressure            = 93.979 dB SPL
  pressureFromSpl (above)    = 1.000000 Pa

Frequency weighting (dB relative to 1 kHz):
  aWeighting 1000.0 Hz       = 0.000 dB
  aWeighting 100.0 Hz        = -19.145 dB
  cWeighting 1000.0 Hz       = 0.000 dB
  cWeighting 100.0 Hz        = -0.300 dB

Reverberation time (1000 m^3 room):
  sabineRT60 (200 sabins)    = 0.805 s
  eyringRT60 (600 m^2, a=0.2)= 1.203 s

Inverse-square law and speed of sound:
  inverseSquareSpl 90dB@1m->10m = 70.000 dB
  speedOfSoundAir 20.0 C     = 343.215 m/s
```

## Scope and limitations

- dB, SPL, A/C-weighting, Sabine/Eyring RT60, inverse-square law, and speed of sound.
- Does not cover MIDI, musical temperament, or pitch ratios (see sml-music).
- A-weighting and C-weighting use the IEC 61672 analytic formulas; no filter coefficients.
- Speed-of-sound formula is for dry air; humidity and altitude are not modelled.

## Build and test

Requires [MLton](http://mlton.org/) and Poly/ML in PATH.

```
make all-tests
```

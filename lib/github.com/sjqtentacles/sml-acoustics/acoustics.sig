signature ACOUSTICS =
sig
  (* dB conversions *)
  val dbFromAmplitude : real -> real   (* 20*log10(ratio) *)
  val amplitudeFromDb : real -> real   (* 10^(dB/20) *)
  val dbFromPower     : real -> real   (* 10*log10(ratio) *)
  val powerFromDb     : real -> real   (* 10^(dB/10) *)

  (* Sound Pressure Level: pRef = 20e-6 Pa (default threshold of hearing) *)
  val splFromPressure : {pPa:real, prefPa:real} -> real  (* dB SPL *)
  val pressureFromSpl : {splDb:real, prefPa:real} -> real

  (* Frequency weighting (attenuation in dB relative to 1 kHz)
     A-weighting and C-weighting per IEC 61672 *)
  val aWeighting : real -> real   (* fHz -> dB *)
  val cWeighting : real -> real   (* fHz -> dB *)

  (* Reverberation time (seconds) *)
  val sabineRT60  : {volumeM3:real, totalAbsorptionSabins:real} -> real
  val eyringRT60  : {volumeM3:real, surfaceM2:real, avgAbsorption:real} -> real

  (* Inverse-square SPL: splRef at distance dRef, new distance d -> SPL in dB *)
  val inverseSquareSpl : {splRef:real, dRef:real, d:real} -> real

  (* Speed of sound in dry air at temperature tC (Celsius), m/s *)
  val speedOfSoundAir : real -> real
end

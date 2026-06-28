structure Tests =
struct
  open Harness
  fun close name (e, a, eps) = check name (Real.abs (e - a) <= eps)

  fun run () =
  let
    val () = section "dB conversions"
    val () = close "dB amp 10 = 20dB" (20.0, Acoustics.dbFromAmplitude 10.0, 1e~9)
    val () = close "dB amp 2 ~6.02dB" (6.021, Acoustics.dbFromAmplitude 2.0, 0.01)
    val () = close "amp from 20dB = 10" (10.0, Acoustics.amplitudeFromDb 20.0, 1e~9)
    val () = close "dB power 10 = 10dB" (10.0, Acoustics.dbFromPower 10.0, 1e~9)

    val () = section "SPL"
    (* 1 Pa -> SPL = 20*log10(1/20e-6) = 20*log10(50000) ~ 93.98 dB *)
    val spl = Acoustics.splFromPressure {pPa=1.0, prefPa=20.0e~6}
    val () = close "SPL 1Pa ~94dB" (93.98, spl, 0.1)
    val p = Acoustics.pressureFromSpl {splDb=spl, prefPa=20.0e~6}
    val () = close "pressure round-trip" (1.0, p, 1e~9)

    val () = section "A-weighting"
    val () = close "A-weight 1000Hz = 0dB" (0.0, Acoustics.aWeighting 1000.0, 0.01)
    val () = close "A-weight 100Hz < -18dB" (~19.1, Acoustics.aWeighting 100.0, 0.5)
    val () = check "A-weight 100Hz < A-weight 1000Hz"
               (Acoustics.aWeighting 100.0 < Acoustics.aWeighting 1000.0)

    val () = section "C-weighting"
    val () = close "C-weight 1000Hz = 0dB" (0.0, Acoustics.cWeighting 1000.0, 0.01)
    val () = check "C-weight at 10kHz < 0" (Acoustics.cWeighting 10000.0 < 0.0)

    val () = section "Sabine RT60"
    val rt = Acoustics.sabineRT60 {volumeM3=1000.0, totalAbsorptionSabins=200.0}
    val () = close "Sabine 1000/200" (0.805, rt, 0.01)

    val () = section "Eyring RT60"
    val rte = Acoustics.eyringRT60 {volumeM3=1000.0, surfaceM2=500.0, avgAbsorption=0.2}
    val () = check "Eyring > 0" (rte > 0.0)

    val () = section "inverse-square law"
    val spl2 = Acoustics.inverseSquareSpl {splRef=100.0, dRef=1.0, d=2.0}
    val () = close "inverse-square doubling" (93.979, spl2, 0.02)

    val () = section "speed of sound in air"
    val () = close "SoS at 0C ~331.3 m/s" (331.3, Acoustics.speedOfSoundAir 0.0, 0.2)
    val () = close "SoS at 20C ~343 m/s" (343.0, Acoustics.speedOfSoundAir 20.0, 0.5)

  in Harness.run () end
end

extension ADC {
final class OneShot {
    final class Unit {
        //private let handle: adc_oneshot_unit_handle_t
        var handle = adc_oneshot_unit_handle_t(bitPattern: 0)
        var unit: ADC.Unit
        init(_ unit: ADC.Unit = .unit1, 
            clockSource: ADC.DigitalClockSource = .default,
            ulp: ADC.ULPMode = .disable) 
        {

            self.unit = unit
            var initConfig: adc_oneshot_unit_init_cfg_t = .init(
            unit_id:  unit.esp, 
            clk_src:  clockSource.esp, 
            ulp_mode: ulp.esp)
    
        guard adc_oneshot_new_unit(&initConfig, &handle) == ESP_OK
        else {fatalError("cannot configure adc device") }
        }
    }
    
    private var calibrationHandle: adc_cali_handle_t? = nil
    private var oneShot: OneShot.Unit
    private var channel: ADC.Channel
    //var doCalibration: Bool = false

    init(unit: OneShot.Unit,
         channel    : ADC.Channel     = .channel0, 
         attenuation: ADC.Attenuation = .dB_12,
         bitwidth   : ADC.Bitwidth    = .default,
         calibration: ADC.CalibrationMode = .curve
         

    )  throws (ESPError) {
        //------------ ADC Init
        print ("📈 INIT ONE SHOT ADC")
        self.channel = channel
        self.oneShot = unit
        
        var config: adc_oneshot_chan_cfg_t = .init(
            atten:    attenuation.esp, 
            bitwidth: bitwidth.esp)
            
        guard adc_oneshot_config_channel(unit.handle, self.channel.esp, &config) == ESP_OK
        else {fatalError("❌cannot configure spi device") }
        
        //---------Calibration Init
        self.calibrationHandle = nil
        if calibration != .none {
         ADCCalibrationInit(
            calibration: calibration,
            attenuation: attenuation,
            bitwidth: bitwidth, 
            outHandle: &calibrationHandle)
        }
        print ("📈✅ ADC OneShot Configured")
    }

    func read() throws (ESPError) -> Int32 {
        var dataRaw = [[Int32]] (repeating: [Int32](repeating: 0, count: 10), count: 2)
        try runEsp { adc_oneshot_read(
            oneShot.handle, 
            channel.esp, 
            &dataRaw[oneShot.unit.rawValue][channel.rawValue])}
        return dataRaw[oneShot.unit.rawValue][channel.rawValue]
    }

    deinit {
       ADCCalibrationDeinit()
    }

    private func ADCCalibrationInit (
        calibration: ADC.CalibrationMode,
        //unit: ADC.Unit,
        //channel: ADC.Channel,
        attenuation: ADC.Attenuation,
        bitwidth: ADC.Bitwidth,
        outHandle: UnsafeMutablePointer<adc_cali_handle_t?>) {
        
        print ("📈 CALIBRATING!!!")
        var handle: adc_cali_handle_t? = nil
        var espError = ESP_FAIL
        var calibrated = false

//#if ADC_CALI_SCHEME_CU
// RVE_FITTING_SUPPORTED
        if !calibrated && calibration == .curve {
            print ("📈 Calibration scheme version: Curve fitting")
            var cali_config = adc_cali_curve_fitting_config_t (
                unit_id : oneShot.unit.esp,
                chan    : channel.esp,
                atten   : attenuation.esp,
                bitwidth: bitwidth.esp
            )
        espError = adc_cali_create_scheme_curve_fitting(&cali_config, &handle);
        if (espError == ESP_OK) {
            calibrated = true;
        }
        }
//#endif
        if !calibrated && calibration == .line {
            print ("📈❌ Line is not available")
        }

        outHandle.pointee = handle
        if espError == ESP_OK {
            print ("📈✅ Calibration Sucess")
        } else if espError == ESP_ERR_NOT_SUPPORTED || !calibrated {
            print ("📈❌ eFuse not burnt, skip software calibration")
        } else {
            print ("📈❌ Invalid arg or no memory")
        }
        }

        private func ADCCalibrationDeinit() {
            //TODO: Make for none and line
            adc_cali_delete_scheme_curve_fitting(oneShot.handle)
        }
    
    
    }
}
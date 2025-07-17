extension ADC {
final class OneShot {
    private let handle: adc_oneshot_unit_handle_t
    private var calibrationHandle: adc_cali_handle_t? = nil
    private var unit: ADC.Unit
    private var channel: ADC.Channel
    var doCalibration: Bool = false

    init(channel: ADC.Channel  = .channel0, 
         unit: ADC.Unit = .unit1,
         bitwidth: ADC.Bitwidth = .default,
         attenuation: ADC.Attenuation = .dB_12,
         clockSource: ADC.DigitalClockSource = .default,
         ulp: ADC.ULPMode = .disable

    )  throws (ESPError) {
        //------------ ADC Init
        print ("INIT ONE SHOT ADC")
        self.channel = channel
        self.unit = unit
        var handle = adc_oneshot_unit_handle_t(bitPattern: 0)
        
        var initConfig: adc_oneshot_unit_init_cfg_t = .init(
            unit_id:  self.unit.esp, 
            clk_src:  clockSource.esp, 
            ulp_mode: ulp.esp)
    
        guard adc_oneshot_new_unit(&initConfig, &handle) == ESP_OK
        else {fatalError("cannot configure adc device") }

        var config: adc_oneshot_chan_cfg_t = .init(
            atten:    attenuation.esp, 
            bitwidth: bitwidth.esp)
            
        guard adc_oneshot_config_channel(handle, self.channel.esp, &config) == ESP_OK,
            let handle = handle
        else {fatalError("cannot configure spi device") }
        self.handle = handle

        //---------Calibration Init
        self.calibrationHandle = nil
        self.doCalibration = false
        self.doCalibration = ADCCalibrationInit(
            unit: self.unit, 
            channel: self.channel, 
            attenuation: attenuation, 
            outHandle: &calibrationHandle)

        print ("ADC OneShot Configured")
    }

    func read() throws (ESPError) -> Int32 {
        var dataRaw = [[Int32]] (repeating: [Int32](repeating: 0, count: 10), count: 2)
        try runEsp { adc_oneshot_read(
            handle, 
            channel.esp, 
            &dataRaw[unit.rawValue][channel.rawValue])}
        return dataRaw[unit.rawValue][channel.rawValue]
    }

    private func ADCCalibrationInit (
        unit: ADC.Unit,
        channel: ADC.Channel,
        attenuation: ADC.Attenuation,
        outHandle: UnsafeMutablePointer<adc_cali_handle_t?>) -> Bool {
        
        print ("CALIBRATING!!!")
        var handle: adc_cali_handle_t? = nil
        var espError = ESP_FAIL
        var calibrated = false

//#if ADC_CALI_SCHEME_CU
// RVE_FITTING_SUPPORTED
        if !calibrated {
            print ("Calibration scheme version: Curve fitting")
            var cali_config = adc_cali_curve_fitting_config_t (
            unit_id: unit.esp,
            chan: channel.esp,
            atten: attenuation.esp,
            bitwidth: ADC.Bitwidth.default.esp
        )
        espError = adc_cali_create_scheme_curve_fitting(&cali_config, &handle);
        if (espError == ESP_OK) {
            calibrated = true;
        }
        }
//#endif
#if ADC_CALI_SCHEME_LINE_FITTING_SUPPORTED
        if !calibrated {
            print ("Calibration scheme version: Line fitting")
            let cali_config = adc_cali_line_fitting_config_t {
                .unit_id = unit
                .atten = attenuation
                .bitwidth = ADCBitwidth.default.esp
            }
        }
        espError = adc_cali_create_scheme_line_fitting(&cali_config, &handle);
        if (espError == ESP_OK) {
            calibrated = true
        }
#endif
    outHandle.pointee = handle
    if espError == ESP_OK {
        print ("Calibration Sucess")
    } else if espError == ESP_ERR_NOT_SUPPORTED || !calibrated {
        print ("eFuse not burnt, skip software calibration")
    } else {
        print ("Invalid arg or no memory")
    }
    return calibrated
    }

    private func ADCCalibrationDeinit() {
        print ("MUST BE IMPLEMENTED")
    }
    
    
}
}
class OneShotADC {
    var channel: adc_channel_t
    var attenuation: adc_atten_t
    var unit: adc_unit_t
    private let handle: adc_oneshot_unit_handle_t
    private var calibrationHandle: adc_cali_handle_t?
    private var dataRaw = [[Int32]] (repeating: [Int32](repeating: 0, count: 10), count: 2)
    var doCalibration: Bool

    init(channel: adc_channel_t  = ADC_CHANNEL_0, 
         unit: adc_unit_t = ADC_UNIT_1,
         attenuation: ADCAttenuation = ADCAttenuation.dB_12
    )  throws (ESPError) {
        //------------ ADC Init
        self.channel = channel
        self.unit = unit
        self.attenuation = attenuation.esp
        var handle = adc_oneshot_unit_handle_t(bitPattern: 0)
        
        var initConfig: adc_oneshot_unit_init_cfg_t = .init(
            unit_id: self.unit, 
            clk_src: ADC_DIGI_CLK_SRC_DEFAULT, 
            ulp_mode: ADC_ULPMode.disable.esp)
         
        guard adc_oneshot_new_unit(&initConfig, &handle) == ESP_OK
        else {fatalError("cannot configure adc device") }

        var config: adc_oneshot_chan_cfg_t = .init(
            atten: self.attenuation, 
            bitwidth: ADCBitwidth.default.esp)
            
        guard adc_oneshot_config_channel(handle, channel, &config) == ESP_OK,
            let handle = handle
        else {fatalError("cannot configure spi device") }
        self.handle = handle

        //---------Calibration Init
        self.calibrationHandle = nil
        self.doCalibration = false
        self.doCalibration = ADCCalibrationInit(
            unit: ADC_UNIT_1, 
            channel: self.channel, 
            attenuation: self.attenuation, 
            outHandle: &calibrationHandle)
    }

    func read() throws (ESPError) {
        try  runEsp { adc_oneshot_read(handle, channel, &dataRaw[0][0])}
        print ("read from analog input! \(dataRaw[0])")
        let data = dataRaw
        for i in data {
            print ("row: ")
            for j in i {
                print ("\(j), ", terminator:"")
            }
            print("")
        }
    }

    private func ADCCalibrationInit(
        unit: adc_unit_t,
        channel: adc_channel_t,
        attenuation: adc_atten_t,
        outHandle: UnsafeMutablePointer<adc_cali_handle_t?>) -> Bool {

        let handle: adc_cali_handle_t? = nil
        var espError = ESP_FAIL
        var calibrated = false

#if ADC_CALI_SCHEME_CURVE_FITTING_SUPPORTED
        if !calibrated {
            print ("Calibration scheme version: Curve fitting")
            let cali_config = adc_cali_curve_fitting_config_t {
            .unit_id = unit
            .chan = channel
            .atten = attenuation
            .bitwidth = ADCBitwidth.default.esp
        }
        espError = adc_cali_create_scheme_curve_fitting(&cali_config, &handle);
        if (espError == ESP_OK) {
            calibrated = true;
        }
        }
#endif
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
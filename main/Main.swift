var stripeColor = LedStrip.Color.white
var ledStrip = LedStrip.ESP32H2
var lightLevel: UInt8 = 0 
var lightState: Bool = false

let adcUnit = ADC.OneShot.Unit(.unit1)
var analogInput = try! ADC.OneShot(unit: adcUnit, channel: .channel0)
var pontentiometerInput = try! ADC.OneShot(unit: adcUnit, channel: .channel1)


@_cdecl("app_main")
func main() {

    var platformConfig: esp_zb_platform_config_t = Platform.config
    do {
        try runEsp { nvs_flash_init() }
        try runEsp { esp_zb_platform_config(&platformConfig) }
    } catch {
        print("🛑 (error.description)")
    }
    xTaskCreate(esp_zb_task, "Zigbee_main", 4096, nil, 5, nil)
     print ("🆗 TASK CRATED")
}

// @_silgen_name("printf")
// func c_printf(_ format: UnsafePointer<CChar>, _ args: CVarArg...) -> Int32
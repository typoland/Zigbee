func startTopLevelComissioningCB(mask: esp_zb_bdb_commissioning_mode_t) throws(ESPError) {
    try runEsp({ esp_zb_bdb_start_top_level_commissioning(UInt8(mask.rawValue)) })
}

@_cdecl("start_top_level_commissioning_cb")
func start_top_level_commissioning_cb_u8(_ value: UInt8) {
    let mode: esp_zb_bdb_commissioning_mode_t = esp_zb_bdb_commissioning_mode_t(
        rawValue: UInt32(value))
    try? startTopLevelComissioningCB(mask: mode)
}
/*
func defferedDriverInit()  throws (ESPError) {
    print ("🟣 Deffered Driver Init", terminator:"")
    var sensorConfig: temperature_sensor_config_t = SensorConfig.init(range: -10...80)
    print ("💜 sensor config done")
    thermometer = try TemperatureSensorDriver(
        config: &sensorConfig,
        updateInterval: 1000) 
    {   temperature in 
        print("This is CALLBACK! \(temperature.string(3))")
        var measuredValue = UInt16(temperature*100)
        /* Update temperature sensor measured value */
        esp_zb_lock_acquire(portMAX_DELAY);
        esp_zb_zcl_set_attribute_val(
            ThermometerConfig.endpointId,
            ZCLClusterID.temperatureMeasurement.rawValue, // ESP_ZB_ZCL_CLUSTER_ID_TEMP_MEASUREMENT, 
            ZCLClusterRole.server.rawValue, // ESP_ZB_ZCL_CLUSTER_SERVER_ROLE,
            TemperatureMeasurmentsCluster.Attribute.measuredValue.rawValue, // ESP_ZB_ZCL_ATTR_TEMP_MEASUREMENT_VALUE_ID, 
            &measuredValue, 
            false);
        esp_zb_lock_release()
    } 
        
    print ("💙 thermometer Exist here")
}
*/
@_cdecl("esp_zb_app_signal_handler")
func esp_zb_app_signal_handler(
    _ signalPointer: UnsafeMutablePointer<esp_zb_app_signal_t>?
) {
    print ("🔧 SIGNAL HANDLER")
    
    guard let signal: esp_zb_app_signal_t = signalPointer?.pointee else {
        print("❌ Null signal_struct")
        return
    }
    // Reinterpret the p_app_signal pointer as esp_zb_app_signal_type_t*
    let signalTypeRawValue = signal.p_app_signal?.pointee ?? 0
    let errStatus = signal.esp_err_status
    //CHECK

    print(
        "📶✳️ \(appSignalOverview(for: signalTypeRawValue))\nZigbee Signal Type: 0x\(String(signalTypeRawValue, radix: 16)), Status: \(errStatus) in \(#function) "
    )

    do  {
        switch signalTypeRawValue {
        case ESP_ZB_ZDO_SIGNAL_SKIP_STARTUP.rawValue:
            print("\(#function) 🔁 Skip startup")
            try startTopLevelComissioningCB(mask: ESP_ZB_BDB_MODE_INITIALIZATION)

        case ESP_ZB_BDB_SIGNAL_DEVICE_REBOOT.rawValue,
            ESP_ZB_BDB_SIGNAL_DEVICE_FIRST_START.rawValue:

            if errStatus == ESP_OK {
                print("\(#function) 🔁 Device reboot, first start")
                //try defferedDriverInit() 
                try startTopLevelComissioningCB(mask: ESP_ZB_BDB_MODE_NETWORK_STEERING)
                print ("Device in\(esp_zb_bdb_is_factory_new() ? "" : " non") factorry reset mode")
            }
        case ESP_ZB_BDB_SIGNAL_STEERING.rawValue:
            if errStatus == ESP_OK {
                print("\(#function) 📡 Steering")
                var addr: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0]
                esp_zb_get_extended_pan_id(&addr)
                print(
                    "Joined network succesfully \(addr)\n\tPanID: \(esp_zb_get_pan_id())\n\tChannel\(esp_zb_get_current_channel())"
                )
            } else {
                print("Network steering was not successful (status: \(espErrorName(errStatus)) ")
                esp_zb_scheduler_alarm(
                    start_top_level_commissioning_cb_u8,
                    UInt8(ESP_ZB_BDB_MODE_NETWORK_STEERING.rawValue),
                    1000)
            }

        case ESP_ZB_ZDO_SIGNAL_LEAVE.rawValue:
            print("\(#function) 🚪 Left network")

        case ESP_ZB_ZDO_SIGNAL_PRODUCTION_CONFIG_READY.rawValue:
            print("\(#function) 🧰 Config ready")

        // Add more signal cases as needed
        default: print("\(#function)❓ Other signal:\n\t\"\(appSignalOverview(for: signalTypeRawValue))\"")
        }
    } catch {
       fatalError("NOTHING WORKS HERE")
    }
}

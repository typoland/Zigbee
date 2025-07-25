typealias esp_temp_sensor_callback_t = @convention(c) (Float) -> Void

typealias SensorConfig = temperature_sensor_config_t
extension SensorConfig {
    init (
        range: ClosedRange<Int32>,
        clockSource: soc_periph_temperature_sensor_clk_src_t = TEMPERATURE_SENSOR_CLK_SRC_DEFAULT)
    {
        print ("init SensorConfig...", terminator: "")
        self = .init(
            range_min: range.lowerBound, 
            range_max: range.upperBound, 
            clk_src: clockSource, 
            flags: .init(allow_pd: 0)
        )
        print ("✔️ DONE")
    }
}


class TemperatureSensorDriver {

    var handle: temperature_sensor_handle_t
    var interval: UInt32
    var callback: esp_temp_sensor_callback_t

    init (
        config: UnsafePointer<SensorConfig>,
        updateInterval: UInt32, 
        callback: esp_temp_sensor_callback_t)  throws (ESPError)
        
    {
        self.callback = callback
        self.interval = updateInterval
        
        //Sensor Driver Init
        print ("🔷 Init TemperatureSensorDriver")
        var handle = temperature_sensor_handle_t(bitPattern: 0)
        // tempSensorDriverSensorInit
        print ("🔹 HANDLE: \(handle == nil ? "nil" : "defined")")
        try runEsp { temperature_sensor_install(config,  &handle) }
        print ("🔹 sensor installed")
        guard let handle = handle
        else {throw .failure("no handle in \(#function)")}
        print ("🔹 HANDLE: \(handle == nil ? "nil" : "defined")")
        self.handle = handle
        try runEsp { temperature_sensor_enable(handle)}
        print ("🔹 sensor enabled")

        //try runEsp { 
            xTaskCreate(temp_sensor_driver_value_update, 
                                "sensor_update", 
                                2048,
                                nil,
                                10, 
                                nil)//}

        print ("🔹 xTask created")

        print ("🔹 DONE ✔️ ")
    
    }
} 


@_cdecl("assign_temp_value")
func assign_temp_value(_ parameter: UnsafeMutableRawPointer?) -> Void {
  print ("🔵 assign temp value")
}    

@_cdecl("swift_temp_callback")
func swift_temp_callback(_ temperature: Float) {
    print("🟡 Swift callback: temperature = \(temperature)")
}
/*
@_cdecl("esp_app_temp_sensor_handler")
func esp_app_temp_sensor_handler(_ temperature: Float)
{
    print("🟠 esp_app_temp_sensor_handler")
    var measuredValue: Int16 = tempTos16(temperature);
    /* Update temperature sensor measured value */
    esp_zb_lock_acquire(portMAX_DELAY);
    esp_zb_zcl_set_attribute_val(
        Thermometer.endpointId,
        ZCLClusterID.temperatureMeasurement.rawValue,// ESP_ZB_ZCL_CLUSTER_ID_TEMP_MEASUREMENT, 
        ZCLClusterRole.server.rawValue,// ESP_ZB_ZCL_CLUSTER_SERVER_ROLE,
        TemperatureMeasurmentsCluster.Attributes.measuredValue.rawValue,// ESP_ZB_ZCL_ATTR_TEMP_MEASUREMENT_VALUE_ID, 
        &measuredValue, 
        false);
    esp_zb_lock_release();
}
*/
func tempTos16(_ temp: Float)->Int16 {
    Int16(temp*100)
}

@_cdecl("temp_sensor_driver_value_update")
func temp_sensor_driver_value_update(_ param: UnsafeMutableRawPointer?) {
    while true {
        print("🟢 esp_app_temp_sensor_handler")
        var tSensValue: Float = 0;
        if let thermometer {
            temperature_sensor_get_celsius( thermometer.handle, &tSensValue);
            print ("Its gOOOOOI ng somewhere")
            thermometer.callback(tSensValue);
       
        delayMiliseconds(Int(thermometer.interval))//(pdMS_TO_TICKS(interval * 1000));
        } else {
            print ("🔴 NO THERMOMETER at all")
            delayMiliseconds(5000)
            
        }
    }
}

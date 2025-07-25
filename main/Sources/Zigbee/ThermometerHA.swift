@_cdecl("temp_sensor_driver_value_update")
func temp_sensor_driver_value_update(_ param: UnsafeMutableRawPointer?) {
    while true {
        var tSensValue: Float = 0;
        temperature_sensor_get_celsius(tempSensorHandle, &tSensValue);
       
            funcPointer?(tSensValue);
       
        delayMiliseconds(Int(interval))//(pdMS_TO_TICKS(interval * 1000));
    }
}

typealias esp_temp_sensor_callback_t = @convention(c) (Float) -> Void

var funcPointer: esp_temp_sensor_callback_t? = nil
var interval: UInt16 = 1;
var tempSensorHandle: temperature_sensor_handle_t? =  nil

@_cdecl("temp_sensor_driver_sensor_init")
func temp_sensor_driver_sensor_init(
    _ config: UnsafePointer< temperature_sensor_config_t> ) -> Int32
{
    print ("HERE IS INIT OF ONBARD TERMOMETER")
    do {
    try runEsp{temperature_sensor_install(config, &tempSensorHandle)}
                        //TAG, "Fail to install on-chip temperature sensor");
    try runEsp{temperature_sensor_enable(tempSensorHandle)}
                        //TAG, "Fail to enable on-chip temperature sensor");
    } catch { print ("CANNOT CREATE SENSOR DRIVER SENSOR INIT")}
    return (xTaskCreate(temp_sensor_driver_value_update, "sensor_update", 2048, nil, 10, nil) == pdTRUE) ? ESP_OK : ESP_FAIL;
}

@_cdecl("temp_sensor_driver_init")
func temp_sensor_driver_init(
    _ config: UnsafePointer<temperature_sensor_config_t>,
    _ updateInterval: UInt16,
    _ callback: esp_temp_sensor_callback_t) -> Int32
{
    if (ESP_OK != temp_sensor_driver_sensor_init(config)) {
        return ESP_FAIL;
    }
    funcPointer = callback;
    interval = updateInterval;
    return ESP_OK;
}


func tempTos16(_ temp: Float)->Int16 {
    Int16(temp*100)
}

@_cdecl("esp_app_temp_sensor_handler")
func esp_app_temp_sensor_handler(_ temperature: Float)
{
    var measuredValue: Int16 = tempTos16(temperature);
    /* Update temperature sensor measured value */
    esp_zb_lock_acquire(portMAX_DELAY);
    esp_zb_zcl_set_attribute_val(Thermometer.endpointId,
        ZCLClusterID.temperatureMeasurement.rawValue,// ESP_ZB_ZCL_CLUSTER_ID_TEMP_MEASUREMENT, 
        ZCLClusterRole.server.rawValue,// ESP_ZB_ZCL_CLUSTER_SERVER_ROLE,
        TemperatureMeasurmentsCluster.Attributes.measuredValue.rawValue,// ESP_ZB_ZCL_ATTR_TEMP_MEASUREMENT_VALUE_ID, 
        &measuredValue, 
        false);
    esp_zb_lock_release();
}

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

    private var handle: temperature_sensor_handle_t
    var callback: esp_temp_sensor_callback_t
    var interval: UInt32 = 1
    
    init (
        config: UnsafePointer<SensorConfig>, 
        callback: esp_temp_sensor_callback_t,
        updateInterval: UInt32)
    {
        print ("Init TemperatureSensorDriver", terminator: "")
    var handle = temperature_sensor_handle_t(bitPattern: 0)
    // sensor init
    do {try runEsp { temperature_sensor_install(config,  &handle) }}
    catch {fatalError("Cannot install trmperature sensor \(error.description)")}

    guard temperature_sensor_enable(handle) == ESP_OK,
        let handle = handle 
    else {fatalError("cannot inint Temp sensor handle ")}
    
    do {
        try runEsp {xTaskCreate (assign_temp_value, "Assign temp value xTask",2048,nil,10,nil)}
    } catch {
        print (error.description)
        fatalError("cannot run xTask \"assign Temp Value Task\"")
    }
    self.handle = handle
    self .callback = callback
    print ("✔️ DONE")
    
    }
    //self.interval = updateInterval
} 


@_cdecl("assign_temp_value")
func assign_temp_value(_ parameter: UnsafeMutableRawPointer?) -> Void {
  print ("assign tem value")
}    

@_cdecl("swift_temp_callback")
func swift_temp_callback(_ temperature: Float) {
    print("Swift callback: temperature = \(temperature)")
}


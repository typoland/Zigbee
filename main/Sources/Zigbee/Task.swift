@_cdecl("esp_zb_task")
func esp_zb_task(_ param: UnsafeMutableRawPointer?) {

    /* initialize Zigbee stack */
    let endpointList = esp_zb_ep_list_create()

    
    //print("🛜 NETWORK DONE \(#function)")

    var networkConfig: esp_zb_cfg_t = Platform.networkConfiguration  //Zigbee End Point
    esp_zb_init(&networkConfig)
 
    do { 
        try runEsp {esp_zb_set_primary_network_channel_set(Platform.primaryChannelMask)}
    } catch {print ("\(error.description)")}


    /*-----------------LedStrip------------------------*/
    
    let ledStripEndPointConfig = EndpointConfig(
        id: 10, //ColorLedStip.endpointId, 
        profileID: .homeAutomation, 
        deviceID: .colorDimmableLight, 
        appVersion: 0)

    esp_zb_ep_list_add_ep(
        endpointList, 
        ColorLedStripConfig.clusterList, 
        ledStripEndPointConfig)

     print ("✔️  LedStrip Endpoint done")
    /*-----------------Thermometer --------------------*/

    /* Create customized temperature sensor endpoint */
    //esp_zb_temperature_sensor_cfg_t
    ThermometerConfig.cluster.tempMeasure = TemperatureMeasureConfig( 
            min: -10 * 100,   //LTemperatureMeasurement.Default.minMeasuredValue, 
            max:  80 * 100)    //ZCLTemperatureMeasurement.Default.maxMeasuredValue)

    let thermometerEndPointConfig = EndpointConfig(
        id: 11,//Thermometer.endpointId, 
        profileID: .homeAutomation, 
        deviceID: .temperatureSensor, 
        appVersion: 0)

    esp_zb_ep_list_add_ep(
        endpointList, 
        ThermometerConfig.clusterList, 
        thermometerEndPointConfig)

     print ("✔️  Therometer Endpoint done")

    do {try runEsp{ esp_zb_device_register(endpointList) }
    } catch {print ("❌ Could not register endpoint List: n\(error.description)")}

    print ("✅ Endpoints list OK")

    /*=================Endpoints done================*/

    //print ("✔️  Reporting info defined")
    esp_zb_zcl_update_reporting_info(&ThermometerConfig.reportingInfo)
    print ("✔️  Reporting info updated")
    /*------------------------END--------------------*/
  
    

    
    
     do { 
        //Zigbee Start
        try runEsp { esp_zb_start(false) } 
    } catch {
        print("🛑 ERROR: \(error.description) in \(#function)")
    }
    print("✅ ESP IS RUNNING \(#function)")
    esp_zb_stack_main_loop()
}

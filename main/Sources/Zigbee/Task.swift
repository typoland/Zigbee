@_cdecl("esp_zb_task")
func esp_zb_task(_ param: UnsafeMutableRawPointer?) {

    /* initialize Zigbee stack */
    let endpointList = esp_zb_ep_list_create()

    var networkConfig: esp_zb_cfg_t = Platform.networkConfiguration  //Zigbee End Point
    esp_zb_init(&networkConfig)

    let primaryChannelMask = ESP_ZB_TRANSCEIVER_ALL_CHANNELS_MASK
    esp_zb_set_primary_network_channel_set(primaryChannelMask)
    //print("🛜 NETWORK DONE \(#function)")

    

    /* -------------------- Light Config --------------------- */

    // var lightConfig = DimmableLight.config
      
    // guard let ledStripEndPoint: UnsafeMutablePointer<esp_zb_ep_list_t> = esp_zb_color_dimmable_light_ep_create(
    //     DimmableLight.endpointId,
    //     &lightConfig)
    // else {return}

    // var info = DimmableLight.info

    // esp_zcl_utility_add_ep_basic_manufacturer_info(
    //     ledStripEndPoint, 
    //     DimmableLight.endpointId, 
    //     &info)

    // esp_zb_device_register(ledStripEndPoint)
    // //print("💡 DIMMABLE LIGHT ENDPOINT DONE \(#function)")

    // esp_zb_ep_list_add_ep(
    //     endpointList, 
    //     UnsafeMutablePointer<esp_zb_cluster_list_t>!, 
    //     &lightConfig.esp_zb_ep_info)
    esp_zb_core_action_handler_register(zb_action_handler)
    //let endpointList =  esp_zb_ep_list_create()
    /*-----------------LedStrip------------------------*/
    let ledStripClusterList = ColorLedStip.clusterList

    let ledStripEndPointConfig: esp_zb_endpoint_config_t = esp_zb_endpoint_config_t(
        endpoint: ColorLedStip.endpointId,
        app_profile_id: ZigbeeProfileID.homeAutomation.rawValue, 
        app_device_id: HADeviceID.colorDimmableLight.rawValue, 
        app_device_version: 0)

    esp_zb_ep_list_add_ep(
        endpointList, 
        ledStripClusterList, 
        ledStripEndPointConfig)


  
    /*-----------------Thermometer --------------------*/

    /* Create customized temperature sensor endpoint */
    //esp_zb_temperature_sensor_cfg_t
    var thermometerConfig =  Thermometer.config
    /* Set (Min|Max)MeasuredValure */
    thermometerConfig.temp_meas_cfg.min_value = -10 * 100
    thermometerConfig.temp_meas_cfg.min_value =  80 * 100

    let thermometerClusterList = Thermometer.clusterList
    let thermometerEndPointConfig = esp_zb_endpoint_config_t(
        endpoint: Thermometer.endpointId, 
        app_profile_id: UInt16(ESP_ZB_AF_HA_PROFILE_ID.rawValue), 
        app_device_id: UInt16(ESP_ZB_HA_TEMPERATURE_SENSOR_DEVICE_ID.rawValue), 
        app_device_version: 0)
    
    esp_zb_ep_list_add_ep(
        endpointList, 
        thermometerClusterList, 
        thermometerEndPointConfig)

    /*------------------------END--------------------*/
    esp_zb_device_register(endpointList)
   
    esp_zb_zcl_update_reporting_info(&Thermometer.reportingInfo)
  

    //Zigbee Start
    do { try runEsp { esp_zb_start(false) } } catch {
        print("🛑 ERROR: (error.description) in \(#function)")
    }
    print("✅ ESP IS RUNNING \(#function)")
    esp_zb_stack_main_loop()
}

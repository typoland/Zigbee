
func makeCChar(from string: String) -> [CChar] {
    [CChar(string.count)] + string.utf8.map { CChar($0)}
}

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
    /*
    let ledStripEndPointConfig = EndpointConfig(
        id: 10, //ColorLedStip.endpointId, 
        profileID: .homeAutomation, 
        deviceID: .colorDimmableLight, 
        appVersion: 0)

    esp_zb_ep_list_add_ep(
        endpointList, 
        ColorLedStripConfig.clusterList, 
        ledStripEndPointConfig)

*/  
    //Basic
    var ledBasicClusterConfig = BasicCluster.Config()
    
    var manufacturerName: [CChar] = [0x05] + "ABCDE".utf8.map {CChar($0)}// makeCChar(from: "Ojej")
    var model = [0x07] + "ABCDEFG".utf8.map {CChar($0)}//makeCChar(from: "Nowosc na rynku")
    
    var ledBasicCluster = BasicCluster(config: &ledBasicClusterConfig)
    try! ledBasicCluster.addAttribute(.manufacturerName, &manufacturerName)
    try! ledBasicCluster.addAttribute(.modelIdentifier, &model)
    //Identify
    var ledIdentifyClusterConfig = IdentifyCluster.Config()
    var ledIdentifyCluster = IdentifyCluster(config: &ledIdentifyClusterConfig)
    //OnOff
    var ledOnOffClusterConfig = OnOffCluster.Config()
    var ledOnOffCluster = OnOffCluster(config: &ledOnOffClusterConfig)
    //Level
    var ledLevelClusterConfig = LevelCluster.Config()
    var ledLevelCluster = LevelCluster(config: &ledLevelClusterConfig)
    //ColorControl
    var ledColorControlClusterConfig = ColorControlCluster.Config()
    var ledColorControlCluster = ColorControlCluster(config: &ledColorControlClusterConfig)
    //Groups
    var ledGroupsClusterConfig = GroupsCluster.Config()
    var ledGroupsCluster = GroupsCluster(config: &ledGroupsClusterConfig)
    
    let ledClusterList = ClusterList.new()
    do {
        try ledBasicCluster.addTo(clusterlist: ledClusterList,  role: .server)
        try ledIdentifyCluster.addTo(clusterlist: ledClusterList,  role: .server)
        try ledOnOffCluster.addTo(clusterlist: ledClusterList,  role: .server)
        try ledLevelCluster.addTo(clusterlist: ledClusterList,  role: .server)
        try ledColorControlCluster.addTo(clusterlist: ledClusterList,  role: .server)
        try ledGroupsCluster.addTo(clusterlist: ledClusterList,  role: .server)
    // )
    } catch {
        print ("Error: \(error.description)")
        fatalError(error.description)
    }
    let ledStripEndPointConfig = EndpointConfig(
        id: 10, //ColorLedStip.endpointId, 
        profileID: .homeAutomation, 
        deviceID: .colorDimmableLight, 
        appVersion: 0)

    esp_zb_ep_list_add_ep(
        endpointList, 
        ledClusterList, 
        ledStripEndPointConfig)


    

     print ("✔️  LedStrip Endpoint done")
    /*
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
    */

    do {try runEsp{ esp_zb_device_register(endpointList) }
    } catch {print ("❌ Could not register endpoint List: n\(error.description)")}

    print ("✅ Endpoints list OK")

    /*=================Endpoints done================*/

    //print ("✔️  Reporting info defined")
    //esp_zb_zcl_update_reporting_info(&ThermometerConfig.reportingInfo)
    //print ("✔️  Reporting info updated")
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

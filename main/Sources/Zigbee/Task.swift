@_cdecl("esp_zb_task")
func esp_zb_task(_ param: UnsafeMutableRawPointer?) {

    /* initialize Zigbee stack */
    

    var networkConfig: esp_zb_cfg_t = Platform.networkConfiguration  //Zigbee End Point
    esp_zb_init(&networkConfig)
    //print("🛜 NETWORK DONE \(#function)")

    /* -------------------- Light Config --------------------- */
    var lightConfig = DimmableLight.config
    guard let ledStripEndPoint: UnsafeMutablePointer<esp_zb_ep_list_t> = esp_zb_color_dimmable_light_ep_create(
        DimmableLight.endpointId,
        &lightConfig)
    else {return}

    var info = DimmableLight.info

    esp_zcl_utility_add_ep_basic_manufacturer_info(
        ledStripEndPoint, 
        DimmableLight.endpointId, 
        &info)

    esp_zb_device_register(ledStripEndPoint)
    //print("💡 DIMMABLE LIGHT ENDPOINT DONE \(#function)")


    esp_zb_core_action_handler_register(zb_action_handler)
    esp_zb_set_primary_network_channel_set(DimmableLight.primaryChannelMask)

    //Zigbee Start
    do { try runEsp { esp_zb_start(false) } } catch {
        print("🛑 ERROR: (error.description) in \(#function)")
    }
    print("✅ ESP IS RUNNING \(#function)")
    esp_zb_stack_main_loop()
}

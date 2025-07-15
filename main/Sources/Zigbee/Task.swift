@_cdecl("esp_zb_task")
func esp_zb_task(_ param: UnsafeMutableRawPointer?) {

    /* initialize Zigbee stack */
    

    var networkConfig: esp_zb_cfg_t = Platform.networkConfiguration  //Zigbee End Point
    esp_zb_init(&networkConfig)
    //print("🛜 NETWORK DONE \(#function)")

    /* -------------------- Light Config --------------------- */
    var lightConfig: esp_zb_color_dimmable_light_cfg_t = DimmableLight.config
    let ledStripEndPoint = esp_zb_color_dimmable_light_ep_create(
        DimmableLight.endpointId,
        &lightConfig)
     
    //print("💡 DIMMABLE LIGHT ENDPOINT DONE \(#function)")

    var name = DimmableLight.manufacturerName
    var model = DimmableLight.modelIdentifier

    var info = name.withUnsafeMutableBufferPointer {
        namePtr in
        model.withUnsafeMutableBufferPointer { modelPtr in
            return zcl_basic_manufacturer_info_t(
                manufacturer_name: namePtr.baseAddress,
                model_identifier: modelPtr.baseAddress
            )
        }
    }
    esp_zcl_utility_add_ep_basic_manufacturer_info(
        ledStripEndPoint, 
        DimmableLight.endpointId, 
        &info)

    esp_zb_device_register(ledStripEndPoint)
    esp_zb_core_action_handler_register(zb_action_handler)
    esp_zb_set_primary_network_channel_set(DimmableLight.primaryChannelMask)

    //Zigbee Start
    do { try runEsp { esp_zb_start(false) } } catch {
        print("🛑 ERROR: (error.description) in \(#function)")
    }
    print("✅ ESP IS RUNNING \(#function)")
    esp_zb_stack_main_loop()
}

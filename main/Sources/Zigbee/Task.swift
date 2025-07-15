@_cdecl("esp_zb_task")
func esp_zb_task(_ param: UnsafeMutableRawPointer?) {

    /* initialize Zigbee stack */
    print("✅ ZB TASK \(#function)")

    var networkConfig: esp_zb_cfg_t = Platform.networkConfiguration  //Zigbee End Point
    esp_zb_init(&networkConfig)
    print("🛜 NETWORK DONE \(#function)")
    //-----
    var lightConfig: esp_zb_color_dimmable_light_cfg_t = DimmableLight.config
    let endPoint = esp_zb_color_dimmable_light_ep_create(
        DimmableLight.endpoint,
        &lightConfig)
    //----
    
    print("💡 DIMMABLE LIGHT ENDPOINT DONE \(#function)")

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
        endPoint, 
        DimmableLight.endpoint, 
        &info)

    esp_zb_device_register(endPoint)
    esp_zb_core_action_handler_register(zb_action_handler)
    esp_zb_set_primary_network_channel_set(DimmableLight.primaryChannelMask)

    do { try runEsp { esp_zb_start(false) } } catch {
        print("🛑 ERROR: (error.description) in \(#function)")
    }
    print("▶️ ESP IS RUNNING \(#function)")

    print("GOING LOOP \(#function) ")
    esp_zb_stack_main_loop()
    //delayMiliseconds(10)
    //}
}

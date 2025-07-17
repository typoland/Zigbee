struct DimmableLight {
    /* Basic manufacturer information */
    // static var manufacturerName: [CChar] = [0x07] + "MOMENTARY".utf8.map{CChar($0)}
    // static var modelIdentifier: [CChar] = [0x05] + "SWIFT".utf8.map{CChar($0)}
    static var manufacturerName = [CChar(0x07)] + "MOMENTARY".utf8.map{CChar($0)}
    static var modelIdentifier = [CChar(0x05)] + "SWIFT".utf8.map{CChar($0)}
    
    static var info: zcl_basic_manufacturer_info_t = manufacturerName.withUnsafeMutableBufferPointer {
        namePtr in
        modelIdentifier.withUnsafeMutableBufferPointer { modelPtr in
            return zcl_basic_manufacturer_info_t(
                manufacturer_name: namePtr.baseAddress,
                model_identifier: modelPtr.baseAddress
            )
        }
    }

    static var endpointId: UInt8 = 10
    static var primaryChannelMask = ESP_ZB_TRANSCEIVER_ALL_CHANNELS_MASK

    enum cluster {
        
        static var basic =  BasicClusterConfig(
            zclVersion:  ZCLBasic.zclVersion,
            powerSource: ZCLBasic.powerSource)

        static var identity = IdentifyClusterConfig (
                identifyTime: ZCLIdentify.identifyTime)
      

        static var groups = GroupsClusterConfig (
                groupsNameSupportID: ZCLGroups.nameSupportDefault)// UInt8(ESP_ZB_ZCL_GROUPS_NAME_SUPPORT_DEFAULT_VALUE))
       
        static var scenes =  ScenesClusterConfig(
                scenesCount:    ZCLScenes.sceneCountDefault,
                currentSceneID: ZCLScenes.currentSceneDefault, //UInt8(ESP_ZB_ZCL_SCENES_CURRENT_SCENE_DEFAULT_VALUE),
                currentGroup:   ZCLScenes.currentGroupDefault,
                sceneValid:     ZCLScenes.sceneCountDefault != 0,
                nameSupportID:  ZCLScenes.nameSupportDefault)
    
        static var onOff = OnOffClusterConfig (
            onOff: ZCLOnOff.onOffDefault)
            
        static var level = LevelClusterConfig (
            currentLevel: ZCLLevel.currentLevelDefault)
        
        static var color = ColorClusterConfig (
            currentX: ZCLColorControl.currentXDefault, 
            currentY: ZCLColorControl.currentYDefault, 
            colorMode: ZCLColorControl.colorModeDefault, 
            options: ZCLColorControl.optionsDefault, 
            enhancedColorMode: ZCLColorControl.enhancedColorModeDefault, 
            colorCapabilities: 0x0008) 
    }
        
    static var config = DimmableLightConfig (
            
        basic: cluster.basic,
        identity: cluster.identity,
        groups: cluster.groups,
        scenes: cluster.scenes,
        onOff: cluster.onOff,
        level: cluster.level,
        color: cluster.color)  
}



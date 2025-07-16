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

    //Because of c macros
    static var ESP_ZB_ZCL_ON_OFF_ON_OFF_DEFAULT_VALUE: Bool = false
    static var ESP_ZB_ZCL_ON_OFF_GLOBAL_SCENE_CONTROL_DEFAULT_VALUE: Bool = true
    static var ESP_ZB_ZCL_ON_OFF_ON_TIME_DEFAULT_VALUE: UInt16 = 0x00A0 //was 0x0000
    static var ESP_ZB_ZCL_ON_OFF_OFF_WAIT_TIME_DEFAULT_VALUE: UInt16 = 0x0000
    static var ESP_ZB_ZCL_LEVEL_CONTROL_CURRENT_LEVEL_DEFAULT_VALUE: UInt8 = 0x10 //was FF
    static var ESP_ZB_ZCL_COLOR_CONTROL_CURRENT_X_DEF_VALUE: UInt16 = 0x216b // 0x616b
    static var ESP_ZB_ZCL_COLOR_CONTROL_CURRENT_Y_DEF_VALUE: UInt16 = 0x907d // 0x616b
    static var ESP_ZB_ZCL_COLOR_CONTROL_COLOR_MODE_DEFAULT_VALUE: UInt8 = 0x01
    static var ESP_ZB_ZCL_COLOR_CONTROL_OPTIONS_DEFAULT_VALUE: UInt8 = 0x00
    static var ESP_ZB_ZCL_COLOR_CONTROL_ENHANCED_COLOR_MODE_DEFAULT_VALUE: UInt8 = 0x01
    static var colorCapabilities: UInt16 = 0x0008

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



typealias BasicClusterConfig = esp_zb_basic_cluster_cfg_t
extension BasicClusterConfig {
    init(zclVersion: UInt8, powerSource: ZCLCluster.Basic.PowerSource) {
        self = .init(
            zcl_version: zclVersion,
            power_source: powerSource.rawValue)
    }
}

typealias IdentifyClusterConfig = esp_zb_identify_cluster_cfg_t
extension IdentifyClusterConfig {
    /*!<  The remaining length of the time that identify itself */
    init(identifyTime: UInt16) {
        self = .init(identify_time: identifyTime)
    }
}
typealias GroupsClusterConfig = esp_zb_groups_cluster_cfg_t
extension GroupsClusterConfig {
    init(groupsNameSupportID: UInt8) {
        self = .init(groups_name_support_id: groupsNameSupportID)
    }
}

typealias ScenesClusterConfig = esp_zb_scenes_cluster_cfg_t
extension ScenesClusterConfig {
    init(
        scenesCount: UInt8,
        currentSceneID: UInt8,
        currentGroup: UInt16,
        sceneValid: Bool,
        nameSupportID: UInt8
    ) {
        self = .init(
            scenes_count: scenesCount,
            current_scene: currentSceneID,
            current_group: currentGroup,
            scene_valid: sceneValid,
            name_support: nameSupportID
        )
    }
}

typealias OnOffClusterConfig = esp_zb_on_off_cluster_cfg_t
extension OnOffClusterConfig {
    init(onOff: Bool) {
        self = .init(on_off: onOff)
    }
}

typealias LevelClusterConfig = esp_zb_level_cluster_cfg_t
extension LevelClusterConfig {
    init(currentLevel: UInt8) {
        self = .init(current_level: currentLevel)
    }
}

typealias ColorControlClusterConfig = esp_zb_color_cluster_cfg_t
extension ColorControlClusterConfig {
    init(
        currentX: UInt16,
        currentY: UInt16,
        colorMode: UInt8,
        options: UInt8,
        enhancedColorMode: UInt8,
        colorCapabilities: [ZCLCluster.ColorControl.ColorCapability]
    ) {
        self = .init(
            current_x: currentX,
            current_y: currentY,
            color_mode: colorMode,
            options: options,
            enhanced_color_mode: enhancedColorMode,
            color_capabilities: 1<<3 //ZCLCluster.ColorControl.ColorCapability.value(colorCapabilities)
        )
    }
}

typealias DimmableLightConfig = esp_zb_color_dimmable_light_cfg_t
extension DimmableLightConfig {
    init(basic: BasicClusterConfig = ZCLCluster.Basic.Default.config,
        identify: IdentifyClusterConfig = ZCLCluster.Identify.Default.config,
        groups: GroupsClusterConfig = ZCLCluster.Groups.Default.config,
        scenes: ScenesClusterConfig = ZCLCluster.Scenes.Default.config,
        onOff: OnOffClusterConfig = ZCLCluster.OnOff.Default.config,
        level: LevelClusterConfig = ZCLCluster.Level.Default.config,
        colorControl: ColorControlClusterConfig = ZCLCluster.ColorControl.Default.config
        ) {
            self = .init(
                basic_cfg: basic,
                identify_cfg: identify,
                groups_cfg: groups,
                scenes_cfg: scenes,
                on_off_cfg: onOff,
                level_cfg: level,
                color_cfg: colorControl
            )
        }
}

typealias TemperatureMeasureConfig = esp_zb_temperature_meas_cluster_cfg_t
extension TemperatureMeasureConfig {
    init(measuredValue: Int16,
        min: Int16,
        max: Int16) {
        self = .init(
            measured_value: measuredValue, 
            min_value: min, 
            max_value: max)
    }
}

typealias ReportingInfo = esp_zb_zcl_reporting_info_t
extension ReportingInfo {
    struct Intervals {
        let min: UInt16
        let max: UInt16
        let delta: UInt16
        let reportedValue: UInt16
        let defaultMin: UInt16
        let defaultMax: UInt16
    }
    struct Destination {
        let profileID: UInt16
    }
    init(direction: ZCLCommandDirection,
        endpointID: UInt8,
        clusterID: ZCLClusterID,
        clusterRole: ZCLClusterRole,
        attributesID: ZCLTemperatureMeasurement,
        flags: UInt8,
        runtime: UInt64,
        intervals: Intervals,
        destination: Destination,
        manufacturerCode: UInt16) {
            self = .init(
                direction: direction.rawValue, 
                ep: endpointID, 
                cluster_id: clusterID.rawValue, 
                cluster_role: clusterRole.rawValue, 
                attr_id: attributesID.rawValue, 
                flags: flags, 
                run_time: runtime, 
                u:.init(send_info: .init(
                    min_interval: intervals.min,
                    max_interval: intervals.max,
                    delta: .init(u16:intervals.delta),
                    reported_value: .init(),
                    def_min_interval: intervals.defaultMin,
                    def_max_interval: intervals.defaultMax)), 
                dst:.init(
                    short_addr: .init(),
                    endpoint: .init(),
                    profile_id: destination.profileID),
                manuf_code: manufacturerCode)
            
    }
}
typealias TemperatureSensorConfig = esp_zb_temperature_sensor_cfg_t
extension TemperatureSensorConfig {
    init(basic: BasicClusterConfig,
        identify: IdentifyClusterConfig,
        tempMeasure: TemperatureMeasureConfig) {
        self = .init(
            basic_cfg: basic, 
            identify_cfg: identify, 
            temp_meas_cfg: tempMeasure)
    }
}
// typealias AttributeList = esp_zb_attribute_list_t
// extension AttributeList {
//     init (clusterID: UInt16) {
//         self =  esp_zb_zcl_attr_list_create(clusterID)
//     }
// }
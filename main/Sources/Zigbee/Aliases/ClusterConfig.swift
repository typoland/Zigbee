typealias BasicClusterConfig = esp_zb_basic_cluster_cfg_t
extension BasicClusterConfig {
    init(zclVersion: UInt8, powerSource: ZCLBasic.PowerSource) {
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

typealias ColorClusterConfig = esp_zb_color_cluster_cfg_t
extension ColorClusterConfig {
    init(
        currentX: UInt16,
        currentY: UInt16,
        colorMode: UInt8,
        options: UInt8,
        enhancedColorMode: UInt8,
        colorCapabilities: UInt16
    ) {
        self = .init(
            current_x: currentX,
            current_y: currentY,
            color_mode: colorMode,
            options: options,
            enhanced_color_mode: enhancedColorMode,
            color_capabilities: colorCapabilities
        )
    }
}

typealias DimmableLightConfig = esp_zb_color_dimmable_light_cfg_t
extension DimmableLightConfig {
    init(basic: BasicClusterConfig,
        identity: IdentifyClusterConfig,
        groups: GroupsClusterConfig,
        scenes: ScenesClusterConfig,
        onOff: OnOffClusterConfig,
        level: LevelClusterConfig,
        color: ColorClusterConfig) {
            self = .init(
                basic_cfg: basic,
                identify_cfg: identity,
                groups_cfg: groups,
                scenes_cfg: scenes,
                on_off_cfg: onOff,
                level_cfg: level,
                color_cfg: color
            )
        }
}
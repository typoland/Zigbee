enum DimmableLight {
    /* Basic manufacturer information */
    static var manufacturerName: [CChar] = [0x09] + "ESPRESSIV".utf8.map{CChar($0)}
    static var modelIdentifier: [CChar] = [0x05] + "SWIFT".utf8.map{CChar($0)}

    //Because of c macros
    static var ESP_ZB_ZCL_ON_OFF_ON_OFF_DEFAULT_VALUE: Bool = false
    static var ESP_ZB_ZCL_ON_OFF_GLOBAL_SCENE_CONTROL_DEFAULT_VALUE: Bool = true
    static var ESP_ZB_ZCL_ON_OFF_ON_TIME_DEFAULT_VALUE: UInt16 = 0x0000
    static var ESP_ZB_ZCL_ON_OFF_OFF_WAIT_TIME_DEFAULT_VALUE: UInt16 = 0x0000
    static var ESP_ZB_ZCL_LEVEL_CONTROL_CURRENT_LEVEL_DEFAULT_VALUE: UInt8 = 0xFF
    static var ESP_ZB_ZCL_COLOR_CONTROL_CURRENT_X_DEF_VALUE: UInt16 = 0x616b
    static var ESP_ZB_ZCL_COLOR_CONTROL_CURRENT_Y_DEF_VALUE: UInt16 = 0x607d
    static var ESP_ZB_ZCL_COLOR_CONTROL_COLOR_MODE_DEFAULT_VALUE: UInt8 = 0x01
    static var ESP_ZB_ZCL_COLOR_CONTROL_OPTIONS_DEFAULT_VALUE: UInt8 = 0x00
    static var ESP_ZB_ZCL_COLOR_CONTROL_ENHANCED_COLOR_MODE_DEFAULT_VALUE: UInt8 = 0x01
    static var colorCapabilities: UInt16 = 0x0008

    static var endpoint: UInt8 = 10
    static var primaryChannelMask = ESP_ZB_TRANSCEIVER_ALL_CHANNELS_MASK


    enum cluster {
        static var basic: esp_zb_basic_cluster_cfg_t {
            esp_zb_basic_cluster_cfg_t(
                zcl_version: ESP_ZB_ZCL_BASIC_ZCL_VERSION_DEFAULT_VALUE,
                power_source: ESP_ZB_ZCL_BASIC_POWER_SOURCE_DEFAULT_VALUE)
        }
        static var identity: esp_zb_identify_cluster_cfg_t {
            esp_zb_identify_cluster_cfg_t(
                identify_time: UInt16(ESP_ZB_ZCL_IDENTIFY_IDENTIFY_TIME_DEFAULT_VALUE))
        }

        static var groups: esp_zb_groups_cluster_cfg_t {
            esp_zb_groups_cluster_cfg_t(
                groups_name_support_id: UInt8(ESP_ZB_ZCL_GROUPS_NAME_SUPPORT_DEFAULT_VALUE))
        }
        static var scenes: esp_zb_scenes_cluster_cfg_t {
            esp_zb_scenes_cluster_cfg_t(
                scenes_count: UInt8(ESP_ZB_ZCL_SCENES_SCENE_COUNT_DEFAULT_VALUE),
                current_scene: UInt8(ESP_ZB_ZCL_SCENES_CURRENT_SCENE_DEFAULT_VALUE),
                current_group: UInt16(ESP_ZB_ZCL_SCENES_CURRENT_GROUP_DEFAULT_VALUE),
                scene_valid: ESP_ZB_ZCL_SCENES_SCENE_VALID_DEFAULT_VALUE != 0,
                name_support: UInt8(ESP_ZB_ZCL_SCENES_NAME_SUPPORT_DEFAULT_VALUE))
        }

        static var onOff: esp_zb_on_off_cluster_cfg_t {
            esp_zb_on_off_cluster_cfg_t(on_off: ESP_ZB_ZCL_ON_OFF_ON_OFF_DEFAULT_VALUE)
        }

        static var level: esp_zb_level_cluster_cfg_t {
            esp_zb_level_cluster_cfg_t(current_level: ESP_ZB_ZCL_LEVEL_CONTROL_CURRENT_LEVEL_DEFAULT_VALUE)
        }

        static var color: esp_zb_color_cluster_cfg_t {
           esp_zb_color_cluster_cfg_t(
            current_x: ESP_ZB_ZCL_COLOR_CONTROL_CURRENT_X_DEF_VALUE, 
            current_y: ESP_ZB_ZCL_COLOR_CONTROL_CURRENT_Y_DEF_VALUE, 
            color_mode: ESP_ZB_ZCL_COLOR_CONTROL_COLOR_MODE_DEFAULT_VALUE, 
            options: ESP_ZB_ZCL_COLOR_CONTROL_OPTIONS_DEFAULT_VALUE, 
            enhanced_color_mode: ESP_ZB_ZCL_COLOR_CONTROL_ENHANCED_COLOR_MODE_DEFAULT_VALUE, 
            color_capabilities: colorCapabilities) 
        }
    }

    static var config: esp_zb_color_dimmable_light_cfg_t {
        esp_zb_color_dimmable_light_cfg_t(
            basic_cfg: cluster.basic,
            identify_cfg: cluster.identity,
            groups_cfg: cluster.groups,
            scenes_cfg: cluster.scenes,
            on_off_cfg: cluster.onOff,
            level_cfg: cluster.level,
            color_cfg: cluster.color)
    }
}


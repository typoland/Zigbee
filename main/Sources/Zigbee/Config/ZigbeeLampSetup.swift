enum ZigbeeLamp {
    static var installCodePolicy = false

    static var endPointConfig: esp_zb_cfg_t {
        let endPointConfig = esp_zb_zed_cfg_t (
            ed_timeout: UInt8(6),  //Uint16(ESP_ZB_ED_AGING_TIMEOUT_64MIN)),
            keep_alive: 3000
        )
        var networkConfigUnion: esp_zb_cfg_s.__Unnamed_union_nwk_cfg =
            esp_zb_cfg_s.__Unnamed_union_nwk_cfg()

        withUnsafeMutablePointer(to: &networkConfigUnion) {
            $0.withMemoryRebound(to: esp_zb_zed_cfg_t.self, capacity: 1) {
                $0.pointee = endPointConfig
            }
        }
        return esp_zb_cfg_t(
            esp_zb_role: ESP_ZB_DEVICE_TYPE_ED,
            install_code_policy: installCodePolicy,
            nwk_cfg: networkConfigUnion)
    }

    enum light {
        //Because of c macros
        static var ESP_ZB_ZCL_ON_OFF_ON_OFF_DEFAULT_VALUE: Bool = false
        static var ESP_ZB_ZCL_ON_OFF_GLOBAL_SCENE_CONTROL_DEFAULT_VALUE: Bool = true
        static var ESP_ZB_ZCL_ON_OFF_ON_TIME_DEFAULT_VALUE: UInt16 = 0x0000
        static var ESP_ZB_ZCL_ON_OFF_OFF_WAIT_TIME_DEFAULT_VALUE: UInt16 = 0x0000
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
                esp_zb_on_off_cluster_cfg_t(on_off: light.ESP_ZB_ZCL_ON_OFF_ON_OFF_DEFAULT_VALUE)
            }
        }

        static var config: esp_zb_on_off_light_cfg_t {
            esp_zb_on_off_light_cfg_t(
                basic_cfg: cluster.basic,
                identify_cfg: cluster.identity,
                groups_cfg: cluster.groups,
                scenes_cfg: cluster.scenes,
                on_off_cfg: cluster.onOff)
        }
    }

    enum radio {
        static var defaultConfig: esp_zb_radio_config_t {
            .init(
                radio_mode: RadioMode.native.esp,
                radio_uart_config: .init()
            )
        }
    }

    enum host {
        static var defaultConfig: esp_zb_host_config_t {
            .init(
                host_connection_mode: HostConnectionMode.none.esp,
                host_uart_config: .init()
            )
        }
    }

    enum platform {
        static var config: esp_zb_platform_config_t {
            .init(
                radio_config: radio.defaultConfig,
                host_config:  host.defaultConfig
            )
        }
    }
}

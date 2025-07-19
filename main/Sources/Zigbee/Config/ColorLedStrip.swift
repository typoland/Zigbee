struct ColorLedStip {
    static var manufacturerName = [CChar(0x06)] + "Lampka".utf8.map{CChar($0)}
    static var modelIdentifier = [CChar(0x0F)] + "RGB Party Strip".utf8.map{CChar($0)}

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
        static var basic = ZCLCluster.Basic.Default.config
        static var identify = ZCLCluster.Identify.Default.config
        static var onoff = ZCLCluster.OnOff.Default.config
        static var level = ZCLCluster.Level.Default.config
        static var colorControl = ZCLCluster.ColorControl.Default.config
    }

    // static var config = DimmableLightConfig(
    //     basic: cluster.basic,
    //     identify: cluster.identify,
    //     onOff: cluster.onoff,
    //     level: cluster.level,
    //     colorControl: cluster.colorControl)

    static var clusterList: UnsafeMutablePointer<esp_zb_cluster_list_t>? {
        let clusterList: UnsafeMutablePointer<esp_zb_cluster_list_t>? = esp_zb_zcl_cluster_list_create()
        let basicCluster = esp_zb_basic_cluster_create(&cluster.basic)
        let identifyCluster = esp_zb_identify_cluster_create(&cluster.identify)
        let onoffCluster = esp_zb_on_off_cluster_create(&cluster.onoff)
        let levelCluster = esp_zb_level_cluster_create(&cluster.level)
        let colorCluster = esp_zb_color_control_cluster_create(&cluster.colorControl)

        do {
            try runEsp {
                esp_zb_basic_cluster_add_attr(basicCluster,
                    UInt16(ESP_ZB_ZCL_ATTR_BASIC_MANUFACTURER_NAME_ID.rawValue),
                    &manufacturerName)
            }
            try runEsp {
                esp_zb_basic_cluster_add_attr(basicCluster,
                    UInt16(ESP_ZB_ZCL_ATTR_BASIC_MODEL_IDENTIFIER_ID.rawValue),
                    &modelIdentifier)
            }
            try runEsp {
                esp_zb_cluster_list_add_basic_cluster(
                    clusterList, 
                    basicCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            try runEsp {
                esp_zb_cluster_list_add_identify_cluster(
                    clusterList, 
                    identifyCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            try runEsp {
                esp_zb_cluster_list_add_on_off_cluster(
                    clusterList, 
                    onoffCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            try runEsp {
                esp_zb_cluster_list_add_level_cluster(
                    clusterList, 
                    levelCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            try runEsp {
                esp_zb_cluster_list_add_color_control_cluster(
                    clusterList, 
                    colorCluster, 
                    ZCLClusterRole.server.rawValue)
            }
        } catch {
            print("CLUSTERLIST ERROR: \(error.description)")
            return nil
        }

        return clusterList
    }
}
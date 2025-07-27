struct ColorLedStripConfig {
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

    enum cluster {
        static var basic = BasicCluster.config
        static var identify = IdentifyCluster.config
        static var onoff = OnOffCluster.config
        static var level = LevelCluster.config
        static var colorControl = ColorControlCluster.config
        static var groups = GroupsCluster.config
        static var scenes = ScenesCluster.config
    }

    static var clusterList: UnsafeMutablePointer<esp_zb_cluster_list_t>? {
        
        let clusterList: UnsafeMutablePointer<esp_zb_cluster_list_t>? = esp_zb_zcl_cluster_list_create()
        
        let basicCluster = esp_zb_basic_cluster_create(&cluster.basic)
        let identifyCluster = esp_zb_identify_cluster_create(&cluster.identify)
        let onoffCluster = esp_zb_on_off_cluster_create(&cluster.onoff)
        let levelCluster = esp_zb_level_cluster_create(&cluster.level)
        let colorCluster = esp_zb_color_control_cluster_create(&cluster.colorControl)
        let groupsCluster = esp_zb_groups_cluster_create(&cluster.groups)
        let scenesCuster = esp_zb_scenes_cluster_create(&cluster.scenes)

        do {
            try runEsp {
                esp_zb_basic_cluster_add_attr(basicCluster,
                    BasicCluster.Attribute.manufacturerName.rawValue,// ESP_ZB_ZCL_ATTR_BASIC_MANUFACTURER_NAME_ID.rawValue),
                    &manufacturerName)
            }
            try runEsp {
                esp_zb_basic_cluster_add_attr(basicCluster,
                    BasicCluster.Attribute.modelIdentifier.rawValue,
                    &modelIdentifier)
            }
            try runEsp {
                esp_zb_cluster_list_add_basic_cluster(
                    clusterList, 
                    basicCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            print ("💡 basic cluster added")
            try runEsp {
                esp_zb_cluster_list_add_identify_cluster(
                    clusterList, 
                    identifyCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            print ("💡 identify cluster added")
            try runEsp {
                esp_zb_cluster_list_add_on_off_cluster(
                    clusterList, 
                    onoffCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            print ("💡 on/off cluster added")
            try runEsp {
                esp_zb_cluster_list_add_level_cluster(
                    clusterList, 
                    levelCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            print ("💡 level cluster added")
            try runEsp {
                esp_zb_cluster_list_add_color_control_cluster(
                    clusterList, 
                    colorCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            print ("💡 color control cluster added")
            try runEsp {
                esp_zb_cluster_list_add_groups_cluster(
                    clusterList, 
                    groupsCluster, 
                    ZCLClusterRole.server.rawValue)
            }
            print ("💡 groups cluster added")
            try runEsp {
                esp_zb_cluster_list_add_scenes_cluster(
                    clusterList, 
                    scenesCuster, 
                    ZCLClusterRole.server.rawValue)
            }
            print ("💡 scenes cluster added")
           
        } catch {
            print("CLUSTERLIST ERROR: \(error.description)")
            return nil
        }

        return clusterList
    }
}
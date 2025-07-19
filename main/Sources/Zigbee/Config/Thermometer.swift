struct Thermometer {
    static var manufacturerName = [CChar(0x09)] + "Balangano".utf8.map{CChar($0)}
    static var modelIdentifier = [CChar(0x0C)] + "Play with me".utf8.map{CChar($0)}

    static var info: zcl_basic_manufacturer_info_t = manufacturerName.withUnsafeMutableBufferPointer {
        namePtr in
        modelIdentifier.withUnsafeMutableBufferPointer { modelPtr in
            return zcl_basic_manufacturer_info_t(
                manufacturer_name: namePtr.baseAddress,
                model_identifier: modelPtr.baseAddress
            )
        }
    }

    static var endpointId: UInt8 = 11
    static var primaryChannelMask = ESP_ZB_TRANSCEIVER_ALL_CHANNELS_MASK

    enum cluster {
        static var basic = ZCLCluster.Basic.Default.config
        static var identify = ZCLCluster.Identify.Default.config
        
        static var tempMeasure = TemperatureMeasureConfig(
            measuredValue: ZCLTemperatureMeasurement.Default.measuredValue, 
            min: ZCLTemperatureMeasurement.Default.minMeasuredValue, 
            max: ZCLTemperatureMeasurement.Default.maxMeasuredValue)
    }
    static var config = TemperatureSensorConfig (
        basic: cluster.basic, 
        identify: cluster.identify, 
        tempMeasure: cluster.tempMeasure
    )
// ESP_ERROR_CHECK(
// esp_zb_cluster_list_add_temperature_meas_cluster(
// cluster_list, 
// esp_zb_temperature_meas_cluster_create(&(temperature_sensor->temp_meas_cfg)),
//  ESP_ZB_ZCL_CLUSTER_SERVER_ROLE));
    static var clusterList: UnsafeMutablePointer<esp_zb_cluster_list_t>? {
        let clusterList = esp_zb_zcl_cluster_list_create()
        let basicCluster = esp_zb_basic_cluster_create(&cluster.basic)
        let identifyCluster = esp_zb_identify_cluster_create(&cluster.identify)
        let attributesCluster =  esp_zb_zcl_attr_list_create(UInt16(ESP_ZB_ZCL_CLUSTER_ID_IDENTIFY.rawValue))
        let measureCluster = esp_zb_temperature_meas_cluster_create(&cluster.tempMeasure)
        do {
            try runEsp { esp_zb_basic_cluster_add_attr(
                basicCluster, 
                ZCLCluster.Basic.Attribute.manufacturerName.rawValue,
                &manufacturerName) }
            print ("🔺Basic Name Done")
            try runEsp {esp_zb_basic_cluster_add_attr(
                basicCluster, 
                ZCLCluster.Basic.Attribute.modelIdentifier.rawValue,
                &modelIdentifier)} 
            print ("🔺 Basic Model Done")
            try runEsp {
                esp_zb_cluster_list_add_basic_cluster(
                    clusterList, 
                    basicCluster, 
                    ZCLClusterRole.server.rawValue)}
            print ("🔺 Basic Cluster Add Done")
            try runEsp {
                esp_zb_cluster_list_add_identify_cluster(
                    clusterList, 
                    identifyCluster, 
                    ZCLClusterRole.server.rawValue)}
            print ("🔺 Identify Cluster Add Done")
            try runEsp {
                esp_zb_cluster_list_add_identify_cluster(
                    clusterList, 
                    attributesCluster, 
                    ZCLClusterRole.client.rawValue)}
            print ("🔺 Attributes Cluster Add Done")
            try runEsp {
                esp_zb_cluster_list_add_temperature_meas_cluster(
                    clusterList, 
                    measureCluster, 
                    ZCLClusterRole.server.rawValue)}
            print ("🔺 Measure Cluster Add Done")
           
        }  catch {
            print ("CLUSTERLIST ERROR: \(error.description)")
            return nil
        }
        return clusterList
    }

    static var reportingInfo = ReportingInfo (
            direction: .toServer, 
            endpointID: 11, 
            clusterID: .temperatureMeasurement, 
            clusterRole: .server, 
            attributesID: .measuredValue, 
            flags: 0, 
            runtime: 0, 
            intervals: .init(
                min: 1,
                max: 0,
                delta: 100,
                reportedValue: .init(),
                defaultMin: 1,
                defaultMax: 0
            ),
            destination: .init(
                profileID: ZigbeeProfileID.homeAutomation.rawValue),// UInt16(ESP_ZB_AF_HA_PROFILE_ID.rawValue)),//.init()),
            manufacturerCode: UInt16(ESP_ZB_ZCL_ATTR_NON_MANUFACTURER_SPECIFIC)) // esp_zb_zcl_reporting_info_s.__Unnamed_struct_dst, manuf_code: UInt16)
}

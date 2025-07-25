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
        attributesID: TemperatureMeasurmentsCluster.Attributes, // TemperatureMeasurement,
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
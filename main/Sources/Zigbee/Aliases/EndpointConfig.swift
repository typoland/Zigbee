typealias EndpointConfig = esp_zb_endpoint_config_t
extension EndpointConfig {
    init (
        id: UInt8,
        profileID: ZigbeeProfileID,
        deviceID: HADeviceID,
        appVersion: UInt32
    ) { self = .init(
            endpoint: id, 
            app_profile_id:  profileID.rawValue, 
            app_device_id: deviceID.rawValue,
            app_device_version: appVersion)
    }
}
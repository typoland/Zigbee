struct TemperatureSensor {
    static var manufacturerName = [CChar(0x07)] + "TERMOMETR".utf8.map{CChar($0)}
    static var modelIdentifier = [CChar(0x05)] + "OJEJ".utf8.map{CChar($0)}
    
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

    static var c: esp_zb_zcl_temp_meas_attrs_t = .init

}
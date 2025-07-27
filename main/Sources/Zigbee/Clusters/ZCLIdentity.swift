struct IdentifyCluster {
    // MARK: - Attribute IDs
    public enum Attribute: UInt16 {
        case  identifyTime = 0x0000  // Identify time attribute
    }

    // MARK: - Command Identifiers

    public enum Command: UInt8 {
        case identify       = 0x00  // Identify command
        case identifyQuery  = 0x01  // Identify query command
        case triggerEffect  = 0x40  // Trigger effect command
    }

    // MARK: - Server-to-Client Responses

    public enum ResponseCommand: UInt8 {
        case identifyQuery = 0x00  // Response to Identify Query
    }

    // MARK: - Trigger Effect Identifiers

    public enum TriggerEffect: UInt8 {
        case blink          = 0x00  // Light is turned on/off once
        case breathe        = 0x01  // Light fades on/off over 1s, repeated 15 times
        case okay           = 0x02  // Green for 1s or flashes twice (non-colored)
        case channelChange  = 0x0B  // Orange for 8s or brightness swing
        case finishEffect   = 0xFE  // Finish current effect sequence before ending
        case stop           = 0xFF  // Stop the effect immediately
    }
}

extension IdentifyCluster {
    static var config = Default.config
    enum Default {
        static var config = IdentifyClusterConfig (
                identifyTime: identifyTime)
    // MARK: - Default Values

    public static let identifyTime: UInt16 = 0x0000  // Default value for Identify attribute

    }
}

typealias IdentifyClusterConfig = esp_zb_identify_cluster_cfg_t
extension IdentifyClusterConfig {
    /*!<  The remaining length of the time that identify itself */
    init(identifyTime: UInt16) {
        self = .init(identify_time: identifyTime)
    }
}
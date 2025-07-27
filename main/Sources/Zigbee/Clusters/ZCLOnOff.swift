struct OnOffCluster  {


    // MARK: - Attribute IDs

    enum Attributes:UInt16 {
        case onOff              = 0x0000  // OnOff attribute
        case globalSceneControl = 0x4000  // Global Scene Control attribute
        case onTime             = 0x4001  // On Time attribute
        case offWaitTime        = 0x4002  // Off Wait Time attribute
        case startUpOnOff       = 0x4003  // Startup behavior attribute
    }

    

    // MARK: - Command Identifiers

    public enum Command: UInt8 {
        case off                          = 0x00  // "Turn off" command
        case on                           = 0x01  // "Turn on" command
        case toggle                       = 0x02  // "Toggle state" command
        case offWithEffect                = 0x40  // "Off with effect" command
        case onWithRecallGlobalScene      = 0x41  // "On with recall global scene" command
        case onWithTimedOff               = 0x42  // "On with timed off" command
    }
}


extension OnOffCluster {
    static var config = Default.config
    enum Default {
        // MARK: - Default Values
        static var config = OnOffClusterConfig (
                onOff: onOff)

        public static let onOff: Bool               = true  // Default OnOff state
        public static let globalSceneControl: Bool  = true   // Default Global Scene Control
        public static let onTime: UInt16            = 0x0000 // Default On Time
        public static let offWaitTime: UInt16       = 0x0000 // Default Off Wait Time
        public static let startUpOnOff: UInt8 = 0xFF  // Default startup behavior (restore previous state)
    }
}
typealias OnOffClusterConfig = esp_zb_on_off_cluster_cfg_t
extension OnOffClusterConfig {
    init(onOff: Bool) {
        self = .init(on_off: onOff)
    }
}
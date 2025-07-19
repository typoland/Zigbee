extension ZCLCluster.Level  {
    // MARK: - Attribute IDs

    enum Attributes:UInt16 {
        case currentLevel             = 0x0000  // Current Level
        case remainingTime            = 0x0001  // Remaining Time
        case minLevel                 = 0x0002  // Minimum allowed level
        case maxLevel                 = 0x0003  // Maximum allowed level
        case currentFrequency         = 0x0004  // Current frequency at level
        case minFrequency             = 0x0005  // Minimum frequency
        case maxFrequency             = 0x0006  // Maximum frequency
        case options                  = 0x000F  // Options bitmap
        case onOffTransitionTime      = 0x0010  // On/Off transition time
        case onLevel                  = 0x0011  // On Level
        case onTransitionTime         = 0x0012  // On transition time
        case offTransitionTime        = 0x0013  // Off transition time
        case defaultMoveRate          = 0x0014  // Default movement rate
        case startUpCurrentLevel      = 0x4000  // Desired level at startup
        case moveStatusInternal       = 0xEFFF  // Internal move status
    }
   

    
    // MARK: - Command Identifiers

    public enum Command: UInt8 {
        case moveToLevel               = 0x00  // Move To Level
        case move                      = 0x01  // Move
        case step                      = 0x02  // Step
        case stop                      = 0x03  // Stop
        case moveToLevelWithOnOff      = 0x04  // Move To Level with On/Off
        case moveWithOnOff             = 0x05  // Move with On/Off
        case stepWithOnOff             = 0x06  // Step with On/Off
        case stopWithOnOff             = 0x07  // Stop with On/Off
        case moveToClosestFrequency    = 0x08  // Move to Closest Frequency
    }
}

extension ZCLCluster.Level {
    enum Default {
        static var config = LevelClusterConfig (
                currentLevel: currentLevel)
        // MARK: - Default Values

        public static let currentLevel: UInt8            = 0xFF  // Undefined level
        public static let remainingTime: UInt16          = 0x0000
        public static let minLevel: UInt8                = 0x00
        public static let maxLevel: UInt8                = 0xFF
        public static let currentFrequency: UInt16       = 0x0000
        public static let minFrequency: UInt16           = 0x0000
        public static let maxFrequency: UInt16           = 0x0000
        public static let onOffTransitionTime: UInt16    = 0x0000
        public static let onLevel: UInt8                 = 0xFF  // Use previous level
        public static let onTransitionTime: UInt16       = 0xFFFF
        public static let offTransitionTime: UInt16      = 0xFFFF
        public static let defaultMoveRate: UInt8         = 0xFF
        public static let options: UInt8                 = 0x00
        public static let startUpCurrentLevel: UInt8     = 0xFF  // Use previous level
    }
}
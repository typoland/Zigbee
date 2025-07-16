public enum ZCLLevel:UInt16 {
    // MARK: - Attribute IDs

    
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
   

    // MARK: - Default Values

    public static let currentLevelDefault: UInt8            = 0xFF  // Undefined level
    public static let remainingTimeDefault: UInt16          = 0x0000
    public static let minLevelDefault: UInt8                = 0x00
    public static let maxLevelDefault: UInt8                = 0xFF
    public static let currentFrequencyDefault: UInt16       = 0x0000
    public static let minFrequencyDefault: UInt16           = 0x0000
    public static let maxFrequencyDefault: UInt16           = 0x0000
    public static let onOffTransitionTimeDefault: UInt16    = 0x0000
    public static let onLevelDefault: UInt8                 = 0xFF  // Use previous level
    public static let onTransitionTimeDefault: UInt16       = 0xFFFF
    public static let offTransitionTimeDefault: UInt16      = 0xFFFF
    public static let defaultMoveRateDefault: UInt8         = 0xFF
    public static let optionsDefault: UInt8                 = 0x00
    public static let startUpCurrentLevelDefault: UInt8     = 0xFF  // Use previous level

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
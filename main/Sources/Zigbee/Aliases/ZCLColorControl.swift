public enum ZCLColorControl: UInt16 {
    // MARK: - Attribute IDs

    
    case currentHue                        = 0x0000  // Current Hue
    case currentSaturation                 = 0x0001  // Current Saturation
    case remainingTime                     = 0x0002  // Remaining Time
    case currentX                          = 0x0003  // Current X
    case currentY                          = 0x0004  // Current Y
    case driftCompensation                 = 0x0005  // Drift Compensation
    case compensationText                  = 0x0006  // Compensation Text
    case colorTemperatureMireds            = 0x0007  // Color Temperature
    case colorMode                         = 0x0008  // Color Mode
    case options                           = 0x000F  // Options bitmap
    case enhancedCurrentHue                = 0x4000  // Enhanced Current Hue
    case enhancedColorMode                 = 0x4001  // Enhanced Color Mode
    case colorLoopActive                   = 0x4002  // Color Loop Active
    case colorLoopDirection                = 0x4003  // Color Loop Direction
    case colorLoopTime                     = 0x4004  // Color Loop Time
    case colorLoopStartEnhancedHue         = 0x4005  // Color Loop Start Enhanced Hue
    case colorLoopStoredEnhancedHue        = 0x4006  // Color Loop Stored Enhanced Hue
    case colorCapabilities                 = 0x400A  // Color Capabilities
    case colorTempPhysicalMinMireds        = 0x400B  // Min supported temperature (mireds)
    case colorTempPhysicalMaxMireds        = 0x400C  // Max supported temperature (mireds)
    case coupleColorTempToLevelMinMireds   = 0x400D  // Minimum temp linked to level
    case startUpColorTemperatureMireds     = 0x4010  // Startup color temp
   

    // MARK: - Default Values

    public static let currentHueDefault: UInt8                      = 0x00
    public static let currentSaturationDefault: UInt8              = 0x00
    public static let remainingTimeDefault: UInt16                 = 0x0000
    public static let currentXDefault: UInt16                      = 0x616B
    public static let currentYDefault: UInt16                      = 0x607D
    public static let colorTemperatureDefault: UInt16              = 0x00FA
    public static let colorModeDefault: UInt8                      = 0x01
    public static let optionsDefault: UInt8                        = 0x00
    public static let enhancedCurrentHueDefault: UInt16            = 0x0000
    public static let enhancedColorModeDefault: UInt8              = 0x01
    public static let colorLoopActiveDefault: UInt8                = 0x00
    public static let colorLoopDirectionDefault: UInt8             = 0x00
    public static let colorLoopTimeDefault: UInt16                 = 0x0019
    public static let colorLoopStartEnhancedHueDefault: UInt16     = 0x2300
    public static let colorLoopStoredEnhancedHueDefault: UInt16    = 0x0000
    public static let colorCapabilitiesDefault: UInt16             = 0x0000
    public static let colorTempPhysicalMinMiredsDefault: UInt16    = 0x0000
    public static let colorTempPhysicalMaxMiredsDefault: UInt16    = 0xFEFF

    // MARK: - Command Identifiers

    public enum Command: UInt8 {
        case moveToHue                     = 0x00  // Move To Hue
        case moveHue                       = 0x01  // Move Hue
        case stepHue                       = 0x02  // Step Hue
        case moveToSaturation              = 0x03  // Move To Saturation
        case moveSaturation                = 0x04  // Move Saturation
        case stepSaturation                = 0x05  // Step Saturation
        case moveToHueSaturation           = 0x06  // Move To Hue and Saturation
        case moveToColor                   = 0x07  // Move To Color
        case moveColor                     = 0x08  // Move Color
        case stepColor                     = 0x09  // Step Color
        case moveToColorTemperature        = 0x0A  // Move to Color Temperature

        case enhancedMoveToHue             = 0x40  // Enhanced Move To Hue
        case enhancedMoveHue               = 0x41  // Enhanced Move Hue
        case enhancedStepHue               = 0x42  // Enhanced Step Hue
        case enhancedMoveToHueSaturation   = 0x43  // Enhanced Move To Hue and Saturation
        case colorLoopSet                  = 0x44  // Color Loop Set
        case stopMoveStep                  = 0x47  // Stop Move Step
        case moveColorTemperature          = 0x4B  // Move Color Temperature
        case stepColorTemperature          = 0x4C  // Step Color Temperature
    }

    // MARK: - Move to Hue Direction

    public enum MoveToHueDirection: UInt8 {
        case shortest = 0x00  // Shortest distance
        case longest  = 0x01  // Longest distance
        case up       = 0x02  // Increase
        case down     = 0x03  // Decrease
    }

    // MARK: - Move Mode

    public enum MoveMode: UInt8 {
        case stop = 0x00  // Stop
        case up   = 0x01  // Increase
        case down = 0x03  // Decrease
    }

    // MARK: - Step Mode

    public enum StepMode: UInt8 {
        case up   = 0x01  // Increase
        case down = 0x03  // Decrease
    }
}
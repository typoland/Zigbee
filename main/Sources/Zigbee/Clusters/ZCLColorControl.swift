struct ColorControlCluster: Cluster {
    typealias Config =  esp_zb_color_cluster_cfg_t
    var attributeList: UnsafeMutablePointer<esp_zb_attribute_list_t>
    static let addAttribute     = esp_zb_color_control_cluster_add_attr
    static let addToClusterList = esp_zb_cluster_list_add_color_control_cluster
    
    init(config: inout Config) {
        self.attributeList = esp_zb_color_control_cluster_create(&config)
    }
    
    enum Attribute : UInt16 {
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
    }
}
extension ColorControlCluster.Config: ClusterConfig  { 
    init(
        currentX: UInt16,
        currentY: UInt16,
        colorMode: UInt8,
        options: UInt8,
        enhancedColorMode: UInt8,
        colorCapabilities: [Self.ColorCapability]
    ) {
        self = .init(
            current_x: currentX,
            current_y: currentY,
            color_mode: colorMode,
            options: options,
            enhanced_color_mode: enhancedColorMode,
            color_capabilities: 1<<3 //ZCLCluster.ColorControl.ColorCapability.value(colorCapabilities)
        )
    }
    // MARK: - Attribute IDs

    
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

    enum ColorCapability: UInt16 {
        case hueSaturation     = 0b0000  // Bit 0
        case enhancedHue       = 0b0001  // Bit 1
        case colorLoop         = 0b0010  // Bit 2
        case xy                = 0b0100  // Bit 3
        case colorTemperature  = 0b1000  // Bit 4
        static func value(_ capabilities: [ColorCapability]) -> UInt16 {
    capabilities.reduce(0) { $0 | $1.rawValue }
}
    }

    static var `default` = Self (
                currentX: Default.currentX, 
                currentY: Default.currentY, 
                colorMode: Default.colorMode, 
                options: Default.options, 
                enhancedColorMode: Default.enhancedColorMode, 
                colorCapabilities: [.xy]) 
    
    enum Default {
        
    // MARK: - Default Values

    public static let currentHue: UInt8                      = 0x00
    public static let currentSaturatio: UInt8              = 0x00
    public static let remainingTime: UInt16                 = 0x0000
    public static let currentX: UInt16                      = 0x616B
    public static let currentY: UInt16                      = 0x607D
    public static let colorTemperature: UInt16              = 0x00FA
    public static let colorMode: UInt8                      = 0x01
    public static let options: UInt8                        = 0x00
    public static let enhancedCurrentHue: UInt16            = 0x0000
    public static let enhancedColorMode: UInt8              = 0x01
    public static let colorLoopActivet: UInt8                = 0x00
    public static let colorLoopDirection: UInt8             = 0x00
    public static let colorLoopTime: UInt16                 = 0x0019
    public static let colorLoopStartEnhancedHue: UInt16     = 0x2300
    public static let colorLoopStoredEnhancedHue: UInt16    = 0x0000
    public static let colorCapabilities: UInt16             = 0x0000
    public static let colorTempPhysicalMinMireds: UInt16    = 0x0000
    public static let colorTempPhysicalMaxMireds: UInt16    = 0xFEFF
    }
}


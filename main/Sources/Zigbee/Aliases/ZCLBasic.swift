public enum ZCLBasic {
    public enum BasicAttribute: UInt16 {
        case zclVersion                  = 0x0000  // ZCL version attribute
        case applicationVersion          = 0x0001  // Application version attribute
        case stackVersion                = 0x0002  // Stack version attribute
        case hardwareVersion             = 0x0003  // Hardware version attribute
        case manufacturerName            = 0x0004  // Manufacturer name attribute
        case modelIdentifier             = 0x0005  // Model identifier attribute
        case dateCode                   = 0x0006  // Date code attribute
        case powerSource                = 0x0007  // Power source attribute
        case genericDeviceClass         = 0x0008  // Field of application of the GenericDeviceType attribute
        case genericDeviceType          = 0x0009  // Icon shown in rich UI (e.g., smartphone app)
        case productCode                = 0x000A  // Code for the product
        case productURL                 = 0x000B  // Web page containing specific product information
        case manufacturerVersionDetails = 0x000C  // Vendor-specific string representing versions of supported program images
        case serialNumber               = 0x000D  // Vendor-specific serial number
        case productLabel               = 0x000E  // Vendor-specific product label
        case locationDescription        = 0x0010  // Location description attribute
        case physicalEnvironment        = 0x0011  // Physical environment attribute
        case deviceEnabled              = 0x0012  // Device enabled attribute
        case alarmMask                  = 0x0013  // Alarm mask attribute
        case disableLocalConfig         = 0x0014  // Disable local config attribute
        case softwareBuildID            = 0x4000  // Manufacturer-specific reference to software version
    }

    public enum PowerSource: UInt8 {
        case unknown                = 0x00  // Unknown power source
        case mainsSinglePhase       = 0x01  // Single-phase mains
        case mainsThreePhase        = 0x02  // 3-phase mains
        case battery                = 0x03  // Battery source
        case dcSource               = 0x04  // DC source
        case emergencyMainsConstant = 0x05  // Emergency mains constantly powered
        case emergencyMainsTransfer = 0x06  // Emergency mains and transfer switch
    }
    public static func secondaryPowerSource(_ power: PowerSource) -> UInt8 {
        return 0x80 + power.rawValue  // (1 << 7) + power
    }

    public static let zclVersion: UInt8 = 0x08                      // Default ZCL version
    public static let applicationVersion: UInt8 = 0x00              // Default application version
    public static let stackVersion: UInt8 = 0x00                    // Default stack version
    public static let hardwareVersion: UInt8 = 0x00                 // Default hardware version

    public static let manufacturerName: [UInt8] = []                // Default: empty string
    public static let modelIdentifier: [UInt8] = []                 // Default: empty string
    public static let dateCode: [UInt8] = []                        // Default: empty string
    public static let powerSource: PowerSource = .unknown                     // Default power source
    public static let genericDeviceClass: UInt8 = 0xFF              // Default generic device class
    public static let genericDeviceType: UInt8 = 0xFF               // Default generic device type
    public static let productCode: [UInt8] = []                     // Default product code
    public static let productURL: [UInt8] = []                      // Default product URL
    public static let manufacturerVersionDetails: [UInt8] = []     // Default version details
    public static let serialNumber: [UInt8] = []                    // Default serial number
    public static let productLabel: [UInt8] = []                    // Default product label
    public static let locationDescription: [UInt8] = []            // Default location description
    public static let physicalEnvironment: UInt8 = 0x00            // Default physical environment
    public static let deviceEnabled: Bool = true                   // Default device enabled
    public static let alarmMask: UInt8 = 0x00                      // Default alarm mask
    public static let disableLocalConfig: UInt8 = 0x00             // Default disable local config

    /// Default SW build ID in Pascal-style string (length + 16 bytes)
    public static let softwareBuildID: [UInt8] = Array(repeating: 0, count: 17)
}
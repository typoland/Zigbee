public enum ZigbeeProfileID: UInt16 {
    case homeAutomation = 0x0104  // HA profile ID
    case smartEnergy    = 0x0109  // SE profile ID
    case zigbeeLightLink = 0xC05E // ZLL profile ID
    case greenPower     = 0xA1E0  // GreenPower profile ID
}
public enum HADeviceID: UInt16 {
    case onOffSwitch                    = 0x0000  // General On/Off switch
    case levelControlSwitch            = 0x0001  // Level Control Switch
    case onOffOutput                   = 0x0002  // General On/Off output
    case levelControllableOutput       = 0x0003  // Level Controllable Output
    case sceneSelector                 = 0x0004  // Scene Selector
    case configurationTool             = 0x0005  // Configuration Tool
    case remoteControl                 = 0x0006  // Remote Control
    case combinedInterface             = 0x0007  // Combined Interface
    case rangeExtender                 = 0x0008  // Range Extender
    case mainsPowerOutlet              = 0x0009  // Mains Power Outlet
    case doorLock                      = 0x000A  // Door Lock Client
    case doorLockController            = 0x000B  // Door Lock Controller
    case simpleSensor                  = 0x000C  // Simple Sensor
    case consumptionAwareness          = 0x000D  // Consumption Awareness
    case homeGateway                   = 0x0050  // Home Gateway
    case smartPlug                     = 0x0051  // Smart Plug
    case whiteGoods                    = 0x0052  // White Goods
    case meterInterface                = 0x0053  // Meter Interface
    case onOffLight                    = 0x0100  // On/Off Light
    case dimmableLight                 = 0x0101  // Dimmable Light
    case colorDimmableLight            = 0x0102  // Color Dimmable Light
    case dimmerSwitch                  = 0x0104  // Dimmer Switch
    case colorDimmerSwitch             = 0x0105  // Color Dimmer Switch
    case lightSensor                   = 0x0106  // Light Sensor
    case shade                         = 0x0200  // Shade
    case shadeController               = 0x0201  // Shade Controller
    case windowCoveringClient          = 0x0202  // Window Covering Client
    case windowCoveringController      = 0x0203  // Window Covering Controller
    case heatingCoolingUnit            = 0x0300  // Heating/Cooling Unit
    case thermostat                    = 0x0301  // Thermostat
    case temperatureSensor             = 0x0302  // Temperature Sensor
    case iasCIE                        = 0x0400  // IAS Control and Indicating Equipment
    case iasAncillaryControlEquipment  = 0x0401  // IAS Ancillary Control Equipment
    case iasZone                       = 0x0402  // IAS Zone
    case iasWarningDevice              = 0x0403  // IAS Warning Device
    case testDevice                    = 0xFFF0  // Custom Test Device
    case customTunnelDevice            = 0xFFF1  // Custom Tunnel Device
    case customAttrDevice              = 0xFFF2  // Custom Attributes Device
}

public enum ZCLClusterRole: UInt8 {
    case server = 0x01  // Server cluster role
    case client = 0x02  // Client cluster role
}


public enum ZCLClusterID: UInt16 {
    case basic                       = 0x0000  // Basic
    case powerConfiguration          = 0x0001  // Power configuration
    case deviceTemperatureConfig     = 0x0002  // Device temperature configuration
    case identify                    = 0x0003  // Identify
    case groups                      = 0x0004  // Groups
    case scenes                      = 0x0005  // Scenes
    case onOff                       = 0x0006  // On/Off
    case onOffSwitchConfig           = 0x0007  // On/Off switch configuration
    case levelControl                = 0x0008  // Level control
    case alarms                      = 0x0009  // Alarms
    case time                        = 0x000A  // Time
    case rssiLocation                = 0x000B  // RSSI location
    case analogInput                 = 0x000C  // Analog input (basic)
    case analogOutput                = 0x000D  // Analog output (basic)
    case analogValue                 = 0x000E  // Analog value (basic)
    case binaryInput                 = 0x000F  // Binary input (basic)
    case binaryOutput                = 0x0010  // Binary output (basic)
    case binaryValue                 = 0x0011  // Binary value (basic)
    case multiInput                  = 0x0012  // Multistate input (basic)
    case multiOutput                 = 0x0013  // Multistate output (basic)
    case multiValue                  = 0x0014  // Multistate value (basic)
    case commissioning               = 0x0015  // Commissioning
    case otaUpgrade                  = 0x0019  // Over The Air upgrade
    case pollControl                 = 0x0020  // Poll control
    case greenPower                  = 0x0021  // Green Power
    case keepAlive                   = 0x0025  // Keep Alive

    case shadeConfig                 = 0x0100  // Shade configuration
    case doorLock                    = 0x0101  // Door lock
    case windowCovering             = 0x0102  // Window covering

    case pumpConfigControl           = 0x0200  // Pump configuration and control
    case thermostat                  = 0x0201  // Thermostat
    case fanControl                  = 0x0202  // Fan control
    case dehumidificationControl     = 0x0203  // Dehumidification control
    case thermostatUIConfig          = 0x0204  // Thermostat UI configuration

    case colorControl                = 0x0300  // Color control
    case ballastConfig               = 0x0301  // Ballast configuration

    case illuminanceMeasurement      = 0x0400  // Illuminance measurement
    case temperatureMeasurement      = 0x0402  // Temperature measurement
    case pressureMeasurement         = 0x0403  // Pressure measurement
    case flowMeasurement             = 0x0404  // Flow measurement
    case relativeHumidityMeasurement = 0x0405  // Relative humidity measurement
    case occupancySensing            = 0x0406  // Occupancy sensing
    case pHMeasurement               = 0x0409  // pH measurement
    case ecMeasurement               = 0x040A  // Electrical conductivity
    case windSpeedMeasurement        = 0x040B  // Wind speed
    case carbonDioxideMeasurement    = 0x040D  // CO₂ measurement
    case pm2_5Measurement            = 0x042A  // PM2.5 measurement

    case iasZone                     = 0x0500  // IAS zone
    case iasACE                      = 0x0501  // IAS ACE
    case iasWD                       = 0x0502  // IAS WD

    case price                       = 0x0700  // Price
    case demandResponseLoadControl   = 0x0701  // DRLC
    case metering                    = 0x0702  // Metering

    case meterIdentification         = 0x0B01  // Meter ID
    case electricalMeasurement       = 0x0B04  // Electrical measurement
    case diagnostics                 = 0x0B05  // Diagnostics
}

public enum ZCLStatus: UInt8 {
    case success               = 0x00  // ZCL Success
    case fail                  = 0x01  // ZCL Fail

    case notAuthorized         = 0x7E  // Not authorized to upgrade client
    case malformedCommand      = 0x80  // Malformed command
    case unsupportedClusterCmd = 0x81  // Unsupported cluster command
    case unsupportedGeneralCmd = 0x82  // Unsupported general command
    case unsupportedManufClusterCmd = 0x83  // Unsupported manufacturer-specific cluster command
    case unsupportedManufGeneralCmd = 0x84  // Unsupported manufacturer-specific general command
    case invalidField          = 0x85  // Invalid field
    case unsupportedAttribute  = 0x86  // Unsupported attribute
    case invalidValue          = 0x87  // Invalid value
    case readOnly              = 0x88  // Read only
    case insufficientSpace     = 0x89  // Insufficient space
    case duplicateExists       = 0x8A  // Duplicate exists
    case notFound              = 0x8B  // Not found
    case unreportableAttribute = 0x8C  // Unreportable attribute
    case invalidType           = 0x8D  // Invalid type
    case writeOnly             = 0x8F  // Write only
    case inconsistent          = 0x92  // Supplied values are inconsistent
    case actionDenied          = 0x93  // Action denied
    case timeout               = 0x94  // Timeout
    case abort                 = 0x95  // Abort
    case invalidImage          = 0x96  // Invalid OTA upgrade image
    case waitForData           = 0x97  // Server doesn't have data block available
    case noImageAvailable      = 0x98  // No image available
    case requireMoreImage      = 0x99  // More image required
    case notificationPending   = 0x9A  // Notification pending

    case hardwareFail          = 0xC0  // Hardware failure
    case softwareFail          = 0xC1  // Software failure
    case calibrationError      = 0xC2  // Calibration error
    case unsupportedCluster    = 0xC3  // Cluster not found on target endpoint
    case limitReached          = 0xC4  // Limit reached
}

public enum ZCLAttributeType: UInt8 {
    case null               = 0x00  // Null data type

    case bit8               = 0x08  // 8-bit value
    case bit16              = 0x09
    case bit24              = 0x0A
    case bit32              = 0x0B
    case bit40              = 0x0C
    case bit48              = 0x0D
    case bit56              = 0x0E
    case bit64              = 0x0F

    case boolean            = 0x10  // Boolean

    case bitmap8            = 0x18
    case bitmap16           = 0x19
    case bitmap24           = 0x1A
    case bitmap32           = 0x1B
    case bitmap40           = 0x1C
    case bitmap48           = 0x1D
    case bitmap56           = 0x1E
    case bitmap64           = 0x1F

    case uint8              = 0x20
    case uint16             = 0x21
    case uint24             = 0x22
    case uint32             = 0x23
    case uint40             = 0x24
    case uint48             = 0x25
    case uint56             = 0x26
    case uint64             = 0x27

    case int8               = 0x28
    case int16              = 0x29
    case int24              = 0x2A
    case int32              = 0x2B
    case int40              = 0x2C
    case int48              = 0x2D
    case int56              = 0x2E
    case int64              = 0x2F

    case enum8              = 0x30
    case enum16             = 0x31

    case semiFloat          = 0x38  // 2-byte float
    case float32            = 0x39  // 4-byte float
    case float64            = 0x3A  // 8-byte float

    case octetString        = 0x41
    case charString         = 0x42
    case longOctetString    = 0x43
    case longCharString     = 0x44

    case array8             = 0x48
    case array16            = 0x49
    case array32            = 0x4A

    case structure          = 0x4C
    case set                = 0x50
    case bag                = 0x51

    case timeOfDay          = 0xE0
    case date               = 0xE1
    case utcTime            = 0xE2

    case clusterID          = 0xE8
    case attributeID        = 0xE9
    case bacnetOID          = 0xEA

    case ieeeAddress        = 0xF0
    case key128             = 0xF1

    case invalid            = 0xFF
}

public struct ZCLAttributeAccess: OptionSet {
    public let rawValue: UInt8

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public static let readOnly     = ZCLAttributeAccess(rawValue: 0x01) // Attribute is read only
    public static let writeOnly    = ZCLAttributeAccess(rawValue: 0x02) // Attribute is write only
    public static let readWrite    = ZCLAttributeAccess(rawValue: 0x03) // Attribute is read/write
    public static let reporting    = ZCLAttributeAccess(rawValue: 0x04) // Attribute is allowed for reporting
    public static let singleton    = ZCLAttributeAccess(rawValue: 0x08) // Attribute is singleton
    public static let scene        = ZCLAttributeAccess(rawValue: 0x10) // Attribute is accessed through scene
    public static let manufacturer = ZCLAttributeAccess(rawValue: 0x20) // Attribute is manufacturer specific
    public static let internalOnly = ZCLAttributeAccess(rawValue: 0x40) // Internal access only Attribute
}

public enum ZCLCommandDirection: UInt8 {
    case toServer = 0x00  // Command for cluster server side
    case toClient = 0x01  // Command for cluster client side
}
public enum ZCLReportDirection: UInt8 {
    case send = 0x00  // Report should be sent by a cluster
    case receive = 0x01  // Report should be received by a cluster
}

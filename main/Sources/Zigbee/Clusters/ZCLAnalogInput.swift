struct AnalogInputCluster {

    // MARK: - Attribute IDs
    enum Attributes: UInt16 {
        case description        = 0x001C  // Description
        case maxPresentValue    = 0x0041  // MaxPresentValue
        case minPresentValue    = 0x0045  // MinPresentValue
        case outOfService       = 0x0051  // OutOfService
        case presentValue       = 0x0055  // PresentValue
        case reliability        = 0x0067  // Reliability
        case resolution         = 0x006A  // Resolution
        case statusFlags        = 0x006F  // StatusFlags
        case engineeringUnits   = 0x0075  // EngineeringUnits
        case applicationType    = 0x0100  // ApplicationType
    }
  

    // MARK: - Status Flags (Bitfield)

    public struct StatusFlags: OptionSet {
        public let rawValue: UInt8
        public init(rawValue: UInt8) { self.rawValue = rawValue }

        public static let inAlarm       = StatusFlags(rawValue: 1 << 0)  // Bit 0
        public static let fault         = StatusFlags(rawValue: 1 << 1)  // Bit 1
        public static let overridden    = StatusFlags(rawValue: 1 << 2)  // Bit 2
        public static let outOfService  = StatusFlags(rawValue: 1 << 3)  // Bit 3
    }

    // MARK: - Reliability Values

    public enum Reliability: UInt8 {
        case noFaultDetected     = 0x00  // No fault
        case noSensor            = 0x01  // Sensor missing
        case overRange           = 0x02  // Value too high
        case underRange          = 0x03  // Value too low
        case openLoop            = 0x04  // Disconnected
        case shortedLoop         = 0x05  // Short circuit
        case noOutput            = 0x06  // No signal
        case unreliableOther     = 0x07  // Other error
        case processError        = 0x08  // Internal error
        case configurationError  = 0x0A  // Setup problem
    }

    // MARK: - Application Type Encoding

    public struct ApplicationType: RawRepresentable {
        public let rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public init(group: UInt8 = 0x00, type: UInt8, index: UInt16) {
            self.rawValue = (UInt32(type) << 16) | UInt32(index)
        }

        public var type: UInt8 { UInt8((rawValue >> 16) & 0xFF) }
        public var index: UInt16 { UInt16(rawValue & 0xFFFF) }
    }

    // MARK: - Application Type Constants (Optional Example)

    public enum ApplicationKind: UInt8 {
        case temperature        = 0x00
        case humidity           = 0x01
        case pressure           = 0x02
        case flow               = 0x03
        case percentage         = 0x04
        case ppm                = 0x05
        case rpm                = 0x06
        case currentInAmps      = 0x07
        case frequency          = 0x08
        case powerInWatts       = 0x09
        case powerInKilowatts   = 0x0A
        case energy             = 0x0B
        case countUnitless      = 0x0C
        case enthalpy           = 0x0D
        case time               = 0x0E
        case other              = 0xFF
    }

    public static func appType(_ kind: ApplicationKind, _ id: UInt16) -> ApplicationType {
        return ApplicationType(type: kind.rawValue, index: id)
    }

    public static let appTypeTemperatureOther = appType(.temperature, 0xFFFF)
    public static let appTypeHumidityOther = appType(.humidity, 0xFFFF)
    public static let appTypePressureOther = appType(.pressure, 0xFFFF)
}

extension AnalogInputCluster {
    enum Default {
         // MARK: - Default Values

        public static let description: [UInt8] = []           // Empty string
        public static let outOfService: Bool = false          // Not out of service
        public static let reliability: UInt8 = 0x00           // No fault
        public static let statusFlags: StatusFlags = []       // All bits cleared

        public static let statusFlagsMin: UInt8 = 0x00
        public static let statusFlagsMax: UInt8 = 0x0F

        public static let reportableAttributeCount = 2
    }
}
extension AnalogInputCluster {
    public enum TemperatureApplication: UInt16 {
        case twoPipeEntering                         = 0x0000
        case twoPipeLeaving                          = 0x0001
        case boilerEntering                          = 0x0002
        case boilerLeaving                           = 0x0003
        case chillerChilledWaterEntering             = 0x0004
        case chillerChilledWaterLeaving              = 0x0005
        case chillerCondenserWaterEntering           = 0x0006
        case chillerCondenserWaterLeaving            = 0x0007
        case coldDeck                                = 0x0008
        case coolingCoilDischarge                    = 0x0009
        case coolingEnteringWater                    = 0x000A
        case coolingLeavingWater                     = 0x000B
        case condenserWaterReturn                    = 0x000C
        case condenserWaterSupply                    = 0x000D
        case decoupleLoop0                           = 0x000E
        case buildingLoad                            = 0x000F
        case decoupleLoop1                           = 0x0010
        case dewPoint                                = 0x0011
        case dischargeAir                            = 0x0012
        case discharge                                = 0x0013
        case exhaustAirAfterHeatRecovery             = 0x0014
        case exhaustAir                              = 0x0015
        case glycol                                  = 0x0016
        case heatRecoveryAir                         = 0x0017
        case hotDeck                                 = 0x0018
        case heatExchangerBypass                     = 0x0019
        case heatExchangerEntering                   = 0x001A
        case heatExchangerLeaving                    = 0x001B
        case mechanicalRoom                          = 0x001C
        case mixedAir0                               = 0x001D
        case mixedAir1                               = 0x001E
        case outdoorAirDewpoint                      = 0x001F
        case outdoorAir                              = 0x0020
        case preheatAir                              = 0x0021
        case preheatEnteringWater                    = 0x0022
        case preheatLeavingWater                     = 0x0023
        case primaryChilledWaterReturn               = 0x0024
        case primaryChilledWaterSupply               = 0x0025
        case primaryHotWaterReturn                   = 0x0026
        case primaryHotWaterSupply                   = 0x0027
        case reheatCoilDischarge                     = 0x0028
        case reheatEnteringWater                     = 0x0029
        case reheatLeavingWater                      = 0x002A
        case returnAir                               = 0x002B
        case secondaryChilledWaterReturn             = 0x002C
        case secondaryChilledWaterSupply             = 0x002D
        case secondaryHotWaterReturn                 = 0x002E
        case secondaryHotWaterSupply                 = 0x002F
        case sideloopReset                           = 0x0030
        case sideloopSetpoint                        = 0x0031
        case sideloop                                = 0x0032
        case source                                  = 0x0033
        case supplyAir                               = 0x0034
        case supplyLowLimit                          = 0x0035
        case towerBasin                              = 0x0036
        case twoPipeLeavingWater                     = 0x0037
        case reserved                                = 0x0038
        case zoneDewpoint                            = 0x0039
        case zoneSensorSetpoint                      = 0x003A
        case zoneSensorSetpointOffset                = 0x003B
        case zone                                    = 0x003C
        case other                                   = 0xFFFF
    }

    public static func appType(_ app: TemperatureApplication) -> ApplicationType {
        .init(type: ApplicationKind.temperature.rawValue, index: app.rawValue)
    }
}
struct TemperatureMeasurmentsCluster   {
    public enum Attributes:UInt16 {
   
        case measuredValue     = 0x0000  // MeasuredValue
        case minMeasuredValue  = 0x0001  // MinMeasuredValue
        case maxMeasuredValue  = 0x0002  // MaxMeasuredValue
        case tolerance         = 0x0003  // Tolerance
    }

    public enum Unknown {
        public static let measuredValue: Int16 = .invalid
        public static let minMeasuredValue: Int16 = .invalid
        public static let maxMeasuredValue: Int16 = .invalid
    }

    public enum Range {
        public enum MinMeasuredValue {
            public static let minimum: Int32 = 0x954d
            public static let maximum: Int32 = 0x7ffe
        }

        public enum MaxMeasuredValue {
            public static let minimum: Int32 = 0x954e
            public static let maximum: Int32 = 0x7fff
        }

        public enum Tolerance {
            public static let minimum: UInt32 = 0x0000
            public static let maximum: UInt32 = 0x0800
        }
    }
}

public extension Int16 {
    static let invalid: Int16 = Int16(bitPattern: 0x8000)
}
extension TemperatureMeasurmentsCluster {

    static var config = Default.config

    public enum Default {
        static var config = TemperatureMeasureConfig(
            measuredValue: measuredValue,
            min: minMeasuredValue,
            max: maxMeasuredValue,
         )
        public static let measuredValue: Int16 = .invalid
        public static let minMeasuredValue: Int16 = .invalid
        public static let maxMeasuredValue: Int16 = .invalid
        public static let tolerance: UInt16 = 0
    }
}


typealias TemperatureMeasureConfig = esp_zb_temperature_meas_cluster_cfg_t
extension TemperatureMeasureConfig {
    init(measuredValue: Int16 = TemperatureMeasurmentsCluster.Default.measuredValue,
        min: Int16 = TemperatureMeasurmentsCluster.Default.minMeasuredValue,
        max: Int16 = TemperatureMeasurmentsCluster.Default.maxMeasuredValue) {
        self = .init(
            measured_value: measuredValue, 
            min_value: min, 
            max_value: max)
    }
}
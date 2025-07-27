struct TemperatureMeasurmentsCluster: Cluster {
    typealias Config =  esp_zb_temperature_meas_cluster_cfg_t
    var attributeList: UnsafeMutablePointer<esp_zb_attribute_list_t>
    static let addAttribute     = esp_zb_temperature_meas_cluster_add_attr
    static let addToClusterList = esp_zb_cluster_list_add_temperature_meas_cluster
    
    init(config: inout Config) {
        self.attributeList = esp_zb_temperature_meas_cluster_create(&config)
    }

    public enum Attribute: UInt16 {
   
        case measuredValue     = 0x0000  // MeasuredValue
        case minMeasuredValue  = 0x0001  // MinMeasuredValue
        case maxMeasuredValue  = 0x0002  // MaxMeasuredValue
        case tolerance         = 0x0003  // Tolerance
    }
}

extension TemperatureMeasurmentsCluster.Config : ClusterConfig  {
    init(measuredValue: Int16,
        min: Int16,
        max: Int16) {
        self = .init(
            measured_value: measuredValue, 
            min_value: min, 
            max_value: max)
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

extension TemperatureMeasurmentsCluster.Config {

    static var `default` = Self(
            measuredValue: Default.measuredValue,
            min:  Default.minMeasuredValue,
            max:Default.maxMeasuredValue,
         )

    public enum Default {
        
        public static let measuredValue: Int16 = .invalid
        public static let minMeasuredValue: Int16 = .invalid
        public static let maxMeasuredValue: Int16 = .invalid
        public static let tolerance: UInt16 = 0
    }
}

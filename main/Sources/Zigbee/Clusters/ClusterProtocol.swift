protocol Cluster {
    associatedtype Config: ClusterConfig
    var attributeList: UnsafeMutablePointer<esp_zb_attribute_list_t>? {get}
}

extension Cluster {
    mutating func addTo(
        clusterlist: UnsafeMutablePointer<ClusterList>, 
        role: ZCLClusterRole) {

        esp_zb_cluster_list_add_basic_cluster(
            clusterlist, 
            attributeList, 
            role.rawValue)
    }

    mutating func addAttribute<T>(
        _ attr: Config.Attribute, 
        _ u: UnsafeMutablePointer<T>)
        where Config.Attribute: RawRepresentable,
        Config.Attribute.RawValue == UInt16
     {
    esp_zb_basic_cluster_add_attr(attributeList, attr.rawValue, u)
    }
} 



protocol ClusterConfig {
    associatedtype Attribute
}
extension BasicClusterConfig: ClusterConfig {
    enum Attribute:UInt16 {
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
        case productCode     
    }
}

struct TestCluster: Cluster {
    typealias Config = BasicClusterConfig
    
    //var config: Config
    var attributeList: UnsafeMutablePointer<esp_zb_attribute_list_t>?

    init(config: inout Config) {
        self.attributeList = esp_zb_basic_cluster_create(&config)
    }
    
    // mutating func addTo(
    //     clusterlist: UnsafeMutablePointer<ClusterList>, 
    //     role: ZCLClusterRole) {

    //     esp_zb_cluster_list_add_basic_cluster(
    //         clusterlist, 
    //         attributeList, 
    //         role.rawValue)
    // }
    // mutating func addAttribute<T>(_ attr: Config.Attribute, _ u: UnsafeMutablePointer<T>) {
    // esp_zb_basic_cluster_add_attr(attributeList, attr.rawValue, u)
    // }
}


typealias EndpointList = esp_zb_ep_list_t
extension EndpointList {
    static func new () -> UnsafeMutablePointer<Self>{
        esp_zb_ep_list_create()
    }
}

extension UnsafeMutablePointer where Pointee == EndpointList {
    mutating func addTo(
        clusterList: UnsafeMutablePointer<ClusterList>,
        endpointConfig: EndpointConfig
        ) {
            esp_zb_ep_list_add_ep(
                self, 
                clusterList, 
                endpointConfig)
        }
}

typealias ClusterList = esp_zb_cluster_list_s
extension ClusterList {
    static func new () -> UnsafeMutablePointer<Self>{
       esp_zb_zcl_cluster_list_create()
    }
    static func from(clusters: (any Cluster, role: ZCLClusterRole)...) -> UnsafeMutablePointer<Self> {
        let result = new()
        for (var cluster, role) in clusters {
            cluster.addTo(clusterlist: result, role: role)
        }
        return result
    }
}



func example() {
    var config = BasicClusterConfig.init()
    
    let testCluster = TestCluster(config: &config)


    let clusterList = ClusterList.from(clusters: 
        (testCluster, role: .client)
        )
    var endpointList = EndpointList.new()

    let dimmerEndpointConfig = EndpointConfig.init(
        id: 10, 
        profileID: .homeAutomation, 
        deviceID: .dimmerSwitch, 
        appVersion: .zero)

    endpointList.addTo(
        clusterList: clusterList, 
        endpointConfig: dimmerEndpointConfig)
}
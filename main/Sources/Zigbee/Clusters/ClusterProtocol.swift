protocol Cluster {
    associatedtype Config: ClusterConfig
    associatedtype Attribute
    static var addToClusterList: 
        (_ cluster_list: Optional<UnsafeMutablePointer<esp_zb_cluster_list_t>>, 
        _ attr_list: Optional<UnsafeMutablePointer<esp_zb_attribute_list_t>>, 
        _ role_mask: UInt8) -> esp_err_t {get}

    static var addAttribute: 
         (_ attr_list: Optional<UnsafeMutablePointer<esp_zb_attribute_list_t>>,
          _ attr_id: UInt16, 
          _ value_p: Optional<UnsafeMutableRawPointer>) -> esp_err_t{get}
   
    var attributeList: UnsafeMutablePointer<esp_zb_attribute_list_t> {get}
}

extension Cluster {
    mutating func addTo(
        clusterlist: UnsafeMutablePointer<ClusterList>, 
        role: ZCLClusterRole) throws (ESPError) 
    {
        try runEsp { Self.addToClusterList( clusterlist, attributeList, role.rawValue)}
        print ("added to cluster list")
    }

    mutating func addAttribute<T>(
        _ attr: Attribute, 
        _ value: UnsafeMutablePointer<T>) throws (ESPError)
        where Attribute: RawRepresentable,
        Attribute.RawValue == UInt16
    {
        try runEsp { Self.addAttribute (attributeList, attr.rawValue, value) }
        print ("added attribute \(value.pointee)")
    }
} 



protocol ClusterConfig {
    
}


struct TestCluster: Cluster {
    static let addAttribute  = esp_zb_basic_cluster_add_attr
    static let addToClusterList = esp_zb_cluster_list_add_basic_cluster
    let attributeList: UnsafeMutablePointer<esp_zb_attribute_list_t>
    typealias Config = BasicCluster.Config
    
    //var config: Config
    init(config: inout Config) {
        self.attributeList = esp_zb_basic_cluster_create(&config)
    }
    enum Attribute {

    }
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
    /*
    static func from(clusters: (ClusterWrapper, role: ZCLClusterRole)...) -> UnsafeMutablePointer<Self> {
        let result = new()
        for (wrapper, role) in clusters {
            //try! wrapper.addTo(clusterlist: result, role: role)
        }
        return result
    }
    */
}


/*
func example() {
    var config = BasicCluster.Config.init()

    var manufacturerName: [CChar] = makeCChar(from: "Ojej")
    var model = makeCChar(from: "Nowosc na rynku")
    var testCluster = TestCluster(config: &config)
    try! testCluster.addAttribute(.manufacturerName, &manufacturerName)
    try! testCluster.addAttribute(.modelIdentifier, &model)


    // let clusterList = ClusterList.from(clusters: 
    //     (.basic(testCluster), role: .client)
    //     )
    // var endpointList = EndpointList.new()

    let dimmerEndpointConfig = EndpointConfig.init(
        id: 10, 
        profileID: .homeAutomation, 
        deviceID: .dimmerSwitch, 
        appVersion: .zero)

    // endpointList.addTo(
    //     clusterList: clusterList, 
    //     endpointConfig: dimmerEndpointConfig)
}
*/
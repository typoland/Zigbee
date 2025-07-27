struct GroupsCluster: Cluster {
    typealias Config = esp_zb_groups_cluster_cfg_t
    var attributeList: UnsafeMutablePointer<esp_zb_attribute_list_t>
    static let addAttribute     = esp_zb_groups_cluster_add_attr
    static let addToClusterList = esp_zb_cluster_list_add_groups_cluster
    
    init(config: inout Config) {
        self.attributeList = esp_zb_groups_cluster_create(&config)
    }

    enum Attribute {
        // MARK: - Attribute IDs
        public static let nameSupport = 0x0000  // NameSupport attribute
     }
}

extension GroupsCluster.Config: ClusterConfig {
    init(groupsNameSupportID: UInt8) {
        self = .init(groups_name_support_id: groupsNameSupportID)
    }
     
 
   
    // MARK: - Command Identifiers

    enum Idetifiers:UInt8 {
        case addGroup                = 0x00  // Add group command
        case viewGroup               = 0x01  // View group command
        case getGroupMembership      = 0x02  // Get group membership command
        case removeGroup             = 0x03  // Remove group command
        case removeAllGroups         = 0x04  // Remove all groups command
        case addGroupIfIdentifying   = 0x05  // Add group if identifying command
    }
   
    static let `default` =  Self(
            groupsNameSupportID: Default.nameSupport)
    enum Default {
         // MARK: - Default Values
        public static let nameSupport: UInt8 = 0x00  // Default value for NameSupport attribute
    }
}
struct GroupsCluster {

     enum Attributes {
    // MARK: - Attribute IDs

    public static let nameSupport = 0x0000  // NameSupport attribute
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
   
}

extension GroupsCluster {

    static var config = Default.config
    enum Default {
         // MARK: - Default Values
            static let config =  GroupsClusterConfig (
            groupsNameSupportID: nameSupport)

    public static let nameSupport: UInt8 = 0x00  // Default value for NameSupport attribute

    }
}

public typealias GroupsClusterConfig = esp_zb_groups_cluster_cfg_t
public extension GroupsClusterConfig {
    init(groupsNameSupportID: UInt8) {
        self = .init(groups_name_support_id: groupsNameSupportID)
    }
}
extension ZCLCluster.Groups {

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

extension ZCLCluster.Groups {
    enum Default {
         // MARK: - Default Values
            static var config =  GroupsClusterConfig (
            groupsNameSupportID: nameSupport)

    public static let nameSupport: UInt8 = 0x00  // Default value for NameSupport attribute


    }
}
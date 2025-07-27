struct ScenesCluster: Cluster {
    typealias Config = esp_zb_scenes_cluster_cfg_t
    var attributeList: UnsafeMutablePointer<esp_zb_attribute_list_t>
    static let addAttribute     = esp_zb_scenes_cluster_add_attr
    static let addToClusterList = esp_zb_cluster_list_add_scenes_cluster
    
    init(config: inout Config) {
        self.attributeList = esp_zb_scenes_cluster_create(&config)
    }

    // MARK: - Attribute IDs

    enum Attribute :UInt8 {
        case sceneCount         = 0x0000  // Number of scenes currently in the device's scene table
        case currentScene       = 0x0001  // Scene ID of the scene last invoked
        case currentGroup       = 0x0002  // Group ID of the scene last invoked
        case sceneValid         = 0x0003  // Whether state matches currentScene + currentGroup
        case nameSupport        = 0x0004  // MSB indicates if scene names are supported
        case lastConfiguredBy   = 0x0005  // IEEE address of last device that configured the scene table
    }
}
extension ScenesCluster.Config: ClusterConfig {
    init(
        scenesCount: UInt8,
        currentSceneID: UInt8,
        currentGroup: UInt16,
        sceneValid: Bool,
        nameSupportID: UInt8
    ) {
        self = .init(
            scenes_count: scenesCount,
            current_scene: currentSceneID,
            current_group: currentGroup,
            scene_valid: sceneValid,
            name_support: nameSupportID
        )
    }

    

    // MARK: - Command Identifiers

    enum Command: UInt8 {
        case addScene             = 0x00  // Add scene command
        case viewScene            = 0x01  // View scene command
        case removeScene          = 0x02  // Remove scene command
        case removeAllScenes      = 0x03  // Remove all scenes command
        case storeScene           = 0x04  // Store scene command
        case recallScene          = 0x05  // Recall scene command
        case getSceneMembership   = 0x06  // Get scene membership command
        case enhancedAddScene     = 0x40  // Add scene with finer transition time
        case enhancedViewScene    = 0x41  // View scene with finer transition time
        case copyScene            = 0x42  // Copy scenes between group/scene pairs
    }

    // MARK: - Response Command Identifiers

    enum ResponseCommand: UInt8 {
        case addSceneResponse             = 0x00  // Response to Add Scene
        case viewSceneResponse            = 0x01  // Response to View Scene
        case removeSceneResponse          = 0x02  // Response to Remove Scene
        case removeAllScenesResponse      = 0x03  // Response to Remove All Scenes
        case storeSceneResponse           = 0x04  // Response to Store Scene
        case getSceneMembershipResponse   = 0x06  // Response to Get Scene Membership
        case enhancedAddSceneResponse     = 0x40  // Response to Enhanced Add Scene
        case enhancedViewSceneResponse    = 0x41  // Response to Enhanced View Scene
        case copySceneResponse            = 0x42  // Response to Copy Scene
    }

    static let `default` = Self (
                scenesCount:     Default.sceneCount,
                currentSceneID:  Default.currentScene, //UInt8(ESP_ZB_ZCL_SCENES_CURRENT_SCENE_DEFAULT_VALUE),
                currentGroup:    Default.currentGroup,
                sceneValid:      Default.sceneCount != 0,
                nameSupportID:   Default.nameSupport)

    enum Default {
// MARK: - Default Values
        static let sceneCount: UInt8        = 0   // Default scene count
        static let currentScene: UInt8      = 0   // Default current scene ID
        static let currentGroup: UInt16     = 0   // Default current group ID
        static let sceneValid: UInt8        = 0   // Default scene valid flag
        static let nameSupport: UInt8       = 0   // Default name support
    }
}




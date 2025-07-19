extension ZCLCluster.Scenes  {
    // MARK: - Attribute IDs

    enum Attributes :UInt8 {
        case sceneCount         = 0x0000  // Number of scenes currently in the device's scene table
        case currentScene       = 0x0001  // Scene ID of the scene last invoked
        case currentGroup       = 0x0002  // Group ID of the scene last invoked
        case sceneValid         = 0x0003  // Whether state matches currentScene + currentGroup
        case nameSupport        = 0x0004  // MSB indicates if scene names are supported
        case lastConfiguredBy   = 0x0005  // IEEE address of last device that configured the scene table
    }

    // MARK: - Command Identifiers

    public enum Command: UInt8 {
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

    public enum ResponseCommand: UInt8 {
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
}

extension ZCLCluster.Scenes {
    enum Default {
        static var config = ScenesClusterConfig (
                scenesCount:    sceneCount,
                currentSceneID: currentScene, //UInt8(ESP_ZB_ZCL_SCENES_CURRENT_SCENE_DEFAULT_VALUE),
                currentGroup:   currentGroup,
                sceneValid:     sceneCount != 0,
                nameSupportID:  nameSupport)
// MARK: - Default Values

    public static let sceneCount: UInt8        = 0   // Default scene count
    public static let currentScene: UInt8      = 0   // Default current scene ID
    public static let currentGroup: UInt16     = 0   // Default current group ID
    public static let sceneValid: UInt8        = 0   // Default scene valid flag
    public static let nameSupport: UInt8       = 0   // Default name support
    }
}


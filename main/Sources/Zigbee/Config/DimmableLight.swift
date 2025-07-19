// struct DimmableLight {
//     /* Basic manufacturer information */
//     // static var manufacturerName: [CChar] = [0x07] + "MOMENTARY".utf8.map{CChar($0)}
//     // static var modelIdentifier: [CChar] = [0x05] + "SWIFT".utf8.map{CChar($0)}
//     static var manufacturerName = [CChar(0x09)] + "MOMENTARY".utf8.map{CChar($0)}
//     static var modelIdentifier = [CChar(0x05)] + "SWIFT".utf8.map{CChar($0)}
    
//     static var info: zcl_basic_manufacturer_info_t = manufacturerName.withUnsafeMutableBufferPointer {
//         namePtr in
//         modelIdentifier.withUnsafeMutableBufferPointer { modelPtr in
//             return zcl_basic_manufacturer_info_t(
//                 manufacturer_name: namePtr.baseAddress,
//                 model_identifier: modelPtr.baseAddress
//             )
//         }
//     }

//     static var endpointId: UInt8 = 10
    
        
//     static var config = DimmableLightConfig (
            
//         basic: ZCLCluster.Basic.Default.config,
//         identify: ZCLCluster.Identify.Default.config,
//         groups: ZCLCluster.Groups.Default.config,
//         scenes: ZCLCluster.Scenes.Default.config,
//         onOff: ZCLCluster.OnOff.Default.config,
//         level: ZCLCluster.Level.Default.config,
//         colorControl: ZCLCluster.ColorControl.Default.config)  
       
// }



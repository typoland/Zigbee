

func addEndpointBasicManufacturerInfo(
    endpointList: UnsafeMutablePointer<esp_zb_ep_list_t>,
    endpointId: UInt8,
    name: String,
    model: String
) throws (ESPError)  {
    var name: [CChar] = [CChar(name.count)] + name.utf8.map{CChar($0)}
    var model:[CChar] = [CChar(model.count)] + model.utf8.map{CChar($0)}
    
    let info: zcl_basic_manufacturer_info_t = name.withUnsafeMutableBufferPointer {
        namePtr in
        model.withUnsafeMutableBufferPointer { modelPtr in
            return zcl_basic_manufacturer_info_t(
                manufacturer_name: namePtr.baseAddress,
                model_identifier: modelPtr.baseAddress
            )
        }
    }

    guard let clusterList = esp_zb_ep_list_get_ep(endpointList, endpointId)
    else { throw .espCommandFailed( ESP_ERR_INVALID_ARG) }
    
    guard let basicCluster = esp_zb_cluster_list_get_cluster(
        clusterList,
        UInt16(ESP_ZB_ZCL_CLUSTER_ID_BASIC.rawValue),
        UInt8(ESP_ZB_ZCL_CLUSTER_SERVER_ROLE.rawValue)
    ) else { throw .espCommandFailed(ESP_ERR_INVALID_ARG) }
    
    guard info.manufacturer_name != nil 
    else { throw .espCommandFailed(ESP_ERR_INVALID_ARG) }  
    try runEsp {
        esp_zb_basic_cluster_add_attr(
            basicCluster,
           UInt16(ESP_ZB_ZCL_ATTR_BASIC_MANUFACTURER_NAME_ID.rawValue), 
           info.manufacturer_name)

    }

    guard info.model_identifier != nil 
    else { throw .espCommandFailed(ESP_ERR_INVALID_ARG) }

    try runEsp {
        esp_zb_basic_cluster_add_attr(
            basicCluster,
           UInt16(ESP_ZB_ZCL_ATTR_BASIC_MODEL_IDENTIFIER_ID.rawValue), 
           info.model_identifier)

    }

     esp_zb_device_register(endpointList)
    esp_zb_core_action_handler_register(zb_action_handler)
    esp_zb_set_primary_network_channel_set(DimmableLight.primaryChannelMask)


    
}

extension esp_zb_core_action_callback_id_t {
    var description: String {
        switch self {
        case ESP_ZB_CORE_SET_ATTR_VALUE_CB_ID: return "set attr value"
        case ESP_ZB_CORE_SCENES_STORE_SCENE_CB_ID: return "scenes store scene"
        case ESP_ZB_CORE_SCENES_RECALL_SCENE_CB_ID: return "scenes recall scene"
        case ESP_ZB_CORE_IAS_ZONE_ENROLL_RESPONSE_VALUE_CB_ID:
            return "ias zone enroll response value"
        case ESP_ZB_CORE_OTA_UPGRADE_VALUE_CB_ID: return "ota upgrade value"
        case ESP_ZB_CORE_OTA_UPGRADE_SRV_STATUS_CB_ID: return "ota upgrade srv status"
        case ESP_ZB_CORE_OTA_UPGRADE_SRV_QUERY_IMAGE_CB_ID: return "ota upgrade srv query image"
        case ESP_ZB_CORE_THERMOSTAT_VALUE_CB_ID: return "thermostat value"
        case ESP_ZB_CORE_METERING_GET_PROFILE_CB_ID: return "metering get profile"
        case ESP_ZB_CORE_METERING_GET_PROFILE_RESP_CB_ID: return "metering get profile resp"
        case ESP_ZB_CORE_METERING_REQ_FAST_POLL_MODE_CB_ID: return "metering req fast poll mode"
        case ESP_ZB_CORE_METERING_REQ_FAST_POLL_MODE_RESP_CB_ID:
            return "metering req fast poll mode resp"
        case ESP_ZB_CORE_METERING_GET_SNAPSHOT_CB_ID: return "metering get snapshot"
        case ESP_ZB_CORE_METERING_PUBLISH_SNAPSHOT_CB_ID: return "metering publish snapshot"
        case ESP_ZB_CORE_METERING_GET_SAMPLED_DATA_CB_ID: return "metering get sampled data"
        case ESP_ZB_CORE_METERING_GET_SAMPLED_DATA_RESP_CB_ID:
            return "metering get sampled data resp"
        case ESP_ZB_CORE_DOOR_LOCK_LOCK_DOOR_CB_ID: return "door lock lock door"
        case ESP_ZB_CORE_DOOR_LOCK_LOCK_DOOR_RESP_CB_ID: return "door lock lock door resp"
        case ESP_ZB_CORE_IDENTIFY_EFFECT_CB_ID: return "identify effect"
        case ESP_ZB_CORE_BASIC_RESET_TO_FACTORY_RESET_CB_ID: return "basic reset to factory reset"
        case ESP_ZB_CORE_PRICE_GET_CURRENT_PRICE_CB_ID: return "price get current price"
        case ESP_ZB_CORE_PRICE_GET_SCHEDULED_PRICES_CB_ID: return "price get scheduled prices"
        case ESP_ZB_CORE_PRICE_GET_TIER_LABELS_CB_ID: return "price get tier labels"
        case ESP_ZB_CORE_PRICE_PUBLISH_PRICE_CB_ID: return "price publish price"
        case ESP_ZB_CORE_PRICE_PUBLISH_TIER_LABELS_CB_ID: return "price publish tier labels"
        case ESP_ZB_CORE_PRICE_PRICE_ACK_CB_ID: return "price price ack"
        case ESP_ZB_CORE_COMM_RESTART_DEVICE_CB_ID: return "comm restart device"
        case ESP_ZB_CORE_COMM_OPERATE_STARTUP_PARAMS_CB_ID: return "comm operate startup params"
        case ESP_ZB_CORE_COMM_COMMAND_RESP_CB_ID: return "comm command resp"
        case ESP_ZB_CORE_IAS_WD_START_WARNING_CB_ID: return "ias wd start warning"
        case ESP_ZB_CORE_IAS_WD_SQUAWK_CB_ID: return "ias wd squawk"
        case ESP_ZB_CORE_IAS_ACE_ARM_CB_ID: return "ias ace arm"
        case ESP_ZB_CORE_IAS_ACE_BYPASS_CB_ID: return "ias ace bypass"
        case ESP_ZB_CORE_IAS_ACE_EMERGENCY_CB_ID: return "ias ace emergency"
        case ESP_ZB_CORE_IAS_ACE_FIRE_CB_ID: return "ias ace fire"
        case ESP_ZB_CORE_IAS_ACE_PANIC_CB_ID: return "ias ace panic"
        case ESP_ZB_CORE_IAS_ACE_GET_PANEL_STATUS_CB_ID: return "ias ace get panel status"
        case ESP_ZB_CORE_IAS_ACE_GET_BYPASSED_ZONE_LIST_CB_ID:
            return "ias ace get bypassed zone list"
        case ESP_ZB_CORE_IAS_ACE_GET_ZONE_STATUS_CB_ID: return "ias ace get zone status"
        case ESP_ZB_CORE_IAS_ACE_ARM_RESP_CB_ID: return "ias ace arm resp"
        case ESP_ZB_CORE_IAS_ACE_GET_ZONE_ID_MAP_RESP_CB_ID: return "ias ace get zone id map resp"
        case ESP_ZB_CORE_IAS_ACE_GET_ZONE_INFO_RESP_CB_ID: return "ias ace get zone info resp"
        case ESP_ZB_CORE_IAS_ACE_ZONE_STATUS_CHANGED_CB_ID: return "ias ace zone status changed"
        case ESP_ZB_CORE_IAS_ACE_PANEL_STATUS_CHANGED_CB_ID: return "ias ace panel status changed"
        case ESP_ZB_CORE_IAS_ACE_GET_PANEL_STATUS_RESP_CB_ID: return "ias ace get panel status resp"
        case ESP_ZB_CORE_IAS_ACE_SET_BYPASSED_ZONE_LIST_CB_ID:
            return "ias ace set bypassed zone list"
        case ESP_ZB_CORE_IAS_ACE_BYPASS_RESP_CB_ID: return "ias ace bypass resp"
        case ESP_ZB_CORE_IAS_ACE_GET_ZONE_STATUS_RESP_CB_ID: return "ias ace get zone status resp"
        case ESP_ZB_CORE_WINDOW_COVERING_MOVEMENT_CB_ID: return "window covering movement"
        case ESP_ZB_CORE_OTA_UPGRADE_QUERY_IMAGE_RESP_CB_ID: return "ota upgrade query image resp"
        case ESP_ZB_CORE_THERMOSTAT_WEEKLY_SCHEDULE_SET_CB_ID:
            return "thermostat weekly schedule set"
        case ESP_ZB_CORE_DRLC_LOAD_CONTORL_EVENT_CB_ID: return "drlc load contorl event"
        case ESP_ZB_CORE_DRLC_CANCEL_LOAD_CONTROL_EVENT_CB_ID:
            return "drlc cancel load control event"
        case ESP_ZB_CORE_DRLC_CANCEL_ALL_LOAD_CONTROL_EVENTS_CB_ID:
            return "drlc cancel all load control events"
        case ESP_ZB_CORE_DRLC_REPORT_EVENT_STATUS_CB_ID: return "drlc report event status"
        case ESP_ZB_CORE_DRLC_GET_SCHEDULED_EVENTS_CB_ID: return "drlc get scheduled events"
        case ESP_ZB_CORE_CMD_READ_ATTR_RESP_CB_ID: return "cmd read attr resp"
        case ESP_ZB_CORE_CMD_WRITE_ATTR_RESP_CB_ID: return "cmd write attr resp"
        case ESP_ZB_CORE_CMD_REPORT_CONFIG_RESP_CB_ID: return "cmd report config resp"
        case ESP_ZB_CORE_CMD_READ_REPORT_CFG_RESP_CB_ID: return "cmd read report cfg resp"
        case ESP_ZB_CORE_CMD_DISC_ATTR_RESP_CB_ID: return "cmd disc attr resp"
        case ESP_ZB_CORE_CMD_DEFAULT_RESP_CB_ID: return "cmd default resp"
        case ESP_ZB_CORE_CMD_OPERATE_GROUP_RESP_CB_ID: return "cmd operate group resp"
        case ESP_ZB_CORE_CMD_VIEW_GROUP_RESP_CB_ID: return "cmd view group resp"
        case ESP_ZB_CORE_CMD_GET_GROUP_MEMBERSHIP_RESP_CB_ID: return "cmd get group membership resp"
        case ESP_ZB_CORE_CMD_OPERATE_SCENE_RESP_CB_ID: return "cmd operate scene resp"
        case ESP_ZB_CORE_CMD_VIEW_SCENE_RESP_CB_ID: return "cmd view scene resp"
        case ESP_ZB_CORE_CMD_GET_SCENE_MEMBERSHIP_RESP_CB_ID: return "cmd get scene membership resp"
        case ESP_ZB_CORE_CMD_IAS_ZONE_ZONE_ENROLL_REQUEST_ID:
            return "cmd ias zone zone enroll request"
        case ESP_ZB_CORE_CMD_IAS_ZONE_ZONE_STATUS_CHANGE_NOT_ID:
            return "cmd ias zone zone status change not"
        case ESP_ZB_CORE_CMD_CUSTOM_CLUSTER_REQ_CB_ID: return "cmd custom cluster req"
        case ESP_ZB_CORE_CMD_CUSTOM_CLUSTER_RESP_CB_ID: return "cmd custom cluster resp"
        case ESP_ZB_CORE_CMD_PRIVILEGE_COMMAND_REQ_CB_ID: return "cmd privilege command req"
        case ESP_ZB_CORE_CMD_PRIVILEGE_COMMAND_RESP_CB_ID: return "cmd privilege command resp"
        case ESP_ZB_CORE_CMD_TOUCHLINK_GET_GROUP_ID_RESP_CB_ID:
            return "cmd touchlink get group id resp"
        case ESP_ZB_CORE_CMD_TOUCHLINK_GET_ENDPOINT_LIST_RESP_CB_ID:
            return "cmd touchlink get endpoint list resp"
        case ESP_ZB_CORE_CMD_THERMOSTAT_GET_WEEKLY_SCHEDULE_RESP_CB_ID:
            return "cmd thermostat get weekly schedule resp"
        case ESP_ZB_CORE_CMD_GREEN_POWER_RECV_CB_ID: return "cmd green power recv"
        case ESP_ZB_CORE_REPORT_ATTR_CB_ID: return "report attr"
        default: return "unknown \(self.rawValue)"
        }
    }
}

extension esp_zb_app_signal_type_t {
    var description: String {
    switch self {

    case ESP_ZB_ZDO_SIGNAL_DEFAULT_START:
        return "The device has started in non-BDB commissioning mode"

    case ESP_ZB_ZDO_SIGNAL_SKIP_STARTUP:
        return "Stack framework startup complete, ready for initializing BDB commissioning"

    case ESP_ZB_ZDO_SIGNAL_DEVICE_ANNCE:
        return "Indicates that a Zigbee device has joined or rejoined the network"

    case ESP_ZB_ZDO_SIGNAL_LEAVE:
        return "Indicates that the device itself has left the network"

    case ESP_ZB_ZDO_SIGNAL_ERROR:
        return "Indicates corrupted or incorrect signal information"

    case ESP_ZB_BDB_SIGNAL_DEVICE_FIRST_START:
        return "Basic network information of a factory-new device has been initialized, ready for Zigbee commissioning"

    case ESP_ZB_BDB_SIGNAL_DEVICE_REBOOT:
        return "Device joins or rejoins the network from the configured network information"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_NWK_STARTED:
        return "Touchlink initiator has started a network with the target and is ready for rejoining"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_NWK_JOINED_ROUTER:
        return "Touchlink target has joined the initiator network"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK:
        return "Result of the Touchlink initiator commissioning process"

    case ESP_ZB_BDB_SIGNAL_STEERING:
        return "Completion of BDB network steering"

    case ESP_ZB_BDB_SIGNAL_FORMATION:
        return "Completion of BDB network formation"

    case ESP_ZB_BDB_SIGNAL_FINDING_AND_BINDING_TARGET_FINISHED:
        return "Completion of BDB finding-and-binding for a target endpoint"

    case ESP_ZB_BDB_SIGNAL_FINDING_AND_BINDING_INITIATOR_FINISHED:
        return "BDB finding-and-binding with a target succeeded or initiator timed out / was cancelled"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_TARGET:
        return "Touchlink target is preparing to commission with the initiator"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_NWK:
        return "Touchlink target network has started"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_TARGET_FINISHED:
        return "Touchlink target commissioning procedure has finished"

    case ESP_ZB_NWK_SIGNAL_DEVICE_ASSOCIATED:
        return "A new device has initiated an association procedure"

    case ESP_ZB_ZDO_SIGNAL_LEAVE_INDICATION:
        return "A child device has left the network"

    case ESP_ZB_ZGP_SIGNAL_COMMISSIONING:
        return "GPCB commissioning signal (Green Power Combo Basic)"

    case ESP_ZB_COMMON_SIGNAL_CAN_SLEEP:
        return "Device can enter sleep mode"

    case ESP_ZB_ZDO_SIGNAL_PRODUCTION_CONFIG_READY:
        return "Specific part of the production configuration has been found / loaded"

    case ESP_ZB_NWK_SIGNAL_NO_ACTIVE_LINKS_LEFT:
        return "Neighbor table expired and no active route links remain"

    case ESP_ZB_ZDO_SIGNAL_DEVICE_AUTHORIZED:
        return "A new device has been authorized by the Trust Center"

    case ESP_ZB_ZDO_SIGNAL_DEVICE_UPDATE:
        return "A device has joined, rejoined, or left the network (Trust Center or parents)"

    case ESP_ZB_NWK_SIGNAL_PANID_CONFLICT_DETECTED:
        return "PAN-ID conflict detected; resolution inquiry"

    case ESP_ZB_NLME_STATUS_INDICATION:
        return "PAN-ID conflict detected — application must decide whether to resolve"

    case ESP_ZB_BDB_SIGNAL_TC_REJOIN_DONE:
        return "Trust Center rejoin procedure completed"

    case ESP_ZB_NWK_SIGNAL_PERMIT_JOIN_STATUS:
        return "Status change: network opened or closed for joining"

    case ESP_ZB_BDB_SIGNAL_STEERING_CANCELLED:
        return "Result of cancelling BDB network steering"

    case ESP_ZB_BDB_SIGNAL_FORMATION_CANCELLED:
        return "Result of cancelling BDB network formation"

    case ESP_ZB_ZGP_SIGNAL_MODE_CHANGE:
        return "ZGP mode change"

    case ESP_ZB_ZDO_DEVICE_UNAVAILABLE:
        return "Destination device is unavailable"

    case ESP_ZB_ZGP_SIGNAL_APPROVE_COMMISSIONING:
        return "ZGP Approve Commissioning"

    case ESP_ZB_SIGNAL_END:
        return "Signal end marker"

    default:
        return "unknown signal"
    }
    }
}

@inline(__always)
func appSignalOverview(for raw: UInt32) -> String {
    switch raw {
    case ESP_ZB_ZDO_SIGNAL_DEFAULT_START.rawValue:
        return "The device has started in non-BDB commissioning mode"

    case ESP_ZB_ZDO_SIGNAL_SKIP_STARTUP.rawValue:
        return "Stack framework startup complete, ready for initializing BDB commissioning"

    case ESP_ZB_ZDO_SIGNAL_DEVICE_ANNCE.rawValue:
        return "Indicates that a Zigbee device has joined or rejoined the network"

    case ESP_ZB_ZDO_SIGNAL_LEAVE.rawValue:
        return "Indicates that the device itself has left the network"

    case ESP_ZB_ZDO_SIGNAL_ERROR.rawValue:
        return "Indicates corrupted or incorrect signal information"

    case ESP_ZB_BDB_SIGNAL_DEVICE_FIRST_START.rawValue:
        return "Factory-new device initialised, ready for Zigbee commissioning"

    case ESP_ZB_BDB_SIGNAL_DEVICE_REBOOT.rawValue:
        return "Device joined / rejoined from stored network information"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_NWK_STARTED.rawValue:
        return "Touchlink initiator started a new network"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_NWK_JOINED_ROUTER.rawValue:
        return "Touchlink target joined the initiator’s network"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK.rawValue:
        return "Touchlink initiator commissioning finished"

    case ESP_ZB_BDB_SIGNAL_STEERING.rawValue:
        return "BDB network steering finished"

    case ESP_ZB_BDB_SIGNAL_FORMATION.rawValue:
        return "BDB network formation finished"

    case ESP_ZB_BDB_SIGNAL_FINDING_AND_BINDING_TARGET_FINISHED.rawValue:
        return "Finding-and-binding finished for the target"

    case ESP_ZB_BDB_SIGNAL_FINDING_AND_BINDING_INITIATOR_FINISHED.rawValue:
        return "Finding-and-binding finished for the initiator"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_TARGET.rawValue:
        return "Touchlink target is preparing to commission"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_NWK.rawValue:
        return "Touchlink target network has started"

    case ESP_ZB_BDB_SIGNAL_TOUCHLINK_TARGET_FINISHED.rawValue:
        return "Touchlink target commissioning finished"

    case ESP_ZB_NWK_SIGNAL_DEVICE_ASSOCIATED.rawValue:
        return "A new device started an association procedure"

    case ESP_ZB_ZDO_SIGNAL_LEAVE_INDICATION.rawValue:
        return "A child device has left the network"

    case ESP_ZB_ZGP_SIGNAL_COMMISSIONING.rawValue:
        return "Green-Power commissioning signal"

    case ESP_ZB_COMMON_SIGNAL_CAN_SLEEP.rawValue:
        return "The stack says the device can sleep"

    case ESP_ZB_ZDO_SIGNAL_PRODUCTION_CONFIG_READY.rawValue:
        return "Production configuration section found and loaded"

    case ESP_ZB_NWK_SIGNAL_NO_ACTIVE_LINKS_LEFT.rawValue:
        return "No active neighbour links remain"

    case ESP_ZB_ZDO_SIGNAL_DEVICE_AUTHORIZED.rawValue:
        return "A new device authorised by the Trust Center"

    case ESP_ZB_ZDO_SIGNAL_DEVICE_UPDATE.rawValue:
        return "Device joined, rejoined, or left the network"

    case ESP_ZB_NWK_SIGNAL_PANID_CONFLICT_DETECTED.rawValue,
         ESP_ZB_NLME_STATUS_INDICATION.rawValue:
        return "PAN-ID conflict detected"

    case ESP_ZB_BDB_SIGNAL_TC_REJOIN_DONE.rawValue:
        return "Trust-Center rejoin completed"

    case ESP_ZB_NWK_SIGNAL_PERMIT_JOIN_STATUS.rawValue:
        return "Network open/close for joining status changed"

    case ESP_ZB_BDB_SIGNAL_STEERING_CANCELLED.rawValue:
        return "Network steering was cancelled"

    case ESP_ZB_BDB_SIGNAL_FORMATION_CANCELLED.rawValue:
        return "Network formation was cancelled"

    case ESP_ZB_ZGP_SIGNAL_MODE_CHANGE.rawValue:
        return "Green-Power mode change"

    case ESP_ZB_ZDO_DEVICE_UNAVAILABLE.rawValue:
        return "Destination device is unavailable"

    case ESP_ZB_ZGP_SIGNAL_APPROVE_COMMISSIONING.rawValue:
        return "ZGP Approve Commissioning"

    case ESP_ZB_SIGNAL_END.rawValue:
        return "Signal end marker"

    default:
        return "unknown signal 0x\(String(raw, radix: 16))"
    }
}
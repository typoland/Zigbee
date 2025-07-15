@_cdecl("zb_attribute_handler")
func zb_attribute_handler(
    _ messagePtr: UnsafePointer<esp_zb_zcl_set_attr_value_message_t>?
) -> esp_err_t {

    let espError: esp_err_t = ESP_OK
    //var lightState = false
    //var lightLevel: UInt8 = 0

    guard let message = messagePtr?.pointee else {
        print("Empty message")
        return ESP_FAIL
    }

    guard message.info.status == ESP_ZB_ZCL_STATUS_SUCCESS else {
        print("Received message: error status\(message.info.status.rawValue)")
        return ESP_ERR_INVALID_ARG
    }

    print(
        "\n✅➡️ Received message: endpoint:\(message.info.dst_endpoint), cluster:\(message.info.cluster), attribute:\(message.attribute.id), data size:\(message.attribute.data.size)"
    )

    if message.info.dst_endpoint == DimmableLight.endpointId {
        print("✅💡", terminator: "")
        switch message.info.cluster {
        case UInt16(ESP_ZB_ZCL_CLUSTER_ID_ON_OFF.rawValue):
            print("ON/OFF: ", terminator: "")
            if message.attribute.id == UInt16(ESP_ZB_ZCL_ATTR_ON_OFF_ON_OFF_ID.rawValue)
                && message.attribute.data.type == ESP_ZB_ZCL_ATTR_TYPE_BOOL
            {
                lightState = message.attribute.data.value.load(as: UInt8.self) == 1
                print("state \(lightState)")
                ledStrip.switchOn(lightState)
            } else {
                print(
                    "cluster data attribute: \(message.attribute.id) type: \(message.attribute.data.type.rawValue)"
                )
            }

        case UInt16(ESP_ZB_ZCL_CLUSTER_ID_COLOR_CONTROL.rawValue):
            print("COLOR CONTROL:", terminator: "")
            var lightColorX: UInt16 = 0
            var lightColorY: UInt16 = 0
            if message.attribute.id == UInt16(ESP_ZB_ZCL_ATTR_COLOR_CONTROL_CURRENT_X_ID.rawValue)
                && message.attribute.data.type == ESP_ZB_ZCL_ATTR_TYPE_U16
            {
                lightColorX = message.attribute.data.value.load(as: UInt16.self)
                lightColorY = esp_zb_zcl_get_attribute(
                    DimmableLight.endpointId,
                    message.info.cluster,
                    UInt8(ESP_ZB_ZCL_CLUSTER_SERVER_ROLE.rawValue),
                    UInt16(ESP_ZB_ZCL_ATTR_COLOR_CONTROL_CURRENT_Y_ID.rawValue)
                )
                .pointee
                .data_p.load(as: UInt16.self)

            } else if message.attribute.id
                == UInt16(ESP_ZB_ZCL_ATTR_COLOR_CONTROL_CURRENT_Y_ID.rawValue)
                && message.attribute.data.type == ESP_ZB_ZCL_ATTR_TYPE_U16
            {
                lightColorY = message.attribute.data.value.load(as: UInt16.self)
                lightColorX = esp_zb_zcl_get_attribute(
                    DimmableLight.endpointId,
                    message.info.cluster,
                    UInt8(ESP_ZB_ZCL_CLUSTER_SERVER_ROLE.rawValue),
                    UInt16(ESP_ZB_ZCL_ATTR_COLOR_CONTROL_CURRENT_X_ID.rawValue)
                )
                .pointee
                .data_p.load(as: UInt16.self)
            } else {
                print(
                    "Control Color Cluster attribute: \(message.attribute.id) type: \(message.attribute.data.type.rawValue)"
                )
            }
            print("X:\(lightColorX), Y:\(lightColorY)")
            ledStrip.setColor(x: lightColorX, y: lightColorY)

        case UInt16(ESP_ZB_ZCL_CLUSTER_ID_LEVEL_CONTROL.rawValue):
            print("LEVEL CONTROL", terminator: "")
            if message.attribute.id
                == UInt16(ESP_ZB_ZCL_ATTR_LEVEL_CONTROL_CURRENT_LEVEL_ID.rawValue)
                && message.attribute.data.type == ESP_ZB_ZCL_ATTR_TYPE_U8
            {
                lightLevel = message.attribute.data.value.load(as: UInt8.self)
                ledStrip.setLevel(lightLevel)
                print("Light level changes to \(lightLevel)")
            } else {
                print("❌ unknown")
            }

        default:
            print(
                "Unexplored message data: cluster \(message.info.cluster), attribute \(message.attribute.id) "
            )
        }
    }
    return espError
}

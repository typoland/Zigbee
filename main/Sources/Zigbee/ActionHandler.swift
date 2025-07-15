@_cdecl("zb_action_handler")
func zb_action_handler(
    _ callback_id: esp_zb_core_action_callback_id_t,
    _ message: UnsafeRawPointer?
) -> esp_err_t {
    switch callback_id {
    case ESP_ZB_CORE_SET_ATTR_VALUE_CB_ID:
        guard
            let msg = message?
                .assumingMemoryBound(to: esp_zb_zcl_set_attr_value_message_t.self)

        else {
            print("▶️ ❌ Wrong Message in \(#function)")
            return ESP_FAIL
        }
        print("▶️ ➡️ return attribute handler cluster \(msg.pointee.info.cluster) \(#function)")
        return zb_attribute_handler(msg)

    default:
        print("▶️ ⚠️ Zigbee action callback received: \"\(callback_id.description)\"  \(#function)")
        return ESP_OK
    }
}

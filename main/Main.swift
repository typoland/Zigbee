@_cdecl("app_main")
func main() {

    var platformConfig: esp_zb_platform_config_t = Platform.config
    do {
        try runEsp { nvs_flash_init() }
        try runEsp { esp_zb_platform_config(&platformConfig) }
    } catch {
        print("🛑 (error.description)")
    }
    xTaskCreate(esp_zb_task, "Zigbee_main", 4096, nil, 5, nil)
     print ("🆗 TASK CRATED")
}


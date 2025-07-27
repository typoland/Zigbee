enum RadioMode: UInt32 {
    case native = 0x0 /*!< Use the native 15.4 radio */
    case UART = 0x1 /*!< UART connection to a 15.4 capable radio co - processor (RCP) */
    case SPI = 0x2
    var esp: esp_zb_radio_mode_t {
        .init(self.rawValue)
    }
}

enum HostConnectionMode: UInt32 {
    case none = 0x0 /*!< Disable host connection */
    case cliUART = 0x1 /*!< CLI UART connection to the host */
    case rcpUART = 0x2 /*!< RCP UART connection to the host */
    var esp: esp_zb_host_connection_mode_t {
        .init(self.rawValue)
    }
}

enum Platform {
    
    static var maxChildren: UInt8 = 10
    static var installCodePolicy = false
    static var primaryChannelMask = ESP_ZB_TRANSCEIVER_ALL_CHANNELS_MASK

    static var networkConfiguration: esp_zb_cfg_t {
        return esp_zb_cfg_t(
            esp_zb_role: ESP_ZB_DEVICE_TYPE_ROUTER,
            install_code_policy: installCodePolicy,
            nwk_cfg: .init(zczr_cfg: esp_zb_zczr_cfg_t(max_children: maxChildren))
        )
    }

    enum radio {
        static var defaultConfig: esp_zb_radio_config_t {
            .init(
                radio_mode: RadioMode.native.esp,
                radio_uart_config: .init()
            )
        }
    }

    enum host {
        static var defaultConfig: esp_zb_host_config_t {
            .init(
                host_connection_mode: HostConnectionMode.none.esp,
                host_uart_config: .init()
            )
        }
    }

    static var config: esp_zb_platform_config_t {
        .init(
            radio_config: radio.defaultConfig,
            host_config: host.defaultConfig
        )
    }
}

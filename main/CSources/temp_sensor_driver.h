
typedef void (*esp_temp_sensor_callback_t)(float temperature);

esp_err_t temp_sensor_driver_init(temperature_sensor_config_t *config,
									uint16_t update_interval,
									esp_temp_sensor_callback_t cb);

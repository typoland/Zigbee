//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

#include <stdio.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "led_strip.h"
#include "sdkconfig.h"

#include "driver/gpio.h"
#include "driver/uart.h"

//Zigbee:
#include "ha/esp_zigbee_ha_standard.h"
#include "esp_zigbee_core.h"
#include "extensions/light_driver.h"
#include "extensions/zcl_utility.h"
#include "nvs_flash.h"
//Zigbee lamp
#include "zcl/esp_zigbee_zcl_core.h"



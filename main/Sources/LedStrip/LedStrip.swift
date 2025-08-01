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

// A simple "overlay" to provide nicer APIs in Swift
class LedStrip {
  private let handle: led_strip_handle_t

  init(gpioPin: Int, maxLeds: Int) {
	var handle = led_strip_handle_t(bitPattern: 0)
	var stripConfig = led_strip_config_t(
		strip_gpio_num: Int32(gpioPin),
		max_leds: UInt32(maxLeds),
		led_pixel_format: LED_PIXEL_FORMAT_GRB,
		led_model: LED_MODEL_WS2812,
		flags: .init(invert_out: 0)
	)
	var spiConfig = led_strip_spi_config_t(
		clk_src: SPI_CLK_SRC_DEFAULT,
		spi_bus: SPI2_HOST,
		flags: .init(with_dma: 1)
	)
	guard led_strip_new_spi_device(&stripConfig, &spiConfig, &handle) == ESP_OK,
		let handle = handle
	else { fatalError("cannot configure spi device") }
	self.handle = handle
  }
  static var ESP32H2: LedStrip {
	.init(gpioPin: 8, maxLeds: 1)
  }

  struct Color {
	static var white = Color(r: 255, g: 255, b: 255)
	static var lightWhite = Color(r: 16, g: 16, b: 16)
	static var lightRandom: Color {
	  Color(
		r: .random(in: 0...16), g: .random(in: 0...16), b: .random(in: 0...16))
	}
	static var off = Color(r: 0, g: 0, b: 0)

	var r, g, b: UInt8
  }

  func setPixel(index: Int, color: Color) {
	do {
	  try runEsp {
		led_strip_set_pixel(
		  handle, UInt32(index), UInt32(color.r), UInt32(color.g), UInt32(color.b)
		)
	  }
	} catch {
	  print("\(#file) SET PIXEL ERROR \"\(error.description)\"")
	}
	refresh()
  }

  func refresh() {
	do { try runEsp { led_strip_refresh(handle) } } catch {
	  print("\(#file) REFRESH ERROR \"\(error.description)\"")
	}
  }
  func clear() {
	do { try runEsp { led_strip_clear(handle) } } catch {
	  print("\(#file) CLEAR ERROR \"\(error.description)\"")
	}
  }
}

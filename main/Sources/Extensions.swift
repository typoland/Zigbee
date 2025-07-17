enum GPIOMode {
	case disble
	case input
	case output 
	case outputOD
	case inputOutputOD
	case inputOutput
	var rawValue: gpio_mode_t {
		switch self {
		case .disble:        GPIO_MODE_DISABLE
		case .input:         GPIO_MODE_INPUT
		case .output:        GPIO_MODE_OUTPUT
		case .outputOD:      GPIO_MODE_OUTPUT_OD
		case .inputOutputOD: GPIO_MODE_INPUT_OUTPUT_OD
		case .inputOutput:   GPIO_MODE_INPUT_OUTPUT
		}
	}
} 

enum GPIOPull {
	case pullUp
	case pullDown
	case pullUpPullDown
	case floating
	var rawValue: gpio_pull_mode_t {
		switch self {
			case .floating:       GPIO_FLOATING
			case .pullUp:         GPIO_PULLUP_ONLY
			case .pullDown:       GPIO_PULLDOWN_ONLY
			case .pullUpPullDown: GPIO_PULLUP_PULLDOWN
		}
	}
}

enum GPIOState: UInt32 {
	case low = 0
	case high
	mutating func toggle() {
		switch self {
			case .low : self = .high
			case .high: self = .low
		}
	}
	var bool: Bool {
		switch self {
			case .low: false
			case .high: true
		}
	}
}

enum ADCAttenuation:UInt32 { // parameter. Different parameters determine the range of the ADC.
   case  dB_0   = 0  ///<No input attenuation, ADC can measure up to approx.
   case  dB_2_5 = 1  ///<The input voltage of ADC will be attenuated extending the range of measurement by about 2.5 dB
   case  dB_6   = 2  ///<The input voltage of ADC will be attenuated extending the range of measurement by about 6 dB
   case dB_12  = 3  ///<The input voltage of ADC will be attenuated extending the range of measurement by about 12 dB
   var esp:adc_atten_t {
	adc_atten_t(self.rawValue)
   }
} 

enum ADCBitwidth:UInt32 {
    case `default` = 0 ///< Default ADC output bits, max supported width will be selected
    case bitwidth_9  = 9      ///< ADC output width is 9Bit
    case bitwidth_10 = 10     ///< ADC output width is 10Bit
    case bitwidth_11 = 11     ///< ADC output width is 11Bit
    case bitwidth_12 = 12     ///< ADC output width is 12Bit
    case bitwidth_13 = 13     ///< ADC output width is 13Bit
	var esp: adc_bitwidth_t {
		adc_bitwidth_t(rawValue: self.rawValue)
	}
} 

enum ADC_ULPMode: UInt32 {
// *
// * This decides the controller that controls ADC when in low power mode.
// * Set `ADC_ULP_MODE_DISABLE` for normal mode.
    case disable = 0 ///< ADC ULP mode is disabled
    case fsm     = 1 ///< ADC is controlled by ULP FSM
    case riscv   = 2 ///< ADC is controlled by ULP RISCV
#if SOC_LP_ADC_SUPPORTED
    case lp_core = 3 ///< ADC is controlled by LP Core
#endif // SOC_LP_ADC_SUPPORTED
	var esp: adc_ulp_mode_t {
		adc_ulp_mode_t(rawValue: self.rawValue)
	}
} 

func gpio(_ num: Int) -> gpio_num_t {
	gpio_num_t(Int32(num))
}

func resetPin(_ pin: Int) {
	gpio_reset_pin(gpio(pin)) // optional but safe
}

func pinMode(reset: Bool = false, _ pin: Int, _ mode: GPIOMode, pull: GPIOPull = .floating) {
	if reset {resetPin(pin)}
	gpio_set_direction(gpio(pin), mode.rawValue)
	gpio_set_pull_mode(gpio(pin), pull.rawValue)
}

func digitalWrite(_ pin: Int, _ state: GPIOState) {
	gpio_set_level(gpio(pin), state.rawValue)
}

func digitalWrite<T:BinaryInteger>(_ pin: Int, _ number: T) {
	digitalWrite(pin, number == 1 ? .high : .low)
}

func digitalRead(_ pin: Int) -> GPIOState {
	gpio_get_level(gpio(pin)) == 0 ? .low : .high
}

func delayMiliseconds(_ ms: Int) {
	vTaskDelay(UInt32(ms) / (1000 / UInt32(configTICK_RATE_HZ)))
}

func delayMicroseconds(_ us: Int) {
	vTaskDelay(UInt32(us) /  (1_000_000 / UInt32(configTICK_RATE_HZ)))
}

enum ESPError: Error {
	case espCommandFailed(esp_err_t)
	var description: String {
		switch self {
			case .espCommandFailed(let espError):
				espErrorName(espError)
		}
	}
}

func runEsp(_ espCommand: ()->esp_err_t) throws (ESPError) {
	let error = espCommand() 
	//print ("Esp command: \(espErrorName(error))") 
	if error == ESP_OK {
		return
	} 
	throw ESPError.espCommandFailed(error)
}

func espErrorName(_ espError: esp_err_t) -> String {
	if let cStr = esp_err_to_name(espError) {
		return String(cString: cStr)
	}
	return "Unknown ESP error"
}

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
	case failure(String) 
	var description: String {
		switch self {
			case .espCommandFailed(let espError):
				espErrorName(espError)
			case .failure( let string):
				string
		}
	}
}

func runEsp(_ espCommand: () -> esp_err_t) throws (ESPError) {
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

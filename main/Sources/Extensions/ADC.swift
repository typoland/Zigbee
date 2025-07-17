enum ADC {
    enum Attenuation: UInt32 { // parameter. Different parameters determine the range of the ADC.
        case  dB_0   = 0  ///<No input attenuation, ADC can measure up to approx.
        case  dB_2_5 = 1  ///<The input voltage of ADC will be attenuated extending the range of measurement by about 2.5 dB
        case  dB_6   = 2  ///<The input voltage of ADC will be attenuated extending the range of measurement by about 6 dB
        case dB_12  = 3  ///<The input voltage of ADC will be attenuated extending the range of measurement by about 12 dB
        var esp:adc_atten_t {
            adc_atten_t(self.rawValue)
        }
    } 

    enum Bitwidth:UInt32 {
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

    enum ULPMode: UInt32 {
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
    
    enum Unit:Int  {
        case unit1        ///< SAR ADC 1
        case unit2        ///< SAR ADC 2
        var esp: adc_unit_t {
            switch self {
            case .unit1: ADC_UNIT_1
            case .unit2: ADC_UNIT_2
            }
        } 
    }
    enum Channel: Int {
        case channel0      ///< ADC channel
        case channel1     ///< ADC channel
        case channel2     ///< ADC channel
        case channel3     ///< ADC channel
        case channel4     ///< ADC channel
        case channel5     ///< ADC channel
        case channel6     ///< ADC channel
        case channel7     ///< ADC channel
        case channel8     ///< ADC channel
        case channel9    ///< ADC channel
        case channel10    ///< ADC channel
        var esp:adc_channel_t {
            switch self {
                case .channel0: ADC_CHANNEL_0
                case .channel1: ADC_CHANNEL_1
                case .channel2: ADC_CHANNEL_2
                case .channel3: ADC_CHANNEL_3
                case .channel4: ADC_CHANNEL_4
                case .channel5: ADC_CHANNEL_5
                case .channel6: ADC_CHANNEL_6
                case .channel7: ADC_CHANNEL_7
                case .channel8: ADC_CHANNEL_8
                case .channel9: ADC_CHANNEL_9
                case .channel10:ADC_CHANNEL_10
            }
        }
    }
    enum DigitalClockSource {
        case xtal 
        case pllF96m
        case rcFast
        case `default`
        var esp: soc_periph_adc_digi_clk_src_t {
            switch self {
                case .xtal   : soc_periph_adc_digi_clk_src_t(SOC_MOD_CLK_XTAL.rawValue)           /*!< Select XTAL as the source clock */
                case .pllF96m: soc_periph_adc_digi_clk_src_t(SOC_MOD_CLK_PLL_F96M.rawValue)  
                case .rcFast : soc_periph_adc_digi_clk_src_t(SOC_MOD_CLK_RC_FAST.rawValue)     /*!< Select RC_FAST as the source clock */
                case .default: soc_periph_adc_digi_clk_src_t(SOC_MOD_CLK_PLL_F96M.rawValue)    /*!< Select PLL_F96M as the default clock choice */

            }
        }

    
} ;
}

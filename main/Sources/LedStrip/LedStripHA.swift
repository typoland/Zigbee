
extension LedStrip {
    func setColor(x: UInt16, y: UInt16) {
        let currentX = Float(x)/65535.0
        let currentY = Float(y)/65535.0

        // assume color_Y is full light level value 1  (0-1.0) 
        let colorX = currentX/currentY
        let colorZ = (1 - currentX - currentY) / currentY

        // change from xy to linear RGB NOT sRGB 
 
        stripeColor = Color(x: colorX, y: 1, z: colorZ)

        setPixel(index: 0, color: stripeColor.level(lightLevel))
        
        if let volt = try? analogInput.read() {
            print("TEMP Reading: \((Float(volt)/1000).string(3))V")
        } else {
            print ("TEMP Ureadable")
        }
        if let volt = try? pontentiometerInput.read() {
            print("VOLT Reading: \((Float(volt)/1000).string(3))V")
        } else {
            print ("VOLT Ureadable")
        }
    }

    func setColor(hue: UInt8, saturation: UInt8) {
        stripeColor = Color(hue: hue, saturation: saturation)
        setPixel(index: 0, color: stripeColor.level(lightLevel))

    }

    // func setColor(r: UInt8, g: UInt8, b: UInt8) {
    //     let color = Color(r: r, g: g, b: b)
    //     setPixel(index: 0, color: color)
    //     stripeColor = color
    // }

    func setColor(_ color:Color) {
        stripeColor = color
        setPixel(index: 0, color: stripeColor.level(lightLevel))
    }

    func switchOn(_ on: Bool) {
        setPixel(index: 0, color: stripeColor.level(on ? lightLevel : 0) )
    }

    func setLevel(_ level: UInt8) {
        lightLevel = level
        setPixel(index: 0, color: stripeColor.level(level))
    }

}
extension LedStrip.Color {
    init(x: Float, y: Float, z: Float) {
        let fr =  3.240479 * x - 1.537150 * y - 0.498535 * z
        let fg = -0.969256 * x + 1.875992 * y + 0.041556 * z
        let fb =  0.055648 * x - 0.204043 * y + 1.057311 * z
        self.r = UInt8( min(max(fr, 0), 1) * 255.0)
        self.g = UInt8( min(max(fg, 0), 1) * 255.0)
        self.b = UInt8( min(max(fb, 0), 1) * 255.0)
    }

    static func * (lhs: Self, rhs: Float) -> Self {
        return .init(r: UInt8(Float(lhs.r) * rhs), 
                     g: UInt8(Float(lhs.g) * rhs), 
                     b: UInt8(Float(lhs.b) * rhs))
    }
    
    /// Keep original color, give me its shade
    /// - Parameter level: 0..255
    /// - Returns: New color, scaled down to level
    func level(_ level: UInt8) -> Self {
        self * (Float(level)/255.0)
    }

    /// HSV → RGB (linear) initializer.  
    /// - Parameters:
    ///   - hue:        0…255 (wraps around 360°)
    ///   - saturation: 0…255 (0 = grey, 255 = full saturation)
    /// The value/brightness is assumed to be 1.0; dimming can be applied later.
    init(hue: UInt8, saturation: UInt8) {
        let v: Float = 1.0
        let h = Float(hue)
        let s = Float(saturation) / Float(UInt8.max)          // 0…1
        let sector = Float(UInt8.max) / 6.0                   // ≈42.5

        let i = Int(h / sector)                               // Sector 0…5
        let f = (h.truncatingRemainder(dividingBy: sector)) / sector

        let p = v * (1 - s)
        let q = v * (1 - s * f)
        let t = v * (1 - s * (1 - f))

        let (fr, fg, fb): (Float, Float, Float)
        switch i {
        case 0:  (fr, fg, fb) = (v,  t,  p)
        case 1:  (fr, fg, fb) = (q,  v,  p)
        case 2:  (fr, fg, fb) = (p,  v,  t)
        case 3:  (fr, fg, fb) = (p,  q,  v)
        case 4:  (fr, fg, fb) = (t,  p,  v)
        default: (fr, fg, fb) = (v,  p,  q)   // case 5
        }
        //let b = Float(brightness)/255.0
        self.r = UInt8(fr)
        self.g = UInt8(fg)
        self.b = UInt8(fb)
    }
}
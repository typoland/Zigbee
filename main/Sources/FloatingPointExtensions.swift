extension BinaryFloatingPoint {
    func string(_ decimal: Int) -> String {             // -1234,5678
        let isNeg = self < 0
        var val = abs(self)                       //  1234,5678
        var round = val.rounded(.down)            //  1234.0
        var rest = val - round                    //     0.5678
        var result = "\(isNeg ? "-" : "")\(Int(val))." // "-1234."

        for _ in 0..<decimal {                  
            val = rest * 10                             // 5.678
            round = val.rounded(.down)                  // 5.0
            rest = val - round                          // 0.678
            result = "\(result)\(Int(round))"           // "1234.5"               
        }
       return result
    }
}
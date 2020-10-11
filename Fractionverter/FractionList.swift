//
//  FractionList.swift
//  Fractionverter
//
//  Created by selman birinci on 10/6/20.
//

import Foundation

struct FractionList {
    let fraction: String
    let decimal: String
    
    init(fr fraction: String) {
        self.fraction = fraction
        
        let index = fraction.firstIndex(of: "/") ?? fraction.endIndex
        let last = fraction.index(after: index)

        
        
        let up = Double(fraction[..<index]) ?? 1.0
        let down = Double(fraction[last...]) ?? 2.0
        
        let val: Double = up/down
        
        self.decimal = String(format: "%.4f", val)
    }
    
    
}

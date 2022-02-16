//
//  Weather.swift
//  RandallLeFinalProject
//
//  Created by Randall Le on 12/8/21.
//

import Foundation

struct Weather:Equatable, Codable {
    // Private properties
//    private var temp, high, low: Int
//    private var city, description: String
    private var lat, lon: Double
    let appid = "1c2f114c1a8600b1da2f778905683764"

    
    // Constructor
    init(inLat: Double, inLon: Double) {
        lat = inLat
        lon = inLon
        
    }
    
    // Refresh
    
}

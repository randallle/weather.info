//
//  WeatherModel.swift
//  RandallLeFinalProject
//
//  Created by Randall Le on 12/8/21.
//

import Foundation
import UIKit
import SwiftUI

class WeatherModel: NSObject {
    
    // Singleton instance
    static let shared = WeatherModel()
    
    // Private member variables
    var savedLat = [Double]()
    var savedLong = [Double]()
    var latPath: URL
    var lonPath: URL
    
    
    override init() {
        
        // Declare the location you want to save data in, in documents folder
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        latPath = documentDirectory.appendingPathComponent("latitudes.json")
        lonPath = documentDirectory.appendingPathComponent("longitudes.json")
        
        // If the file exists as quotesPath/ load the information
        if FileManager.default.fileExists(atPath: latPath.path) {
            super.init()
            load()
        }
        
        // Otherwise, there is no file at path, populate coordinates with default values
        else {
            // Populate cities with default values
            self.savedLat = [36.618264, 40.6974034, 32.8205865]
            self.savedLong = [-121.9039806, -74.1197634, -96.8716357]
            super.init()
        }
    }
    
    func getLatitude(at index: Int) -> Double {
        return savedLat[index]
    }
    
    
    func getLongitude(at index: Int) -> Double {
        return savedLong[index]
    }
    
    func getNumSaved() -> Int {
        return savedLat.count
    }
    
    func removeLocation(at index: Int) {
        savedLat.remove(at: index)
        savedLong.remove(at: index)
    }
    
    // 1. Save the data
    func save(){
        // How do we get our native Swift object to be saved as a JSON file in our documents folder?
        let encoder = JSONEncoder()
        
        let latData = try! encoder.encode(savedLat)
        var jsonString = String(data: latData, encoding: .utf8)!
        try! jsonString.write(to: latPath, atomically: false, encoding: .utf8)
        
        let lonData = try! encoder.encode(savedLong)
        jsonString = String(data: lonData, encoding: .utf8)!
        try! jsonString.write(to: lonPath, atomically: false, encoding: .utf8)
    }
    
    // 2. Read the data
    private func load(){
        let decoder = JSONDecoder()
        
        let latData = try! Data(contentsOf: latPath)
        savedLat = try! decoder.decode([Double].self, from: latData)
        
        let lonData = try! Data(contentsOf: lonPath)
        savedLong = try! decoder.decode([Double].self, from: lonData)
    }
}

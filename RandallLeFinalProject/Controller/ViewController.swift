//
//  ViewController.swift
//  RandallLeFinalProject
//
//  Created by Randall Le on 12/7/21.
//

import UIKit
import CoreLocation
import Kingfisher

struct UnsplashResponse: Decodable {
    let results: [Image]
}

struct Image: Decodable {
    let urls: ImageUrl
}

struct ImageUrl: Decodable {
    let regular: String
}


struct WeatherResponse: Decodable {
    // Properties
    let coord: Coordinate
    let weather: [WeatherQuality]
    let main: WeatherQuantity
    let name: String
}

struct Coordinate: Decodable {
    // Properties
    let lon: Double
    let lat: Double
}

struct WeatherQuality: Decodable {
    // Properties
    let main: String
    let description: String
}

struct WeatherQuantity: Decodable {
    // Properties
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
}


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // IBOutlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    
    let locationManger = CLLocationManager()
    let appid = "1c2f114c1a8600b1da2f778905683764"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.distanceFilter = 100.0
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        let url = URL(string: "https://api.unsplash.com/search/photos?query=\(self.cityLabel.text!)")!
        var request = URLRequest(url: url)
        request.addValue("Client-ID YvKvlunHJUge7_9tU-SldnM1j5W6yKpTNL9vM1vr77Y", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                let image = try! decoder.decode(UnsplashResponse.self, from:data)
                
                let imageURL = URL(string: image.results[0].urls.regular)!
                self.cityImageView.kf.setImage(with: imageURL)
                self.cityImageView.alpha = 0.3
            }
        }.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManger.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            // Send GET request
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appid)&units=imperial")!
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    let dataObject = try! decoder.decode(WeatherResponse.self, from: data)
                    
                    // Update the current location weather page
                    DispatchQueue.main.async {
                        self.cityLabel.text = dataObject.name
                        self.temperatureLabel.text = "\(Int(dataObject.main.temp))°"
                        self.highLabel.text = "\(NSLocalizedString("High", comment: "")): \(Int(dataObject.main.temp_max))°"
                        self.lowLabel.text = "\(NSLocalizedString("Low", comment: "")): \(Int(dataObject.main.temp_min))°"
                        self.descriptionLabel.text = dataObject.weather[0].description
                    }
                }
            }.resume()
            
        }
        
    }

}


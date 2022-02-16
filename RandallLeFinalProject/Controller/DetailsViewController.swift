//
//  DetailsViewController.swift
//  RandallLeFinalProject
//
//  Created by Randall Le on 12/8/21.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    // Singleton instance
    private let shared = WeatherModel.shared
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    
    var lat = 0.0
    var lon = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Send GET request
        let appid = "1c2f114c1a8600b1da2f778905683764"
        var url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appid)&units=imperial")!
        var request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                let dataObject = try! decoder.decode(WeatherResponse.self, from: data)
                
                // Update the current location weather page
                DispatchQueue.main.async {
                    self.cityLabel.text = dataObject.name
                    self.tempLabel.text = "\(Int(dataObject.main.temp))°"
                    self.highLabel.text = "\(NSLocalizedString("High", comment: "")): \(Int(dataObject.main.temp_max))°"
                    self.lowLabel.text = "\(NSLocalizedString("Low", comment: "")): \(Int(dataObject.main.temp_min))°"
                    self.descriptionLabel.text = dataObject.weather[0].description
                }
            }
        }.resume()
        
        url = URL(string: "https://api.unsplash.com/search/photos?query=\(self.cityLabel.text!)")!
        request = URLRequest(url: url)
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
        // Do any additional setup after loading the view.
    }
    

}

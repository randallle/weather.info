//
//  AddLocationViewController.swift
//  RandallLeFinalProject
//
//  Created by Randall Le on 12/8/21.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    // Singleton instance
    private let shared = WeatherModel.shared
    
    var onComplete: (() -> Void)?
    
    //IBOutlets
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var searchWithCoordinatesButton: UIButton!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var searchWithZipCodeButton: UIButton!
    
    @IBOutlet weak var searchOptionOneLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var searchOptionTwoLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    @IBAction func searchWithCoordinatesDidTapped(_ sender: UIButton) {
        print("\(#function)")
        var success = false
        
        if Double(self.latitudeTextField.text!) != nil {
            if Double(self.longitudeTextField.text!) != nil {
                if Double(self.latitudeTextField.text!)! > -90 && Double(self.latitudeTextField.text!)! < 90{
                    if Double(self.longitudeTextField.text!)! > -180 && Double(self.longitudeTextField.text!)! < 180 {
                        success = true
                    }
                }
            }
        }
        
        if success {
            self.shared.savedLat.append(Double(self.latitudeTextField.text!)!)
            self.shared.savedLong.append(Double(self.longitudeTextField.text!)!)
            
            let alertController = UIAlertController(title: "\(NSLocalizedString("Success", comment: ""))", message: "\(NSLocalizedString("The location was added", comment: ""))", preferredStyle: .alert)
            let doneButton = UIAlertAction(title: "\(NSLocalizedString("Done", comment: ""))", style: .default, handler: nil)
            alertController.addAction(doneButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else {
            let alertController = UIAlertController(title: "Error", message: NSLocalizedString("There was an issue adding the specified coordinates", comment: ""), preferredStyle: .alert)
            let doneButton = UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default, handler: nil)
            alertController.addAction(doneButton)
            self.present(alertController, animated: true, completion: nil)
        }

        
    }
    
    @IBAction func searchWithZipCodeDidTapped(_ sender: UIButton) {
        print("\(#function)")
        var success = false
        if !(zipCodeTextField.text?.isEmpty)! {
            if zipCodeTextField.text!.count == 5 {
                success = true
            }
        }
        
        if success {
            self.shared.savedLat.append(Double(self.zipCodeTextField.text!)!)
            self.shared.savedLong.append(Double(self.zipCodeTextField.text!)!)
            
            let appid = "1c2f114c1a8600b1da2f778905683764"
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=\(zipCodeTextField.text!)&appid=\(appid)&units=imperial")!
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    let dataObject = try! decoder.decode(WeatherResponse.self, from: data)

                    // Update the current location weather page
                    DispatchQueue.main.async {
                        self.shared.savedLat.append(dataObject.coord.lat)
                        self.shared.savedLong.append(dataObject.coord.lon)
                    }
                }
            }.resume()
            
            let alertController = UIAlertController(title: "\(NSLocalizedString("Success", comment: ""))", message: "\(NSLocalizedString("The location was added", comment: ""))", preferredStyle: .alert)
            let doneButton = UIAlertAction(title: "\(NSLocalizedString("Done", comment: ""))", style: .default, handler: nil)
            alertController.addAction(doneButton)
            self.present(alertController, animated: true, completion: nil)
            print(shared.getNumSaved())
        }
        
        else {
            print("Not successful")
            let alertController = UIAlertController(title: "\(NSLocalizedString("Error", comment: ""))", message: "\(NSLocalizedString("There was an issue adding the specified ZIP Code", comment: ""))", preferredStyle: .alert)
            let doneButton = UIAlertAction(title: "\(NSLocalizedString("Done", comment: ""))", style: .default, handler: nil)
            alertController.addAction(doneButton)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelDidTapped(_ sender: UIBarButtonItem) {
        // The cancel should clear the text view and text field
        latitudeTextField.text = ""
        latitudeTextField.text = ""
        
        // Close view controller
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchOptionOneLabel.text = "\(NSLocalizedString("Search Option", comment: "")) #1"
        self.latitudeLabel.text = NSLocalizedString("Latitude", comment: "")
        self.longitudeLabel.text = NSLocalizedString("Longitude", comment: "")
        self.searchWithCoordinatesButton.setTitle(NSLocalizedString("Search with coordinates", comment: ""), for: .normal)
        
        self.searchOptionTwoLabel.text = "\(NSLocalizedString("Search Option", comment: "")) #2"
        self.zipCodeLabel.text = NSLocalizedString("Zip Code", comment: "")
        self.searchWithZipCodeButton.setTitle(NSLocalizedString("Search with ZIP code", comment: ""), for: .normal)

        // Do any additional setup after loading the view.
    }
}

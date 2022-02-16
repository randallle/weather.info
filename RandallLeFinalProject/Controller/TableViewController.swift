//
//  TableViewController.swift
//  RandallLeFinalProject
//
//  Created by Randall Le on 12/8/21.
//

import UIKit

class TableViewController: UITableViewController {

    // Singleton shared instance
    private let shared = WeatherModel.shared
    
    
    @IBAction func editDidTapped(_ sender: UIBarButtonItem) {
        print("\(#function)")
        // Toggle between edit modes
        tableView.isEditing = !tableView.isEditing
        
        // Change the button display
        sender.title = tableView.isEditing ? "\(NSLocalizedString("Done", comment: ""))" : "\(NSLocalizedString("Edit", comment: ""))"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the flashcard from FlashcardsModel
            shared.removeLocation(at: indexPath.row)
            
            // Perform animation to delete
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Call save
            //shared.save()
        }
    }
    
    
    // How many rows should I display in this section?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shared.getNumSaved()
    }
    
    // What cell should I render at a given index path (section, row)?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. Get the data
        let lat = shared.getLatitude(at: indexPath.row)
        let lon = shared.getLongitude(at: indexPath.row)
        
        // 2. Configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell")!
        
        // Send GET request
        let appid = "1c2f114c1a8600b1da2f778905683764"
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appid)&units=imperial")!
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                let dataObject = try! decoder.decode(WeatherResponse.self, from: data)

                // Update the current location weather page
                DispatchQueue.main.async {
                    cell.textLabel?.text = "\(dataObject.name) (\(Int(dataObject.main.temp))°)"
                    cell.detailTextLabel?.text = "\(Int(dataObject.main.temp_max))°/\(Int(dataObject.main.temp_min))°"
                }
            }
        }.resume()

        // 3. Return the cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addLocationVC = segue.destination as? AddLocationViewController{
            
            addLocationVC.onComplete = {
                // Refresh the list
                self.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        }
        else if let destination = segue.destination as? DetailsViewController, let indexPath = sender as? IndexPath {
            //    let selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)
//            let selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)?.row
            let lat = shared.getLatitude(at: indexPath.row)
            let lon = shared.getLongitude(at: indexPath.row)
            destination.lat = lat
            destination.lon = lon
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: indexPath)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

}

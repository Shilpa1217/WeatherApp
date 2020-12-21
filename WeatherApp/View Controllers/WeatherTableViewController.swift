//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by Shilpa Mulpuri on 12/20/20.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    private let viewModel: WeatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather by Zipcode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addZipcode))
    }

    @objc private func addZipcode(){
        let alertModal = UIAlertController(title: "Add Zipcode", message: "Please add 5 digit zipcode", preferredStyle: .alert)
        alertModal.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        alertModal.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let textField = alertModal.textFields?.first else {
                fatalError("Should have textfield")
            }
            
            guard let text = textField.text,
                  text.count == 5,
                  let zipcode = Int(text) else {
                // Show different errors
                return
            }
            
            self?.viewModel.save(zipcode: zipcode)
            self?.tableView.reloadData()
        }))
        present(alertModal, animated:true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.zipcodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZipCodeCell", for: indexPath)
        cell.textLabel?.text = "\(viewModel.zipcodes[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedZipcode = viewModel.zipcodes[indexPath.row]
        performSegue(withIdentifier: "DetailViewController", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController",
           let destination = segue.destination as? WeatherDetailViewController {
            destination.viewModel = WeatherDetailViewModel(zipcode: viewModel.selectedZipcode)
        }
    }
}

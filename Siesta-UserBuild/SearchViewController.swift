//
//  SearchViewController.swift
//  AutocompleteExample
//
//  Created by George McDonnell on 26/04/2017.
//  Copyright © 2017 George McDonnell. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var searchResult: String?
    var searchRequest: String?
    var resultCoordinate = CLLocationCoordinate2D()
    @IBOutlet weak var searchResultsTableView: UITableView!
    var flag: Int?
    var editingFlag = 0
    var editField: Int?
    
    func checkForZeroResults() -> Bool {
        if searchResults.count == 0 {
            
            return true
            
        } else {
            return false
        }
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if checkForZeroResults() == true {
            searchResult = searchRequest
        }
        performSegue(withIdentifier: "unwindToLocationSettingsViewController", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentController = self
        searchCompleter.delegate = self
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchRequest = searchText
        searchCompleter.queryFragment = searchText
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        searchResult = "\(completion.title), \(completion.subtitle)"
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
     
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            self.resultCoordinate = coordinate!
            print(String(describing: coordinate))
            if self.editingFlag == 0 {
            self.performSegue(withIdentifier: "unwindToLocationSettingsViewController", sender: self)
            } else if self.editingFlag == 1 {
                self.performSegue(withIdentifier: "unwindToEditLocationSettingsViewController:", sender: self)
            }
        }
    }
}

//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var businesses: [Business]!
    var filteredData: [Business]!
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        let searchController: UISearchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar // place at top of navigation
        self.searchController = searchController // prevents optional from returning nil
        self.searchController.hidesNavigationBarDuringPresentation = false // don't hide search controller
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredData = businesses
            if businesses != nil {
                self.tableView.reloadData()
               /* for business in businesses {
                    print(business.name!)
                    print(business.address!)
                } */
            }
        })
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = self.filteredData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = self.filteredData {
            return businesses.count
        }
        else {
            return 0
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filteredData = searchText.isEmpty ? self.businesses : self.businesses!.filter({(businessData: Business) -> Bool in
                let returnVal: Bool = businessData.name!.lowercased().range(of: searchText.lowercased()) != nil
                return returnVal
            })
            self.tableView.reloadData()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




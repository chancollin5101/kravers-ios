//
//  SuggestionViewControllerModel.swift
//  KraversFinal
//
//  Created by Collin Chan on 2019-08-09.
//  Copyright © 2019 Collin Chan. All rights reserved.
//

import Foundation
import UIKit
import CDYelpFusionKit

protocol ViewControllerDelegate: NSObjectProtocol{
    func reloadAfterData();
}

extension ViewController {
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    class Model {
        
        weak var delegate: ViewControllerDelegate?
        
        //Querry Parameters
        private var category: [CDYelpBusinessCategoryFilter]?
        private var price: [CDYelpPriceTier?] = []
        
        //Returned List
        private var lists: [CDYelpBusiness?] = [];
        
        //Get Methods
        func getLists() ->[CDYelpBusiness?] {
            return lists;
        }
        
        func getCategory() -> [CDYelpBusinessCategoryFilter]? {
            return category
        }
        
        //Set Methods
        func setNewCategory(_ newCategory: [CDYelpBusinessCategoryFilter]?) {
            category = newCategory;
        }
        
        func setNewPrice(_ newPrice: [CDYelpPriceTier]) {
            price = newPrice;
        }
        
        //Method to fetch data
        func fetchData() throws -> Void {
            //ADD IF ONLINE CONDITIONAL
            let apiKey = CDYelpFusionKitManager.shared.apiClient
                apiKey!.cancelAllPendingAPIRequests()
                apiKey!.searchBusinesses(
                    byTerm: nil,
                    location: "San Francisco",
                    latitude: /*Double((manager.location?.coordinate.latitude)!)*/ nil,
                    longitude: /*Double((manager.location?.coordinate.longitude)!)*/ nil,
                    radius: 1000,
                    categories: category,
                    locale: nil,
                    limit: nil,
                    offset: 0,
                    sortBy: nil,
                    priceTiers: nil,
                    openNow: true,
                    openAt: nil,
                    attributes: nil) { (response) in
                        if let response = response,
                            let businesses = response.businesses,
                            businesses.count > 0 {
                            self.lists = businesses
                            self.delegate?.reloadAfterData()
                        }
                }
            }
        
        func yeet() {
        
        }
    }
}


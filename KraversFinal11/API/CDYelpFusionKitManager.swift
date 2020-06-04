//
//  CDYelpFusionKitManager.swift
//  MilkShake
//
//  Created by Collin Chan on 8/8/2018.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import CDYelpFusionKit
import UIKit

final class CDYelpFusionKitManager: NSObject {
    
    static let shared = CDYelpFusionKitManager()
    
    var apiClient: CDYelpAPIClient!
    
    func configure() {
        // How to authorize using your clientId and clientSecret
        self.apiClient = CDYelpAPIClient(apiKey: yelp_api_key)
    }
}

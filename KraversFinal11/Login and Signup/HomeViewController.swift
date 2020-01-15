//
//  HomeViewController.swift
//  MilkShake
//
//  Created by Collin Chan on 11/8/2018.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController {
        
    @IBAction func handleLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

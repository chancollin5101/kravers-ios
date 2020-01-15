//
//  accountViewController.swift
//  KraversFinal
//
//  Created by Collin Chan on 2018-10-26.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class accountViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
            let username = user.displayName
            self.usernameLabel.text = username
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func handleLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

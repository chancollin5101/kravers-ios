//
//  popupViewController.swift
//  KraversFinal
//
//  Created by Collin Chan on 2018-10-24.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import UIKit

class popupViewController: UIViewController, StoryboardInstantiable {
    
    static var storyboardType: Storyboard = .tabBar
    
    @IBOutlet weak var suggestionImageView: UIImageView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var noThanksButton: UIButton!
    @IBAction func didTapNoThanks(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

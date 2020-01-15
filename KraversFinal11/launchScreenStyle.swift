//
//  launchScreenStyle.swift
//  KraversFinal
//
//  Created by Collin Chan on 2019-08-06.
//  Copyright © 2019 Collin Chan. All rights reserved.
//

import Foundation
import UIKit

class launchScreenView: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = 
    }
    
    func addGradientToView(view: UIView)
    {
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        //define colors
        gradientLayer.colors = [UIColor.red.cgColor,    UIColor.green.cgColor, UIColor.blue.cgColor]
        
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.0, 0.6, 0.8]
        
        //define frame
        gradientLayer.frame = view.bounds
        
        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

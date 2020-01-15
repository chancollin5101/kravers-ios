//
//  LOLViewController.swift
//  KraversFinal
//
//  Created by Collin Chan on 2018-08-22.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import UIKit
import CDYelpFusionKit

protocol SearchViewControllerDelegate: NSObjectProtocol {
    func updateSearchType(type: [CDYelpBusinessCategoryFilter]);
}

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var chinese: UIButton!
    @IBOutlet weak var pizza: UIButton!
    @IBOutlet weak var japanese: UIButton!
    @IBOutlet weak var italian: UIButton!
    @IBOutlet weak var freestyle: UIButton!
    @IBOutlet weak var korean: UIButton!
    @IBOutlet weak var desserts: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
     private let labelSource = ["Sushi","Ramen","Pizza","Chinese","Pasta", "Dessert","Freestyle"]
    
    var cuisines = [String]()
    var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        cuisines = ["🍣","🍜","🍕", "🍚", "🍝","🍰","🤷‍♂️"]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        infoLabel.text = labelSource[row]
        var type: [CDYelpBusinessCategoryFilter]
        switch row {
        case 0:
            type = [CDYelpBusinessCategoryFilter.japanese]
        case 1:
            type = [CDYelpBusinessCategoryFilter.ramen]
        case 2:
            type = [CDYelpBusinessCategoryFilter.pizza]
        case 3:
            type = [CDYelpBusinessCategoryFilter.chinese]
        case 4:
            type = [CDYelpBusinessCategoryFilter.pastaShops]
        case 5:
            type = [CDYelpBusinessCategoryFilter.desserts]
        default:
            type = [CDYelpBusinessCategoryFilter.food]
        }
        self.delegate?.updateSearchType(type: type)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cuisines.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cuisines[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 250
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 70)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = cuisines[row]
        pickerLabel?.textColor = UIColor.blue
        
        return pickerLabel!
    }

}


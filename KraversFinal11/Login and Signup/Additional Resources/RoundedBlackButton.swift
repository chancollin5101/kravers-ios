//
//  RoundedBlackButton.swift
//  MilkShake
//
//  Created by Collin Chan on 6/8/2018.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import Foundation
import UIKit


class RoundedBlackButton:UIButton {
    
    var highlightedColor = UIColor.black
    {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedColor
            }
        }
    }
    var defaultColor = UIColor.clear
    {
        didSet {
            if !isHighlighted {
                backgroundColor = defaultColor
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedColor
                
            } else {
                backgroundColor = defaultColor
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

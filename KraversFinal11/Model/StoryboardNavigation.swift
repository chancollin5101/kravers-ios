//
//  UIStoryboard.swift
//  KraversFinal
//
//  Created by Collin Chan on 7/8/19.
//  Copyright © 2019 One Tap, Inc. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable: class {
    static var storyboardType: Storyboard { get }
}

extension StoryboardInstantiable {
    static func initializeFromStoryboard() -> Self {
        let identifier = String(describing: self).components(separatedBy: "").last!
        return UIStoryboard(name: storyboardType.rawValue, bundle: .none).instantiateViewController(withIdentifier: identifier) as! Self
    }
}

enum Storyboard: String {
    case Main
    case tabBar
}

extension UIStoryboard {
    static func initialViewController(storyboard: Storyboard) -> UIViewController? {
        return UIStoryboard(name: storyboard.rawValue, bundle: .none).instantiateInitialViewController()
    }
}


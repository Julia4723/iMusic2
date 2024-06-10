//
//  UIViewController + Storyboard.swift
//  iMusic
//
//  Created by user on 10.06.2024.
//

import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: No initial viewController in \(name) storyboard")
        }
    }
}

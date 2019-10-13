//
//  Extensions.swift
//  Coding Challenge
//
//  Created by Carlos Mendoza on 8/23/19.
//  Copyright © 2019 Carlos Mendoza. All rights reserved.
//

import Foundation
import UIKit

var iconCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageURL : String = ""
    
    func loadImage(from url: String) {
        
        if let cache = iconCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cache
            return
        }
        
        image = nil
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Couldn't download image: ", error!)
                return
            }
            
            guard let data = data else { return }
            if let image = UIImage(data: data){
                iconCache.setObject(image, forKey: url.absoluteString as AnyObject)

                DispatchQueue.main.async {
                    if self.imageURL == url.absoluteString {
                        self.image = image
                    } else {
                    self.image = nil
                    }
                }
            }
            
            }.resume()
    }
}

enum MediaType: String {
    case Music = "Top Songs"
    case App = "Top Paid Apps"
    case Show =  "Top TV Episodes"
}

extension UIBarButtonItem {
    
    static func menuButton(_ target: Any?, action: Selector?, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.image?.withRenderingMode(.alwaysTemplate)
        if action != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        
        
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        return menuBarItem
    }
}

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

extension UIImageView {
    
    func loadImage(from url: String) {
        
        if let cache = iconCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cache
            return
        }
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Couldn't download image: ", error!)
                return
            }
            
            guard let data = data else { return }
            if let image = UIImage(data: data){
                iconCache.setObject(image, forKey: url as AnyObject)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            
            }.resume()
    }
}

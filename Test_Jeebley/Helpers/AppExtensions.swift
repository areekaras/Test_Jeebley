//
//  AppExtensions.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 30/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    /// set imagesFrom Url to image view
    ///
    /// - Parameter urlString: image URL link
    func loadImageFromUrl(urlString: String) {
        guard let url:URL = URL(string: urlString) else { return }
        
        image = UIImage(named: "itemThumbnail")
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print("ImageDownload Error : \(error)")
                return
            }
            DispatchQueue.main.async {
                if let imageToCache = UIImage(data: data!) {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            }
        }).resume()
    }
}

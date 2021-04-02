//
//  UIImage+Extension.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import Foundation
import  UIKit

extension UIImage {
    class func imageFromUrl(urlString: String, taskBlock:((_ task: URLSessionDataTask) -> Void)? = nil, loadFinishBlock: (@escaping (_ image: UIImage?) -> Void)) {
        var loadedImage: UIImage?
        if let URL_IMAGE = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let getImageFromUrl = session.dataTask(with: URL_IMAGE) { (data, response, error) in
                if let e = error {
                    print("Error Occurred: \(e)")
                    loadedImage = nil
                } else {
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            loadedImage = image
                        } else {
                            print("Image file is corrupted")
                            loadedImage = nil
                        }
                    } else {
                        print("No response from server")
                        loadedImage = nil
                    }
                }
                loadFinishBlock(loadedImage)
            }
            if let urlTask = taskBlock {
                urlTask(getImageFromUrl)
            }
            getImageFromUrl.resume()
        }
    }
}

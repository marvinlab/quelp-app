//
//  UIImageView+Extension.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import UIKit
import MaterialComponents
import SnapKit

extension UIImageView {
    func loadImageFromURL(_ url:String?, failOverImage:UIImage?, showIndicator:Bool, finishedLoadingBlock: ((_ image: UIImage?) -> Void)? = { _ in }) {
        let imgURLloadingIndicator = MDCActivityIndicator()
        imgURLloadingIndicator.indicatorMode = .indeterminate
        imgURLloadingIndicator.radius = self.frame.size.width * 0.25
        imgURLloadingIndicator.frame.size = self.frame.size
        imgURLloadingIndicator.cycleColors = [.purple]
        self.addSubview(imgURLloadingIndicator)
        imgURLloadingIndicator.isHidden = !showIndicator
        imgURLloadingIndicator.startAnimating()
        self.image = nil
        if let urlString = url {
            UIImage.imageFromUrl(urlString: urlString) { image in
                if let finishBlock = finishedLoadingBlock {
                    finishBlock(image)
                }
                DispatchQueue.main.async {
                    self.image = image ?? failOverImage
                    imgURLloadingIndicator.stopAnimating()
                    imgURLloadingIndicator.isHidden = true
                }
            }
        } else {
            imgURLloadingIndicator.stopAnimating()
            imgURLloadingIndicator.isHidden = true
            self.image = failOverImage
        }
    }
}


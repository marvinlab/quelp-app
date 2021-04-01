//
//  QALoadingView.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/1/21.
//

import Foundation
import UIKit
import Lottie


public class QALoadingView {
    
    var bgView = UIView()
    var animationView = AnimationView(name: "Loading_Circle_Animation")
    
    class var shared: QALoadingView {
        struct Static {
            static let instance: QALoadingView = QALoadingView()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        bgView.frame = CGRect(x: 0,
                              y: 0,
                              width: view.frame.size.width,
                              height: view.frame.size.height)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(bgView)
        let resizeFactor : CGFloat = 0.6
        animationView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: bgView.frame.size.width * resizeFactor,
                                     height: bgView.frame.size.height * resizeFactor)
        animationView.center = bgView.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        view.addSubview(animationView)
        animationView.play()
    }
    
    public func hideOverlayView() {
        bgView.removeFromSuperview()
        animationView.removeFromSuperview()
    }
}


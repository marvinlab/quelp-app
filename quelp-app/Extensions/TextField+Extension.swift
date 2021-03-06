//
//  TextField+Extension.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import Foundation
import UIKit
import Material

extension TextField {
    
    func setDefaultTextField() {
        detail = ""
        placeholderActiveColor = .systemPurple
        placeholderNormalColor = .purple
        dividerActiveColor = .systemPurple
        dividerNormalColor = .purple
        textColor = .purple
        placeholderActiveColor = .systemPurple
        placeholderNormalColor = .purple
    }
    
    func setErroneousTextField(withErrorDetail errorString:String) {
        detail = errorString
        detailLabel.textAlignment = .left
        placeholderActiveColor = .red
        placeholderNormalColor = .red
        
        dividerActiveColor = .red
        dividerNormalColor = .red
        dividerColor = .red
        
        detailColor = .red
        clearIconButton?.tintColor = .red
    }
    
}

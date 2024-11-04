//
//  NSMutableAttributedString+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 12/5/22.
//

import UIKit

extension NSMutableAttributedString {
    
    func appendText(_ value:String,
               font: UIFont,
               foregroundColor: UIColor,
               backgroundColor: UIColor = .clear,
               underlineStyle: NSUnderlineStyle = []) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: value,
                attributes: [
                    .font :  font,
                    .foregroundColor : foregroundColor,
                    .backgroundColor: backgroundColor,
                    .underlineStyle : underlineStyle.rawValue
                ]))
        return self
    }
    
    
    func attachImage(_ image: UIImage, size: CGRect) -> NSMutableAttributedString {
        let attachment = NSTextAttachment(image: image)
        attachment.bounds = size
        self.append(NSAttributedString(attachment: attachment))
        return self
    }
    
}

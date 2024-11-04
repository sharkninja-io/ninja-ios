//
//  UILabel+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 9/15/22.
//

import UIKit

extension UILabel {
    func setStyle(_ style: LabelStyle, theme: ColorTheme = ColorThemeManager.shared.theme) {
        let props = style.properties(theme)
        self.font = props.font
        if let color = props.textColor {
            self.textColor = color
        }
        self.textAlignment = props.textAlignment
        self.lineBreakMode = props.lineBreakMode
        self.numberOfLines = props.numberOfLines
        self.adjustsFontSizeToFitWidth = props.adjustsFontSizeToFitWidth
        self.minimumScaleFactor = props.minimumScaleFactor
        self.allowsDefaultTighteningForTruncation = props.allowsDefaultTighteningForTruncation
    }
    
    func attachImage(_ image: UIImage, size: CGRect, imageFirst: Bool = true) {
        let attachment = NSTextAttachment(image: image)
        attachment.bounds = size
        let attributedString = attributedText ?? NSAttributedString(string: text ?? "")
        // Image first
        let mutableText = NSMutableAttributedString()
        if imageFirst {
            mutableText.append(NSAttributedString(attachment: attachment))
            mutableText.append(attributedString)
        } else {
            mutableText.append(attributedString)
            mutableText.append(NSAttributedString(attachment: attachment))
        }
        self.attributedText = mutableText
    }
    
    func underlineText(_ isUnderlined: Bool = true) {
         guard let text = self.text else {
             return
         }
         
         if isUnderlined {
             let attributeString =  NSMutableAttributedString(string: text)
             
             attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
             self.attributedText = attributeString
         } else {
             let attributeString =  NSMutableAttributedString(string: text)
             attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: [], range: NSMakeRange(0,attributeString.length))
             self.attributedText = attributeString
         }
     }
}

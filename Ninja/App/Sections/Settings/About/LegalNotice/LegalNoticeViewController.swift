//
//  LegalNoticeViewController.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/19/22.
//

import UIKit

class LegalNoticeViewController: BaseViewController<RTFView> {
    
    override func setupViews() {
        if let path = Bundle.main.url(forResource: "eula-en", withExtension: "rtf") {
            do {
                let attStr = try NSMutableAttributedString(url: path, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                subview.copyLabel.attributedText = attStr
            } catch let error {
                Logger.Error(error.localizedDescription)
            }
        }
    }
}

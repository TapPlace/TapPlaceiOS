//
//  NSMutableAttributedString+Extension.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/09.
//

import UIKit

extension NSMutableAttributedString {
    func addImageAttachment(image: UIImage, font: UIFont, textColor: UIColor, size: CGSize? = nil) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: textColor,
            .foregroundColor: textColor,
            .font: font
        ]

        self.append(
            NSAttributedString.init(
                //U+200C (zero-width non-joiner) is a non-printing character. It will not paste unnecessary space.
                string: "\u{200c}",
                attributes: textAttributes
            )
        )

        let attachment = NSTextAttachment()
        attachment.image = image.withRenderingMode(.alwaysTemplate)
        //Uncomment to set size of image.
        //P.S. font.capHeight sets height of image equal to font size.
        //let imageSize = size ?? CGSize.init(width: font.capHeight, height: font.capHeight)
        //attachment.bounds = CGRect(
        //    x: 0,
        //    y: 0,
        //    width: imageSize.width,
        //    height: imageSize.height
        //)
        let attachmentString = NSMutableAttributedString(attachment: attachment)
        attachmentString.addAttributes(
            textAttributes,
            range: NSMakeRange(
                0,
                attachmentString.length
            )
        )
        self.append(attachmentString)
    }
}

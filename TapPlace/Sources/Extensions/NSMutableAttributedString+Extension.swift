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

    func bold(string: String, fontSize: CGFloat, color: UIColor = .black) -> NSMutableAttributedString {
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }

    func regular(string: String, fontSize: CGFloat, color: UIColor = .black) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}

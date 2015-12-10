#! /usr/bin/python

from xml.dom import minidom

doc = minidom.parse('icomoon.svg')

swift_output_file = open('Icomoon.swift', 'w')
swift_output_file.write("""//
// Icomoon.swift
//
// This file was automatically created based on the `icomoon.svg` font file.
// Make sure to also copy over the `icomoon.ttf` font file.
//

import UIKit

private class FontLoader {
    class func loadFont(name: String) {
        let bundle = NSBundle(forClass: FontLoader.self)
        let fontURL = bundle.URLForResource(name, withExtension: "ttf")!
        let data = NSData(contentsOfURL: fontURL)!

        let provider = CGDataProviderCreateWithCFData(data)
        let font = CGFontCreateWithDataProvider(provider)!

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let errorDescription: CFStringRef = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSInternalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }
}

public extension UIFont {
    public class func icomoonOfSize(fontSize: CGFloat) -> UIFont {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }

        let name = "icomoon"
        if (UIFont.fontNamesForFamilyName(name).count == 0) {
            dispatch_once(&Static.onceToken) {
                FontLoader.loadFont(name)
            }
        }

        return UIFont(name: name, size: fontSize)!
    }
}

public extension UIImage {
    public static func icomoonWithName(name: Icomoon, textColor: UIColor, size: CGSize) -> UIImage {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.alignment = .Center
        let attributedString = NSAttributedString(string: String.icomoonWithName(name) as String, attributes: [NSFontAttributeName: UIFont.icomoonOfSize(24.0), NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName:paragraph])
        let size = sizeOfAttributeString(attributedString, maxWidth: size.width)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension String {
    public static func icomoonWithName(name: Icomoon) -> String {
        return name.rawValue.substringToIndex(name.rawValue.startIndex.advancedBy(1))
    }
}

private func sizeOfAttributeString(str: NSAttributedString, maxWidth: CGFloat) -> CGSize {
    let size = str.boundingRectWithSize(CGSizeMake(maxWidth, 1000), options:(NSStringDrawingOptions.UsesLineFragmentOrigin), context:nil).size
    return size
}

public enum Icomoon: String {
""")

glyph_count = 0
for glyph in doc.getElementsByTagName('glyph'):
    name = glyph.getAttribute('glyph-name')
    if name:
        name = name.title().replace('-', '')
        unicode = glyph.getAttribute('unicode')
        unicode = unicode.encode('unicode-escape').decode()
        unicode = unicode.replace('u', 'u{') + '}'
        swift_output_file.write('    case %s = "%s"\n' % (name, unicode))
        glyph_count += 1

swift_output_file.write('}')
swift_output_file.close()

print("Icomoon.swift created based on %i glyphs" % glyph_count)

doc.unlink()

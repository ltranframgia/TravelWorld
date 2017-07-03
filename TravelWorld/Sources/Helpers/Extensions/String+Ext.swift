import Foundation
import UIKit

extension String {

    var localized: String {
        return self.localizedWithComment(comment: "")
    }

    func localizedWithComment(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }

    func sizeToFitWidth(_ width: CGFloat, font: UIFont?) -> CGRect? {
        guard let _font = font else { return nil }
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: _font], context: nil)
        return boundingBox
    }
}

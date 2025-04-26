//  Created by Илья Беников on 25.04.25.

import UIKit

extension UIImageView {
    func configure(with image: UIImage, tintColor: UIColor? = nil) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = tintColor
    }
}

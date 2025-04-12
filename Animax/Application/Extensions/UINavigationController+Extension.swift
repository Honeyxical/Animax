//  Created by Илья Беников on 12.04.25.

import Foundation
import UIKit

public extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
      if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
        popToViewController(vc, animated: animated)
      }
    }
}

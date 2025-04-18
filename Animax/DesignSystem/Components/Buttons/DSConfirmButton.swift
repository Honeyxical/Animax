//  Created by Илья Беников on 18.04.25.

import UIKit

public final class DSConfirmButton: UIView {
    public struct ViewModel {
        public let title: String
        public let leftImage: UIImage?
        public let rightImage: UIImage?
        
        public struct Configuration {
            public let titleColor: UIColor
        }
    }
}

//  Created by Илья Беников on 01.07.25.

import UIKit
import SnapKit

final class IndicatorView: UIView {
    struct ViewModel {
        public let isActive: Bool
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with viewModel: ViewModel) {
        if viewModel.isActive {
            backgroundColor = Colors.Primary.primary
        } else {
            backgroundColor = Colors.Grayscale.gray400
        }
    }
    
    func setup() {
        layer.cornerRadius = 6
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.white.cgColor
    }
}

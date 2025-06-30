//  Created by Илья Беников on 30.06.25.

import UIKit
import SnapKit

final class DSShortButtonView: UIView {
    struct ViewModel {
        public let style: Style
        public let icon: UIImage
        public let tintColor: UIColor
        public let backgroundColor: UIColor
        
        public let action: (() -> Void)?
        
        init(
            style: Style,
            icon: UIImage,
            tintColor: UIColor,
            backgroundColor: UIColor,
            action: (() -> Void)? = nil
        ) {
            self.style = style
            self.icon = icon
            self.tintColor = tintColor
            self.backgroundColor = backgroundColor
            self.action = action
        }
        
        enum Style {
            case circle
            case square(borderColor: UIColor? = nil)
        }
    }
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with viewModel: ViewModel) {
        backgroundColor = viewModel.backgroundColor
        iconView.image = viewModel.icon.withTintColor(viewModel.tintColor)
        
        switch viewModel.style {
        case .circle:
            configureCircle()
        case let .square(borderColor):
            configureSquare(borderColor: borderColor)
        }
    }
    
    private func setup() {
        addSubview(iconView)
        
        snp.makeConstraints { view in
            view.size.equalTo(58)
        }
        
        iconView.snp.makeConstraints { view in
            view.center.equalToSuperview()
            view.size.equalTo(40)
        }
        
        clipsToBounds = true
    }
    
    private func configureCircle() {
        layer.cornerRadius = 30
        layer.borderWidth = 0
    }
    
    private func configureSquare(borderColor: UIColor?) {
        layer.cornerRadius = 16
        
        if let borderColor {
            layer.borderWidth = 1
            layer.borderColor = borderColor.cgColor
        }
    }
}

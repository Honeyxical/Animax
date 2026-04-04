//  Created by Илья Беников on 14.05.25.

import UIKit

final class OnboardingGradientView: UIView {
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [Colors.Others.black.cgColor, UIColor.clear.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 1.0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.0)
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setup() {
        layer.insertSublayer(gradientLayer, at: 0)
        isUserInteractionEnabled = false
        backgroundColor = .clear
    }
}

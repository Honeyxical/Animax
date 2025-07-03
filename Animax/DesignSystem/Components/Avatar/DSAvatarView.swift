//  Created by Илья Беников on 01.07.25.

import UIKit
import SnapKit

public final class DSAvatarView: UIView {
    struct ViewModel {
        public let profileImage: UIImage
        public let indicator: Indicator?
        
        public init(profileImage: UIImage, indicator: Indicator? = nil) {
            self.profileImage = profileImage
            self.indicator = indicator
        }
        
        enum Indicator {
            case indicator(isActive: Bool)
            case icon(_ image: UIImage, tintColor: UIColor)
        }
    }
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var indicatorView: IndicatorView?
    private var iconView: UIImageView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with viewModel: ViewModel) {
        profileImage.image = viewModel.profileImage
        
        switch viewModel.indicator {
        case let .indicator(isActive):
            createIndicator()
            indicatorView?.configure(with: IndicatorView.ViewModel(isActive: isActive))
            
            indicatorView?.isHidden = false
            iconView?.isHidden = true
        case let .icon(icon, tintColor):
            createIcon()
            iconView?.image = icon.withTintColor(tintColor)
            
            iconView?.isHidden = false
            indicatorView?.isHidden = true
        case .none:
            indicatorView?.isHidden = true
            iconView?.isHidden = true
        }
    }
}

private extension DSAvatarView {
    func setup() {
        addSubview(profileImage)
        
        profileImage.snp.makeConstraints { view in
            view.verticalEdges.equalToSuperview()
            view.horizontalEdges.equalToSuperview()
        }
        
        snp.makeConstraints { view in
            view.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        profileImage.layer.cornerRadius = 24
        profileImage.clipsToBounds = true
    }
    
    func createIndicator() {
        guard indicatorView == nil else { return }
        
        let indicatorView = IndicatorView()
        self.indicatorView = indicatorView
        
        addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { view in
            view.size.equalTo(12)
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }
    
    func createIcon() {
        guard iconView == nil else { return }
        
        let iconView = UIImageView()
        self.iconView = iconView
        
        addSubview(iconView)
        
        iconView.snp.makeConstraints { view in
            view.size.equalTo(12)
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }
}

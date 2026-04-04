//  Created by Илья Беников on 20.07.25.

import SnapKit

final class DSChipButtonView: UIView {
    struct ViewModel {
        let title: String
        let style: Style
        let size: Size
        let leftImage: UIImage?
        let rightImage: UIImage?
        let tintColor: UIColor?
        
        enum Style {
            case bordered
            case filled
        }
        
        enum Size {
            case small
            case medium
            case large
        }
        
        var height: CGFloat {
            switch size {
            case .large:
                45
            case .medium:
                38
            case .small:
                32
            }
        }
        
        var imageSize: CGFloat {
            switch size {
            case .large:
                24
            case .medium:
                20
            case .small:
                16
            }
        }
        
        var typography: UIFont? {
            switch size {
            case .large:
                Typography.Body.Bold.xLarge
            case .medium:
                Typography.Body.Semibold.large
            case .small:
                Typography.Body.Semibold.medium
            }
        }
    }
    
    private let titleLabel = UILabel()
    private var leftImageView: UIImageView?
    private var rightImageView: UIImageView?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with viewModel: ViewModel) {
        
    }
}

private extension DSChipButtonView {
    func setup() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { view in
            view.center.equalToSuperview()
            view.horizontalEdges.equalToSuperview().offset(4)
        }
    }
    
    func createLeftImageIfNeeded() {
        guard leftImageView == nil else { return }
        
        let leftImageView = UIImageView()
        self.leftImageView = leftImageView
        
        addSubview(leftImageView)
    }
}

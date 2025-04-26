//  Created by Илья Беников on 18.04.25.

import UIKit

public final class DSButton: UIView {
    public struct ViewModel {
        public let title: String
        public let leftSide: LeftSide?
        public let rightSide: RightSide?
        public let configuration: Configuration
        
        public let actionHandler: (() -> Void)?
        
        public init(
            title: String,
            leftSide: LeftSide?,
            rightSide: RightSide?,
            configuration: Configuration,
            actionHandler: (() -> Void)? = nil
        ) {
            self.title = title
            self.leftSide = leftSide
            self.rightSide = rightSide
            self.configuration = configuration
            self.actionHandler = actionHandler
        }
        
        public struct Configuration {
            public let titleColor: UIColor
            public let backgroundColor: UIColor
            public let roundingCorner: RoundingCorner
            
            public init(titleColor: UIColor, backgroundColor: UIColor, roundingCorner: RoundingCorner) {
                self.titleColor = titleColor
                self.backgroundColor = backgroundColor
                self.roundingCorner = roundingCorner
            }
        }
        
        public enum RoundingCorner {
            case filled
            case rounded
        }
        
        public enum LeftSide {
            case image(image: UIImage, tintColor: UIColor)
        }
        
        public enum RightSide {
            case image(image: UIImage, tintColor: UIColor)
        }
    }
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textLabel: UILabel = {
        let title = UILabel()
        title.font = Typography.Body.Bold.large
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private var leftImageView: UIImageView?
    private var rightImageView: UIImageView?
    
    private lazy var textLabelLeftConstraint: NSLayoutConstraint = textLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor)
    private lazy var textLabelRightConstraint: NSLayoutConstraint = textLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override public var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 58)
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: 58)
    }
    
    public func configure(with viewModel: ViewModel) {
        textLabelLeftConstraint.isActive = true
        textLabelRightConstraint.isActive = true
        
        textLabel.textColor = viewModel.configuration.titleColor
        textLabel.text = viewModel.title
        
        
        if let leftSide = viewModel.leftSide {
            switch leftSide {
            case let .image(image, tintColor):
                createLeftImageView()
                leftImageView?.configure(with: image, tintColor: tintColor)
            }
        }
        leftImageView?.isHidden = viewModel.leftSide == nil
        
        if let rightSide = viewModel.rightSide {
            switch rightSide {
            case let .image(image, tintColor):
                createRightImageView()
                rightImageView?.configure(with: image, tintColor: tintColor)
            }
        }
        rightImageView?.isHidden = viewModel.rightSide == nil
        
        backgroundColor = viewModel.configuration.backgroundColor
        
        switch viewModel.configuration.roundingCorner {
        case .filled:
            layer.cornerRadius = 16
        case .rounded:
            layer.cornerRadius = intrinsicContentSize.height / 2
        }
        
        layoutIfNeeded()
    }
}

extension DSButton {
    func setup() {
        addSubview(contentContainer)
        contentContainer.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentContainer.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            contentContainer.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            contentContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabelLeftConstraint,
            textLabelRightConstraint,
            
        ])
    }
    
    func createLeftImageView() {
        textLabelLeftConstraint.isActive = false
        guard leftImageView == nil else { return }
        
        let leftImageView = UIImageView()
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        self.leftImageView = leftImageView
        
        contentContainer.addSubview(leftImageView)
        NSLayoutConstraint.activate([
            leftImageView.heightAnchor.constraint(equalToConstant: 20),
            leftImageView.widthAnchor.constraint(equalToConstant: 20),
            leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            leftImageView.trailingAnchor.constraint(equalTo: textLabel.leadingAnchor, constant: -8)
        ])
    }
    
    func createRightImageView() {
        textLabelRightConstraint.isActive = false
        guard rightImageView == nil else { return }
        
        let rightImageView = UIImageView()
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        self.rightImageView = rightImageView
        
        contentContainer.addSubview(rightImageView)
        NSLayoutConstraint.activate([
            rightImageView.heightAnchor.constraint(equalToConstant: 20),
            rightImageView.widthAnchor.constraint(equalToConstant: 20),
            rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightImageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            rightImageView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 8)
        ])
    }
}

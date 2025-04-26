//  Created by Илья Беников on 13.04.25.

import UIKit

public final class DSTextField: UIView {
    public struct ViewModel {
        public let placeholder: String
        public let text: String?
        public let leftSide: LeftSide?
        public let rightSide: RightSide?
        public let state: State
        
        public init(
            placeholder: String,
            text: String?,
            leftSide: LeftSide?,
            rightSide: RightSide?,
            state: State
        ) {
            self.placeholder = placeholder
            self.text = text
            self.leftSide = leftSide
            self.rightSide = rightSide
            self.state = state
        }
        
        public  enum LeftSide {
            case image(UIImage)
            case dropDown
        }
        
        public enum RightSide {
            case image(UIImage)
        }
        
        public enum State {
            case active
            case `default`
            case fill
        }
    }
    
    private var leftImageView: UIImageView?
    private var rightImageView: UIImageView?
    
    private let textField = UITextField()
    
    private lazy var textFieldLeftSideConstraint: NSLayoutConstraint = textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
    private lazy var textFieldRightSideConstraint: NSLayoutConstraint  = textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: 56)
    }
    
    public func configure(with viewModel: ViewModel) {
        textFieldLeftSideConstraint.isActive = true
        textFieldRightSideConstraint.isActive = true
        
        textField.attributedPlaceholder = NSAttributedString(string: viewModel.placeholder, attributes: [.foregroundColor: Colors.Grayscale.gray500])
        textField.text = viewModel.text
        
        setupLeftSide(with: viewModel.leftSide)
        setupRightSide(with: viewModel.rightSide)
        
        leftImageView?.isHidden = viewModel.leftSide == nil
        rightImageView?.isHidden = viewModel.rightSide == nil
        
        configureState(viewModel.state)
    }
}

private extension DSTextField {
    func configureState(_ state: ViewModel.State) {
        switch state {
        case .active:
            textField.font = Typography.Body.Semibold.medium
            textField.textColor = Colors.Grayscale.gray900
            
            leftImageView?.tintColor = Colors.Primary.primary
            rightImageView?.tintColor = Colors.Primary.primary
            
            backgroundColor = Colors.Transparent.green
            layer.borderWidth = 1
            layer.borderColor = Colors.Primary.primary.cgColor
        case .default:
            textField.font = Typography.Body.Regular.medium
            textField.textColor = Colors.Grayscale.gray500
            
            leftImageView?.tintColor = Colors.Grayscale.gray500
            rightImageView?.tintColor = Colors.Grayscale.gray500
            
            backgroundColor = Colors.Grayscale.gray50
        case .fill:
            textField.font = Typography.Body.Semibold.medium
            textField.textColor = Colors.Grayscale.gray900
            
            leftImageView?.tintColor = Colors.Grayscale.gray900
            rightImageView?.tintColor = Colors.Grayscale.gray900
            
            backgroundColor = Colors.Grayscale.gray50
        }
    }
    
    func setupLeftSide(with viewModel: ViewModel.LeftSide?) {
        guard let leftSide = viewModel else { return }
        
        switch leftSide {
        case let .image(image):
            createLeftImageView()
            leftImageView?.image = image.withRenderingMode(.alwaysTemplate)
        case .dropDown:
            break
        }
    }
    
    func setupRightSide(with viewModel: ViewModel.RightSide?) {
        guard let rightSide = viewModel else { return }
        
        switch rightSide {
        case let .image(image):
            createRightImageView()
            rightImageView?.image = image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func createRightImageView() {
        guard rightImageView == nil else {
            textFieldRightSideConstraint.isActive = false
            return
        }
        let rightImageView = UIImageView()
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        self.rightImageView = rightImageView
        
        textFieldRightSideConstraint.isActive = false
        
        addSubview(rightImageView)
        NSLayoutConstraint.activate([
            rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            rightImageView.widthAnchor.constraint(equalToConstant: 20),
            rightImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textField.rightAnchor.constraint(equalTo: rightImageView.leftAnchor, constant: -12)
        ])
    }
    
    func createLeftImageView() {
        guard leftImageView == nil else {
            textFieldLeftSideConstraint.isActive = false
            return
        }
        let leftImageView = UIImageView()
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        self.leftImageView = leftImageView
        
        textFieldLeftSideConstraint.isActive = false
        
        addSubview(leftImageView)
        NSLayoutConstraint.activate([
            leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            leftImageView.widthAnchor.constraint(equalToConstant: 20),
            leftImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textField.leftAnchor.constraint(equalTo: leftImageView.rightAnchor, constant: 12)
        ])
    }
    
    func setup() {
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            textFieldLeftSideConstraint,
            textFieldRightSideConstraint
        ])
        
        layer.cornerRadius = 16
    }
}

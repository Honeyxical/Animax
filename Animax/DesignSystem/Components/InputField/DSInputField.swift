//  Created by Илья Беников on 13.04.25.

import UIKit

final class DSInputField: UIView {
    struct ViewModel {
        let placeholder: String
        let text: String?
        let leftSide: LeftSide?
        let rightSide: RightSide?
        let state: State
        
        enum LeftSide {
            case image(UIImage)
            case dropDown
        }
        
        enum RightSide {
            case image(UIImage)
        }
        
        enum State {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with viewModel: ViewModel) {
        textField.attributedPlaceholder = NSAttributedString(string: viewModel.placeholder, attributes: [.foregroundColor: UIColor.Grayscale.gray500])
        textField.text = viewModel.text
        
        setupLeftSide(with: viewModel.leftSide)
        setupRightSide(with: viewModel.rightSide)
        
        leftImageView?.isHidden = viewModel.leftSide == nil
        rightImageView?.isHidden = viewModel.rightSide == nil
        
        configureState(viewModel.state)
    }
}

private extension DSInputField {
    func configureState(_ state: ViewModel.State) {
        switch state {
        case .active:
            textField.font = .Body.Semibold.medium
            textField.textColor = .Grayscale.gray900
            
            leftImageView?.tintColor = .Primary.primary
            rightImageView?.tintColor = .Primary.primary
            
            backgroundColor = .Transparent.green
            layer.borderWidth = 1
            layer.borderColor = UIColor.Primary.primary.cgColor
        case .default:
            textField.font = .Body.Regular.medium
            textField.textColor = .Grayscale.gray500
            
            leftImageView?.tintColor = .Grayscale.gray500
            rightImageView?.tintColor = .Grayscale.gray500
            
            backgroundColor = .Grayscale.gray50
        case .fill:
            textField.font = .Body.Semibold.medium
            textField.textColor = .Grayscale.gray900
            
            leftImageView?.tintColor = .Grayscale.gray900
            rightImageView?.tintColor = .Grayscale.gray900
            
            backgroundColor = .Grayscale.gray50
        }
    }
    
    func setupLeftSide(with viewModel: ViewModel.LeftSide?) {
        guard let leftSide = viewModel else { return }
        
        switch leftSide {
        case let .image(image):
            configureLeftImageView(with: image)
        case .dropDown:
            break
        }
    }
    
    func setupRightSide(with viewModel: ViewModel.RightSide?) {
        guard let rightSide = viewModel else { return }
        
        switch rightSide {
        case let .image(image):
            configureRightImageView(with: image)
        }
    }
    
    func configureRightImageView(with image: UIImage) {
        let rightImageView = UIImageView(image: image)
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
    
    func configureLeftImageView(with image: UIImage) {
        let leftImageView = UIImageView(image: image)
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

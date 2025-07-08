//  Created by Илья Беников on 03.07.25.

import SnapKit

final class DSCheckboxView: UIView {
    struct ViewModel {
        public let isSelected: Bool
        
        public init(isSelected: Bool) {
            self.isSelected = isSelected
        }
    }
    
    private var checkmarkImageView: UIImageView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with viewModel: ViewModel) {
        if viewModel.isSelected {
            createImageViewIfNeeded()
            let config = UIImage.SymbolConfiguration(pointSize: 6, weight: .bold)
            checkmarkImageView.image = UIImage(systemName: "checkmark", withConfiguration: config)?.withTintColor(Colors.Others.white, renderingMode: .alwaysOriginal)
            backgroundColor = Colors.Primary.primary
            layer.borderWidth = 0
        } else {
            layer.borderColor = Colors.Primary.primary.cgColor
            layer.borderWidth = 3
            backgroundColor = Colors.Others.white
        }
        
        checkmarkImageView?.isHidden = !viewModel.isSelected
    }
    
    func createImageViewIfNeeded() {
        guard checkmarkImageView == nil else { return }
        
        let checkmarkImageView = UIImageView()
        
        addSubview(checkmarkImageView)
        
        checkmarkImageView.snp.makeConstraints { view in
            view.horizontalEdges.equalToSuperview()
            view.verticalEdges.equalToSuperview()
        }
        
        self.checkmarkImageView = checkmarkImageView
    }
}

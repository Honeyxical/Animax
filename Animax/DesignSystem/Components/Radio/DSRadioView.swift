//  Created by Илья Беников on 08.07.25.

import SnapKit

public final class DSRadioView: UIView {
    private var circleView: UIView?
    
    public  override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with viewModel: SelectedViewModel) {
        createCircleViewIfNeeded()
        
        circleView?.isHidden = !viewModel.isSelected
    }
    
    func setup() {
        layer.cornerRadius = 12
        layer.borderWidth = 3
        layer.borderColor = Colors.Primary.primary.cgColor
        backgroundColor = Colors.Others.white
        
        self.snp.makeConstraints { view in
            view.size.equalTo(24)
        }
    }
    
    func createCircleViewIfNeeded() {
        guard circleView == nil else { return }
        
        let circleView = UIView()
        addSubview(circleView)
        
        circleView.snp.makeConstraints { view in
            view.size.equalTo(14)
            view.centerX.equalToSuperview()
            view.centerY.equalToSuperview()
        }
        
        circleView.layer.cornerRadius = 7
        circleView.backgroundColor = Colors.Primary.primary
        
        self.circleView = circleView
    }
}

//  Created by Илья Беников on 20.07.25.

import SnapKit

final class DSToggleView: UISwitch {
    struct ViewModel {
        let isOn: Bool
        let isEnabled: Bool
    }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with viewModel: ViewModel) {
        tintColor = Colors.Primary.primary
        setOn(viewModel.isOn, animated: true)
    }
}

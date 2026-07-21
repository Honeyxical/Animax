import UIKit
import SnapKit

final class GenreTagView: UIView {
    private let label: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Semibold.xSmall
        l.textColor = Colors.Primary.primary
        return l
    }()

    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        addSubview(label)
        backgroundColor = Colors.Transparent.green
        layer.cornerRadius = 8
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }
    }

    required init?(coder: NSCoder) { fatalError() }
}

import UIKit
import SnapKit

final class HomeSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HomeSectionHeaderView"

    var onSeeAll: (() -> Void)?

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Heading.heading5
        label.textColor = Colors.Grayscale.gray900
        return label
    }()

    private let seeAllLabel: UILabel = {
        let label = UILabel()
        label.text = "See all"
        label.font = Typography.Body.Semibold.medium
        label.textColor = Colors.Primary.primary
        label.isUserInteractionEnabled = true
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    func configure(with title: String, showSeeAll: Bool = true, onSeeAll: (() -> Void)? = nil) {
        titleLabel.text = title
        self.onSeeAll = onSeeAll
        seeAllLabel.isHidden = !showSeeAll
    }
}

// MARK: - Private

private extension HomeSectionHeaderView {
    func setup() {
        addSubview(titleLabel)
        addSubview(seeAllLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(seeAllLabel.snp.leading).offset(-8)
        }

        seeAllLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(seeAllTapped))
        seeAllLabel.addGestureRecognizer(tap)
    }

    @objc func seeAllTapped() {
        onSeeAll?()
    }
}

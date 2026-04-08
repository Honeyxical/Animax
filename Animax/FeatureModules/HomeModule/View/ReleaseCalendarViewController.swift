import UIKit
import SnapKit

final class ReleaseCalendarViewController: BaseViewController {

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Coming Soon"
        label.font = Typography.Heading.heading5
        label.textColor = Colors.Grayscale.gray500
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Release Calendar"

        view.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

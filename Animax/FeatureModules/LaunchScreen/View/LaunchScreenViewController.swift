import UIKit
import SnapKit

final class LaunchScreenViewController: BaseViewController {
    var output: LaunchScreenViewOutput?

    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = Colors.Primary.primary
        ai.hidesWhenStopped = true
        return ai
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output?.viewDidLoad()
    }
}

extension LaunchScreenViewController: LaunchScreenViewInput {
    func setOutput(_ output: LaunchScreenViewOutput) {
        self.output = output
    }

    func startAnimation() {
        activityIndicator.startAnimating()
    }
}

private extension LaunchScreenViewController {
    func setup() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(activityIndicator)

        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(160)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-120)
        }
    }
}

//  Created on 21.03.25

import UIKit

final class LaunchScreenViewController: BaseViewController {
	var output: LaunchScreenViewOutput?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
		output?.viewDidLoad()
	}
}

private extension LaunchScreenViewController {
    func setupSubviews() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 160),
            logoImageView.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        view.backgroundColor = .white
    }
}
    
extension LaunchScreenViewController: LaunchScreenViewInput {
	func setOutput(_ output: LaunchScreenViewOutput) {
		self.output = output
	}
}

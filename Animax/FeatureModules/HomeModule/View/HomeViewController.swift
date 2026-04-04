//  Created on 22.11.25

import UIKit

final class HomeViewController: BaseViewController {
	var output: HomeViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
		output?.viewDidLoad()
	}

	private func setupSubviews() {
        view.backgroundColor = Colors.Others.white
    }
}

extension HomeViewController: HomeViewInput {
	func setTitle(_ title: String) {}

	func setOutput(_ output: HomeViewOutput) {
		self.output = output
	}
}

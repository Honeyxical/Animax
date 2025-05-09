//  Created on 09.05.25

import UIKit

final class OnboardingViewController: BaseViewController {
	var output: OnboardingViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
		output?.viewDidLoad()
	}

	private func setupSubviews() {}
}

extension OnboardingViewController: OnboardingViewInput {
	func setTitle(_ title: String) {}

	func setOutput(_ output: OnboardingViewOutput) {
		self.output = output
	}
}

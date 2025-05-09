//  Created on ___DATE___

import UIKit

final class ___VARIABLE_moduleName___ViewController: BaseViewController {
	var output: ___VARIABLE_moduleName___ViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubviews()
		output?.viewDidLoad()
	}

	private func setupSubviews() {}
}

extension ___VARIABLE_moduleName___ViewController: ___VARIABLE_moduleName___ViewInput {
	func setTitle(_ title: String) {}

	func setOutput(_ output: ___VARIABLE_moduleName___ViewOutput) {
		self.output = output
	}
}

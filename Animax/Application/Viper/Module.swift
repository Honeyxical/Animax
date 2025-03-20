//  Created by Ilya Benikov on 29.04.24.

import UIKit

public struct Module<Input, Output> {
	public var view: BaseViewController

	public var input: Input
	public var output: WeakContainer<Output>?

	public init(view: BaseViewController, input: Input, output: Output?) {
		self.view = view
		
		self.input = input
		if let output = output {
			self.output = WeakContainer(value: output)
		}
	}

	public func toPresent() -> UIViewController {
		view
	}
}

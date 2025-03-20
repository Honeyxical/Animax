//  Created by Ilya Benikov on 29.04.24.

import SwiftUI
import Foundation

open class BaseViewController: UIViewController {
	public convenience init(withoutXib: Bool) {
		if withoutXib {
			self.init(nibName: nil, bundle: nil)
		} else {
			self.init()
		}
	}

	override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

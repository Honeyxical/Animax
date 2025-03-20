//  Created by Ilya Benikov on 29.04.24.

import Foundation

open class BasePresenter<O, I, R, V> {
	public let interactor: I
	public let router: R
	private let viewWeakContainer: WeakContainer<V>
	private let moduleOutputWeakContainer: WeakContainer<O>?
	
	public var view: V? {
		viewWeakContainer.value
	}

	public var moduleOutput: O? {
		moduleOutputWeakContainer?.value
	}

	public init(
		interactor: I,
		router: R,
		view: V,
		moduleOutput: O?
	) {
		self.interactor = interactor
		self.router = router
		viewWeakContainer = WeakContainer(value: view)
		if let moduleOutput = moduleOutput {
			moduleOutputWeakContainer = WeakContainer(value: moduleOutput)
		} else {
			moduleOutputWeakContainer = nil
		}
	}
}
/*
 Перенести переменные сюда
 Сделать через дженерики
 */

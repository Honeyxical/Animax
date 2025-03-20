//  Created by Ilya Benikov on 29.04.24.

import Foundation
import UIKit

public class BaseRouter<ROUTINGHANDLER> {
	public var moduleRoutingHandler: ROUTINGHANDLER? {
		get {
			moduleRoutingHandlerWeakContainer?.value
		} set {
			if let value = newValue {
				moduleRoutingHandlerWeakContainer = WeakContainer(value: value)
			} else {
				moduleRoutingHandlerWeakContainer = nil
			}
		}
	}
	
	var viewController: UIViewController
	private var moduleRoutingHandlerWeakContainer: WeakContainer<ROUTINGHANDLER>?
	
	public init(viewController: UIViewController) {
		self.viewController = viewController
	}
}

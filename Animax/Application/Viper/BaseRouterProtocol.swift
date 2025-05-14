//  Created by Ilya Benikov on 29.04.24.

import Foundation
import UIKit

public class BaseRouter<ROUTINGHANDLER> {
	public var moduleRoutingHandler: ROUTINGHANDLER?
	
	var viewController: UIViewController
	
	public init(viewController: UIViewController) {
		self.viewController = viewController
	}
}

//  Created by Ilya Benikov on 29.04.24.

import Foundation

public class WeakContainer<T> {
	private weak var _value: AnyObject?
	public var value: T? {
		get { _value as? T }
		set { _value = newValue as AnyObject }
	}

	public init(value: T) {
		_value = value as AnyObject
	}
}

public final class WeakObjectContainer<T: AnyObject> {
	public private(set) weak var value: T?

	public init(value: T) {
		self.value = value
	}
}

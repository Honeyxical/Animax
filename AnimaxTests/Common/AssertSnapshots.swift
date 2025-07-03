//  Created by Илья Беников on 13.04.25.

import SnapshotTesting
import XCTest

extension XCTestCase {
    /// Позволяет перезаписать все снапшоты
    private static let isRecording: Bool = {
        false
    }()
    
    func assertSnapshot(
        _ view: UIView,
        name: String,
        size: CGSize,
        isRecording: Bool = isRecording,
        filePath: StaticString = #file,
        line: UInt = #line
    ) {
        let className = String(describing: type(of: self))
        let snapshotName = className + "_\(name)"
        
        assertSnapshots(
            matching: view,
            as: [.image(precision: 0.98, size: size)],
            record: isRecording,
            file: filePath,
            testName: snapshotName,
            line: line
        )
    }
}

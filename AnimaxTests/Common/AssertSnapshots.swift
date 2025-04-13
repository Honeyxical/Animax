//  Created by Илья Беников on 13.04.25.

import SnapshotTesting
import XCTest

extension XCTestCase {
    func assertSnapshot(
        _ view: UIView,
        name: String,
        size: CGSize,
        isRecording: Bool = false,
        filePath: StaticString = #file,
        line: UInt = #line
    ) {
        assertSnapshots(
            matching: view,
            as: [.image(precision: 0.98, size: size)],
            record: isRecording,
            file: filePath,
            testName: name,
            line: line
        )
    }
}

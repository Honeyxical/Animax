//  Created by Илья Беников on 13.04.25.

import XCTest
import SnapshotTesting
import Animax

final class DSInputFieldSnapshots: XCTestCase {
    func test_configure() {
        // arrange
        let sut = DSInputField()
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: nil,
                rightSide: nil,
                state: .active
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure", size: sut.sizeThatFits(CGSize(width: 300, height: 0)), isRecording: true)
    }
}

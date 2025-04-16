//  Created by Илья Беников on 13.04.25.

import XCTest
import SnapshotTesting
import Animax

final class DSInputFieldSnapshots: XCTestCase {
    func test_configure_whenActive() {
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
        assertSnapshot(sut, name: "configure_whenActive", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenDefault() {
        // arrange
        let sut = DSInputField()
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: nil,
                rightSide: nil,
                state: .default
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenDefault", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenFill() {
        // arrange
        let sut = DSInputField()
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: nil,
                rightSide: nil,
                state: .fill
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenFill", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenFill_withText() {
        // arrange
        let sut = DSInputField()
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: "Lorem Ipsum",
                leftSide: nil,
                rightSide: nil,
                state: .fill
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenFill_withText", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenLeftAndRightImages_andActive() {
        // arrange
        let sut = DSInputField()
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: .image(.Bold.lock!),
                rightSide: .image(.Bold.hide!),
                state: .active
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenLeftAndRightImages_and_active", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenLeftAndRightImages_andDefault() {
        // arrange
        let sut = DSInputField()
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: .image(.Bold.lock!),
                rightSide: .image(.Bold.hide!),
                state: .default
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenLeftAndRightImages_andDefault", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenLeftAndRightImages_andFill() {
        // arrange
        let sut = DSInputField()
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: .image(.Bold.lock!),
                rightSide: .image(.Bold.hide!),
                state: .fill
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenLeftAndRightImages_andFill", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_reuse_whenWithImagesAfterHasNoImages() {
        // arrange
        let sut = DSInputField()
        
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: nil,
                rightSide: nil,
                state: .fill
            )
        )
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: .image(.Bold.lock!),
                rightSide: .image(.Bold.hide!),
                state: .fill
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_reuse_whenWithImagesAfterHasNoImages", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_reuse_whenHasNoImagesAfterImages() {
        // arrange
        let sut = DSInputField()
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: .image(.Bold.lock!),
                rightSide: .image(.Bold.hide!),
                state: .fill
            )
        )
        
        // act
        sut.configure(
            with: DSInputField.ViewModel(
                placeholder: "Placeholder",
                text: nil,
                leftSide: nil,
                rightSide: nil,
                state: .fill
            )
        )
        
        
        // arrange
        assertSnapshot(sut, name: "configure_reuse_whenHasNoImagesAfterImages", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
}

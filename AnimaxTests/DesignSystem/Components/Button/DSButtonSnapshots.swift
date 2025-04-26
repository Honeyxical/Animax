//  Created by Илья Беников on 25.04.25.

import XCTest
import SnapshotTesting
import Animax

final class DDSButtonSnapshotsTests: XCTestCase {
    func test_configure() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button",
                leftSide: nil,
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenRounded() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button",
                leftSide: nil,
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .rounded
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenRounded", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_withBothImages() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button",
                leftSide: .image(image: Iconography.Bold.buy!, tintColor: Colors.Others.white),
                rightSide: .image(image: Iconography.Bold.arrowRight!, tintColor: Colors.Others.white),
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_withBothImages", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenLeftImage() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button",
                leftSide: .image(image: Iconography.Bold.buy!, tintColor: Colors.Others.white),
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenLeftImage", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenRightImage() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button",
                leftSide: nil,
                rightSide: .image(image: Iconography.Bold.arrowRight!, tintColor: Colors.Others.white),
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenRightImage", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenRightImage_withLong() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button when verrrry long value value value value value",
                leftSide: nil,
                rightSide: .image(image: Iconography.Bold.arrowRight!, tintColor: Colors.Others.white),
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenRightImage_withLong", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenLeftImageWithLong() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button when verrrry long value value value value value",
                leftSide: .image(image: Iconography.Bold.buy!, tintColor: Colors.Others.white),
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenLeftImage_withLong", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_whenLongValue() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button when verrrry long value value value value value",
                leftSide: nil,
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_whenLongValue", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_configure_withBothImages_withLong() {
        // arrange
        let sut = DSButton()
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button when verrrry long value value value value value",
                leftSide: .image(image: Iconography.Bold.buy!, tintColor: Colors.Others.white),
                rightSide: .image(image: Iconography.Bold.arrowRight!, tintColor: Colors.Others.white),
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // arrange
        assertSnapshot(sut, name: "configure_withBothImages_withLong", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_reuse_whenWithoutImages_afterImages() {
        // arrange
        let sut = DSButton()
        
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button",
                leftSide: .image(image: Iconography.Bold.buy!, tintColor: Colors.Others.white),
                rightSide: .image(image: Iconography.Bold.arrowRight!, tintColor: Colors.Others.white),
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button when verrrry long value value value value value",
                leftSide: nil,
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // assert
        assertSnapshot(sut, name: "reuse_whenWithoutImages_afterImages", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
    
    func test_reuse_whenImages_afterWithoutImages() {
        // arrange
        let sut = DSButton()
        
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button when verrrry long value value value value value",
                leftSide: nil,
                rightSide: nil,
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // act
        sut.configure(
            with: DSButton.ViewModel(
                title: "Button",
                leftSide: .image(image: Iconography.Bold.buy!, tintColor: Colors.Others.white),
                rightSide: .image(image: Iconography.Bold.arrowRight!, tintColor: Colors.Others.white),
                configuration: DSButton.ViewModel.Configuration(
                    titleColor: Colors.Others.white,
                    backgroundColor: Colors.Primary.primary,
                    roundingCorner: .filled
                )
            )
        )
        
        // assert
        assertSnapshot(sut, name: "reuse_whenImages_afterWithoutImages", size: sut.sizeThatFits(CGSize(width: 300, height: 0)))
    }
}

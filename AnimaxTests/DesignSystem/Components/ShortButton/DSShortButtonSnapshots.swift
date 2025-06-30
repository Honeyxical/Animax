//  Created by Илья Беников on 30.06.25.

import XCTest
import SnapshotTesting

@testable import Animax

final class DSShortButtonSnapshots: XCTestCase {
    private var sut: DSShortButtonView!
    
    override func setUp() {
        super.setUp()
        sut = DSShortButtonView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_circle() {
        // act
        sut.configure(
            with: DSShortButtonView.ViewModel(
                style: .circle,
                icon: Iconography.Curved.plus!,
                tintColor: Colors.Others.white,
                backgroundColor: Colors.Primary.primary
            )
        )
        
        // assert
        assertSnapshot(sut, name: "circle", size: CGSize(width: 58, height: 58))
    }
    
    func test_square() {
        // act
        sut.configure(
            with: DSShortButtonView.ViewModel(
                style: .square(borderColor: Colors.Grayscale.gray300),
                icon: Iconography.Curved.plus!,
                tintColor: Colors.Others.black,
                backgroundColor: Colors.Others.white
            )
        )
        
        // assert
        assertSnapshot(sut, name: "square", size: CGSize(width: 58, height: 58))
    }
    
    func test_square_whenGreen() {
        // act
        sut.configure(
            with: DSShortButtonView.ViewModel(
                style: .square(borderColor: nil),
                icon: Iconography.Curved.plus!,
                tintColor: Colors.Others.white,
                backgroundColor: Colors.Primary.primary
            )
        )
        
        // assert
        assertSnapshot(sut, name: "square_green", size: CGSize(width: 58, height: 58))
    }
    
    func test_square_whenDark() {
        // act
        sut.configure(
            with: DSShortButtonView.ViewModel(
                style: .square(borderColor: Colors.Dark.dark3),
                icon: Iconography.Curved.plus!,
                tintColor: Colors.Others.white,
                backgroundColor: Colors.Dark.dark2
            )
        )
        
        // assert
        assertSnapshot(sut, name: "square_dark", size: CGSize(width: 58, height: 58))
    }
    
    func test_reuse_whenCircleAfterSquare() {
        // arrange
        sut.configure(
            with: DSShortButtonView.ViewModel(
                style: .square(borderColor: Colors.Dark.dark3),
                icon: Iconography.Curved.plus!,
                tintColor: Colors.Others.white,
                backgroundColor: Colors.Dark.dark2
            )
        )
        
        // act
        sut.configure(
            with: DSShortButtonView.ViewModel(
                style: .circle,
                icon: Iconography.Curved.plus!,
                tintColor: Colors.Others.white,
                backgroundColor: Colors.Primary.primary
            )
        )
        
        // assert
        assertSnapshot(sut, name: "reuse_whenCircleAfterSquare", size: CGSize(width: 58, height: 58))
    }
    
    func test_reuse_whenSquareAfterCircle() {
        // arrange
        sut.configure(
            with: DSShortButtonView.ViewModel(
                style: .circle,
                icon: Iconography.Curved.plus!,
                tintColor: Colors.Others.white,
                backgroundColor: Colors.Primary.primary
            )
        )
        
        // act
        sut.configure(
            with: DSShortButtonView.ViewModel(
                style: .square(borderColor: Colors.Dark.dark3),
                icon: Iconography.Curved.plus!,
                tintColor: Colors.Others.white,
                backgroundColor: Colors.Dark.dark2
            )
        )
        
        // assert
        assertSnapshot(sut, name: "reuse_whenSquareAfterCircle", size: CGSize(width: 58, height: 58))
    }
}

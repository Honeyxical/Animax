//  Created by Илья Беников on 02.07.25.

import XCTest
import SnapshotTesting

@testable import Animax

final class DSAvatarViewSnapshots: XCTestCase {
    private var sut: DSAvatarView!
    
    override func setUp() {
        super.setUp()
        sut = DSAvatarView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_configure() {
        // act
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: .indicator(isActive: true)
            )
        )
        
        // assert
        assertSnapshot(sut, name: "configure_whenActive", size: CGSize(width: 48, height: 48))
    }
    
    func test_configure_whenNotActive() {
        // act
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: .indicator(isActive: false)
            )
        )
        
        // assert
        assertSnapshot(sut, name: "configure_whenNotActive", size: CGSize(width: 48, height: 48))
    }
    
    func test_configure_whenCustomImage() {
        // act
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: .icon(Iconography.Bold.editSquare!, tintColor: Colors.Primary.primary)
            )
        )
        
        // assert
        assertSnapshot(sut, name: "configure_whenCustomImage", size: CGSize(width: 48, height: 48))
    }
    
    func test_configure_whenOnlyImage() {
        // act
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: nil
            )
        )
        
        // assert
        assertSnapshot(sut, name: "configure_whenOnlyImage", size: CGSize(width: 48, height: 48))
    }
    
    func test_reuse_whenNoIconAfterIcon() {
        // arrange
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: .icon(Iconography.Bold.editSquare!, tintColor: Colors.Primary.primary)
            )
        )
        
        // act
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: nil
            )
        )
        
        // assert
        assertSnapshot(sut, name: "reuse_whenNoIconAfterIcon", size: CGSize(width: 48, height: 48))
    }
    
    func test_reuse_whenIconAfterIndicator() {
        // arrange
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: .indicator(isActive: false)
            )
        )
        
        // act
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: .icon(Iconography.Bold.editSquare!, tintColor: Colors.Primary.primary)
            )
        )
        
        // assert
        assertSnapshot(sut, name: "reuse_whenIconAfterIndicator", size: CGSize(width: 48, height: 48))
    }
    
    func test_reuse_whenIndicatorAfterIcon() {
        // arrange
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: .icon(Iconography.Bold.editSquare!, tintColor: Colors.Primary.primary)
            )
        )
        
        // act
        sut.configure(
            with: DSAvatarView.ViewModel(
                profileImage: UIImage(
                    named: "banner_not_for_use"
                )!,
                indicator: .indicator(isActive: false)
            )
        )
        
        // assert
        assertSnapshot(sut, name: "reuse_whenIndicatorAfterIcon", size: CGSize(width: 48, height: 48))
    }
}

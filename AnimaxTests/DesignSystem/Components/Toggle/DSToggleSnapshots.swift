//  Created by Илья Беников on 20.07.25.

import XCTest
import SnapshotTesting

@testable import Animax

final class DSToggleViewSnapshots: XCTestCase {
    private var sut: DSToggleView!
    
    override func setUp() {
        super.setUp()
        sut = DSToggleView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_configure_whenOn() {
        // act
        sut.configure(with: DSToggleView.ViewModel(isOn: true, isEnabled: false))
        
        // assert
        assertSnapshot(sut, name: "configure_whenOn", size: CGSize(width: 44, height: 24))
    }
    
    func test_configure_whenOff() {
        // act
        sut.configure(with: DSToggleView.ViewModel(isOn: false, isEnabled: false))
        
        // assert
        assertSnapshot(sut, name: "configure_whenOff", size: CGSize(width: 44, height: 24))
    }
    
    func test_reuse_whenOffAfterOn() {
        // arrange
        sut.configure(with: DSToggleView.ViewModel(isOn: true, isEnabled: false))
        
        // act
        sut.configure(with: DSToggleView.ViewModel(isOn: false, isEnabled: false))
        
        // assert
        assertSnapshot(sut, name: "reuse_whenOffAfterOn", size: CGSize(width: 44, height: 24))
    }
    
    func test_reuse_whenOnAfterOff() {
        // arrange
        sut.configure(with: DSToggleView.ViewModel(isOn: false, isEnabled: false))
        
        // act
        sut.configure(with: DSToggleView.ViewModel(isOn: true, isEnabled: false))
        
        // assert
        assertSnapshot(sut, name: "reuse_whenOnAfterOff", size: CGSize(width: 44, height: 24))
    }
}

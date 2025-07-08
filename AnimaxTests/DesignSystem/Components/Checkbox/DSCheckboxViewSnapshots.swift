//  Created by Илья Беников on 03.07.25.

import XCTest
import SnapshotTesting

@testable import Animax

final class DSCheckboxViewSnapshots: XCTestCase {
    private var sut: DSCheckboxView!
    
    override func setUp() {
        super.setUp()
        sut = DSCheckboxView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_configure_whenSelected() {
        //act
        sut.configure(with: DSCheckboxView.ViewModel(isSelected: true))
        
        // asser
        assertSnapshot(sut, name: "configure_whenSelected", size: CGSize(width: 24, height: 24), isRecording: true)
    }
    
    func test_configure_whenNotSelected() {
        //act
        sut.configure(with: DSCheckboxView.ViewModel(isSelected: false))
        
        // asser
        assertSnapshot(sut, name: "configure_whenNotSelected", size: CGSize(width: 24, height: 24), isRecording: true)
    }
    
    func test_reuse_whenSelectedAfterNotSelected() {
        // arrange
        sut.configure(with: DSCheckboxView.ViewModel(isSelected: false))
        
        // act
        sut.configure(with: DSCheckboxView.ViewModel(isSelected: true))
        
        // assert
        assertSnapshot(sut, name: "reuse_whenSelectedAfterNotSelected", size: CGSize(width: 24, height: 24), isRecording: true)
    }
    
    func test_reuse_whenNotSelectedAfterSelected() {
        // arrange
        sut.configure(with: DSCheckboxView.ViewModel(isSelected: true))
        
        // act
        sut.configure(with: DSCheckboxView.ViewModel(isSelected: false))
        
        // assert
        assertSnapshot(sut, name: "reuse_whenNotSelectedAfterSelected", size: CGSize(width: 24, height: 24), isRecording: true)
    }
}

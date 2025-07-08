//  Created by Илья Беников on 08.07.25.

import XCTest
import SnapshotTesting

@testable import Animax

final class DSRadioViewSnapshots: XCTestCase {
    private var sut: DSRadioView!
    
    override func setUp() {
        super.setUp()
        sut = DSRadioView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_configure_whenSelected() {
        //act
        sut.configure(with: SelectedViewModel(isSelected: true))
        
        // asser
        assertSnapshot(sut, name: "configure_whenSelected", size: CGSize(width: 24, height: 24))
    }
    
    func test_configure_whenNotSelected() {
        //act
        sut.configure(with: SelectedViewModel(isSelected: false))
        
        // asser
        assertSnapshot(sut, name: "configure_whenNotSelected", size: CGSize(width: 24, height: 24))
    }
    
    func test_reuse_whenSelectedAfterNotSelected() {
        // arrange
        sut.configure(with: SelectedViewModel(isSelected: false))
        
        // act
        sut.configure(with: SelectedViewModel(isSelected: true))
        
        // assert
        assertSnapshot(sut, name: "reuse_whenSelectedAfterNotSelected", size: CGSize(width: 24, height: 24))
    }
    
    func test_reuse_whenNotSelectedAfterSelected() {
        // arrange
        sut.configure(with: SelectedViewModel(isSelected: true))
        
        // act
        sut.configure(with: SelectedViewModel(isSelected: false))
        
        // assert
        assertSnapshot(sut, name: "reuse_whenNotSelectedAfterSelected", size: CGSize(width: 24, height: 24))
    }
}

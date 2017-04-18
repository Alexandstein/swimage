//
//  SwImageTests.swift
//  SwImageTests
//
//  Created by Alex Stein on 4/16/17.
//  Copyright © 2017 Alexander Stein. All rights reserved.
//

import XCTest
@testable import SwImage

class SwImageTests: XCTestCase {
    
    ///Helper file manager
    let fileManager = FileManager.default
    
    ///
    var testPngImage : NSImage?
    
    ///Base path to test with
    let testBasePath = URL(fileURLWithPath: "/Users/alexanderstein/Desktop/Programming/Projects/iOS + Mac/SwImage/SwImageTests/")
    let testOutputFolderName = "testOutput"
    ///Name of main test image
    let testImageName = "Pom.png"
    ///Name of main output image
    let testImageOutputName = "output.png"
    
    ///Path for to get to the pom.jpg test image
    var testImagePath : URL{
        get{
            return testBasePath.appendingPathComponent(testImageName)
        }
    }
    ///Invalid pathway
    var testImagePath_inavalid : URL{
        get{
            return testBasePath.appendingPathComponent("Nonexistent Pathsdfssd")
        }
    }
    
    ///The output folder path
    var testImageOutputFolderPath  : URL{
        get{
            return testBasePath.appendingPathComponent(testOutputFolderName, isDirectory: true)
        }
    }
    
    var testImageOutputFilePath : URL{
        get{
            return testImageOutputFolderPath.appendingPathComponent(testImageOutputName)
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testPngImage = NSImage(contentsOf: testImagePath)
        
        //Create test folder
        fileManager.changeCurrentDirectoryPath(testBasePath.path)
        do{
            try fileManager.createDirectory(atPath: testOutputFolderName, withIntermediateDirectories: false, attributes: nil)
        }catch{
            print("Test folder creation failed")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //Delete test folder
        do{
            //Delete directory and recreate icons
            try fileManager.removeItem(at: testImageOutputFolderPath)
        }catch{
            print("Folder deletion failed")
        }
        super.tearDown()
    }
    
    //Tests whether the file is able to load
    func testImageIsLoading(){
        XCTAssert(testPngImage != nil, "Test image won't load")
    }
    
    //Test whether NSImage fetching is working correctly
    func testFetchImageFromPath_Success(){
        testPngImage = SwImage.fetchImageFromPath(testImagePath)
        XCTAssert(testPngImage != nil)
    }
    
    func testFetchImageFromPath_Failed(){
        testPngImage = SwImage.fetchImageFromPath(testImagePath_inavalid)
        XCTAssert(testPngImage == nil)
    }
    
    func testWriteImageToFile_Success(){
        let success = SwImage.writeImageToFile(testPngImage!, outputPath: testImageOutputFilePath)
        XCTAssert(success)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

import UIKit
import XCTest

class Object: NSCoder {

  var property: String?

  required convenience init(coder decoder: NSCoder) {
    self.init()

    self.property = decoder.decodeObjectForKey("property") as? String
  }

  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.property, forKey: "property")
  }

}

class Tests: XCTestCase {

  func testSavingObjectWithFilename() {
    let object = Object()
    object.property = "My Property"
    Storage.save(object: object, "RootObject.extension") { error in
      XCTAssertNil(error)
    }
  }

  func testSavingObjectWithPathAndFilename() {
    let object = Object()
    object.property = "My Property"

    Storage.save(object: object, "Folder/RootObject.extension") { error in
      XCTAssertNil(error)
    }
  }

  func testSavingObjectWithDeepPathAndFilename() {
    let object = Object()
    object.property = "My Property"

    Storage.save(object: object, "Folder/SubFolder/RootObject.extension") { error in
      XCTAssertNil(error)
    }
  }

  func testSaveSavingAndLoadingObject() {
    let initialObject = Object()
    initialObject.property = "My Property"

    Storage.save(object: initialObject, "Folder/SaveObject.extension") { error in
      XCTAssertNil(error)
    }

    let loadedObject = Storage.load("Folder/SaveObject.extension") as? Object
    if loadedObject != nil {
      XCTAssertEqual(initialObject.property!, loadedObject!.property!)
    }
  }

  func testSaveAndLoadContentsToFile() {
    let path = "Folder/test.txt"
    let expectedString = "My string"

    Storage.save(contents: expectedString, path) { error in
      XCTAssertNil(error)
    }

    let loadedString = Storage.load(contentsAtPath: path)
    XCTAssertEqual(expectedString, loadedString!)
  }
}

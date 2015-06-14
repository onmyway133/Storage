import UIKit

public struct Storage {

  static var fileManager = {
    return NSFileManager.defaultManager()
    }()

  static let applicationDirectory: String = {
    let paths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let basePath: AnyObject! = (paths.count > 0) ? paths.firstObject : nil
    return basePath as! String;
  }()

  private static func buildPath(path: URLStringConvertible, createPath: Bool) -> String {
    var buildPath = path.string
    if path.string != Storage.applicationDirectory {
      buildPath = "\(Storage.applicationDirectory)/\(path.string)"

      let folderPath = buildPath.stringByDeletingLastPathComponent

      if folderPath != Storage.applicationDirectory {
        var error: NSError?
        fileManager.createDirectoryAtPath(folderPath,
          withIntermediateDirectories: true,
          attributes: nil,
          error: &error)
      }
    }

    return buildPath
  }

  static func load(path: URLStringConvertible) -> AnyObject? {
    let loadPath = Storage.buildPath(path, createPath: false)
    return fileManager.fileExistsAtPath(loadPath)
      ? NSKeyedUnarchiver.unarchiveObjectWithFile(loadPath)
      : nil
  }

  static func save(# object: AnyObject, _ path: URLStringConvertible = Storage.applicationDirectory, closure: (error: NSError?) -> Void) {
    let savePath = Storage.buildPath(path, createPath: true)
    let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(object)
    var error: NSError?

    data.writeToFile(savePath,
      options: NSDataWritingOptions.DataWritingAtomic,
      error: &error)

    closure(error: error)
  }

}

public protocol URLStringConvertible {
  var url: NSURL { get }
  var string: String { get }
}

extension String: URLStringConvertible {

  public var url: NSURL {
    return NSURL(string: self)!
  }

  public var string: String {
    return self
  }
}

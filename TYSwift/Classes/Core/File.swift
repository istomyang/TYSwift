//
//  File.swift
//  TYSwift
//
//  Created by 杨洋 on 22/6/2022.
//

import Foundation

public enum TSFileStatus {
  case Exist
  case Success(Data?)
  case Fail(Error)
}

public typealias TSFileResultCB = (TSFileStatus) -> Void

public let TSSearchPathForDirectoriesError = 0 << 1

public class TSFile {
  
  // MARK: - 目录
  
  /// - In iOS, the home directory is the application’s sandbox directory.
  /// - In macOS, it’s the application’s sandbox directory, or the current user’s home directory if the application isn’t in a sandbox.
  public static var homeDirectory: String {
    NSHomeDirectory()
  }
  
  /// 可以进行备份和恢复，体积大，用于存放用户数据，支持用户共享。
  public static var documentDirectory: String? {
    NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
  }
  
  /// 开发者常用文件夹，可以自定义子文件夹。
  ///
  /// 包含目录：
  /// - Preferences 目录：包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
  /// - Caches 目录：用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
  /// - 可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份。
  public static var libraryDirectory: String? {
    NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
  }
  
  /// Caches 目录：用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
  public static var cachesDirectory: String? {
    NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
  }
  
  /// 临时文件不会被备份，启动时可能会被清除
  public static var tmpDirectory: String {
    NSTemporaryDirectory()
  }
  
  // MARK: - 多线程
  
  private static var queue: DispatchQueue {
    DispatchQueue.init(label: "TSFileQueue", qos: .default)
  }
  
  private static var concurrentQueue: DispatchQueue {
    DispatchQueue.init(label: "TSFileConcurrentQueue", qos: .default, attributes: [.concurrent])
  }
  
  private static func runInMain(_ cb: @escaping () -> Void) {
    DispatchQueue.main.async {
      cb()
    }
  }
  
  private static func runQueue(runner: @escaping () -> Void) {
    queue.async {
      runner()
    }
  }
  
  private static func runConcurrentQueue(runner: @escaping () -> Void) {
    concurrentQueue.async {
      runner()
    }
  }
  
  // MARK: - 基本方法
  
  public static func checkExist(_ path: String) -> Bool {
    FileManager.default.fileExists(atPath: path)
  }
  
  /// 同步读取文件
  /// - Parameters:
  ///   - name: 文件名称
  ///   - directory: 存放目录
  ///   - data: 数据
  ///   - cb: 结构回掉
  ///   - override: 是否覆盖已经存在的文件
  private static func createFileSync(
    _ name: String,
    atDirectory directory: String,
    withData data: Data,
    cb: @escaping TSFileResultCB,
    override: Bool
  ){
    let m = FileManager.default
    let path = directory + name
    
    do {
      
      // 1. check and create.
      try m.createDirectory(atPath: directory, withIntermediateDirectories: true)
      
      // 2. check file
      if m.fileExists(atPath: path) && override {
        // 3. override file
        try m.removeItem(atPath: path)
      }
      
      // 4. if not override
      if !override {
        runInMain {
          cb(.Exist)
        }
        return
      }
      
      // 5. create
      m.createFile(atPath: path, contents: data)
      runInMain {
        cb(.Success(nil))
      }
      
    } catch {
      runInMain {
        cb(.Fail(error))
      }
    }
  }
  
  /// 创建文件
  ///
  /// 线程不安全，如果concurrent为true，使用场景是大批量处理很多文件，每个线程仅处理唯一的文件。
  /// 如果concurrent为false，不会出现多个线程对同一个文件进行操作。
  ///
  /// - Parameters:
  ///   - name: 文件名称
  ///   - directory: 存放目录
  ///   - data: 数据
  ///   - cb: 结构回掉
  ///   - override: 是否覆盖已经存在的文件
  ///   - concurrent: 默认为true
  public static func createFile(
    _ name: String,
    atDirectory directory: String,
    withData data: Data,
    cb: @escaping TSFileResultCB,
    override: Bool,
    concurrent: Bool = true
  ) {
    if concurrent {
      runConcurrentQueue {
        createFileSync(name, atDirectory: directory, withData: data, cb: cb, override: override)
      }
    } else {
      runQueue {
        createFileSync(name, atDirectory: directory, withData: data, cb: cb, override: override)
      }
    }
  }
  
  /// 同步读取文件
  /// - Parameters:
  ///   - name: 文件名称
  ///   - directory: 文件所在目录
  ///   - cb: 文件操作回掉函数
  private static func getFileSync(
    _ name: String,
    atDirectory directory: String,
    cb: @escaping TSFileResultCB
  ){
    let path = directory + name
    let m = FileManager.default
    
    // 1. check exist
    if !m.fileExists(atPath: path) {
      runInMain {
        cb(.Fail(NSError(domain: "File does not existed.", code: NSFileReadNoSuchFileError)))
      }
      return
    }
    
    // 2. Get
    let data = m.contents(atPath: path)
    runInMain {
      cb(.Success(data))
    }
  }
  
  /// 读取文件
  ///
  /// 线程不安全，读取文件可以通过concurrent选择并行还是串行。
  ///
  /// - Parameters:
  ///   - name: 文件名称
  ///   - directory: 文件所在目录
  ///   - cb: 文件操作回掉函数
  ///   - concurrent: 默认为true
  public static func getFile(
    _ name: String,
    atDirectory directory: String,
    cb: @escaping TSFileResultCB,
    concurrent: Bool = true
  ) {
    if concurrent {
      concurrentQueue.sync {
        getFileSync(name, atDirectory: directory, cb: cb)
      }
    } else {
      queue.async {
        getFileSync(name, atDirectory: directory, cb: cb)
      }
    }
  }
}

// MARK: - 缓存管理
public extension TSFile {
  
  /// ~/Library/Caches/TSCache/
  static var myCacheDirectory: String? {
    guard let dict = cachesDirectory else { return nil }
    return dict + "/TSCache/"
  }
  
  /// 保存文件到缓存区
  ///
  /// 文件名称是否MD5格式。
  ///
  /// - Parameters:
  ///   - name: 文件名
  ///   - group: 文件分组
  ///   - data: 文件数据
  ///   - cb: 文件操作回掉函数
  ///   - override: 是否覆盖文件
  ///   - concurrent: 默认为true
  static func createCacheFile(
    _ name: String,
    byGroup group: String,
    withData data: Data,
    cb: @escaping TSFileResultCB,
    override: Bool,
    concurrent: Bool = true
  ) {
    let fileName = name.md5
    guard let rootDir = myCacheDirectory else {
      cb(.Fail(NSError(domain: "TSFile.cachesDirectory is Nil.", code: TSSearchPathForDirectoriesError)))
      return
    }
    let dir = rootDir + group + "/"
    
    createFile(fileName, atDirectory: dir, withData: data, cb: cb, override: override, concurrent: concurrent)
  }
  
  /// 缓存互联网图片资源
  /// - Parameters:
  ///   - url: 图片URL
  ///   - data: 图片数据，UIImagePNGRepresentation
  ///   - cb: 文件操作回掉函数
  ///   - override: 是否覆盖文件，默认复写
  ///   - group: Image存放分组，默认："Image"
  ///   - concurrent: 默认为true
  static func cacheImage(
    url: String,
    data: Data,
    cb: @escaping TSFileResultCB,
    override: Bool = true,
    group: String = "Image",
    concurrent: Bool = true
  ) {
    createCacheFile(url.md5, byGroup: group, withData: data, cb: cb, override: override, concurrent: concurrent)
  }
  
  /// 取缓存的图片
  ///
  /// 线程不安全，保证读取缓存的时候，对同一个文件不会有写操作。
  /// 一般来说，缓存的使用场景，从网络加载，然后缓存，等下次启动的时候，先读取缓存。
  /// 整个过程是串行的。
  ///
  /// - Parameters:
  ///   - url: 文件名
  ///   - cb: 文件操作回掉函数
  ///   - group: Image存放分组，默认："Image"
  ///   - concurrent: 默认为true
  static func getImage(_ url: String, cb: @escaping TSFileResultCB, group: String = "Image", concurrent: Bool = true) {
    
    guard let rootDir = myCacheDirectory else {
      runInMain {
        cb(.Fail(NSError(domain: "TSFile.cachesDirectory is Nil.", code: TSSearchPathForDirectoriesError)))
      }
      return
    }
    let dir = rootDir + group + "/"
    
    getFile(url.md5, atDirectory: dir, cb: cb, concurrent: concurrent)
  }
}

//
//  Info.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation
import KeychainAccess

public class TSInfo {
  
  // MARK: - 媒体查询
  
  public static let w = UIScreen.main.bounds.width
  public static let h = UIScreen.main.bounds.height
  public static let bounds = UIScreen.main.bounds
  
  ///  安全区边距
  public static var layoutInset: UIEdgeInsets? {
    if #available(iOS 11.0, *) {
      guard let safeArea = UIApplication.shared.keyWindow?.safeAreaInsets else {
        return nil
      }
      if safeArea.bottom > 0 {
        // in iPhone 11; UIEdgeInsets(top: 248, left: 0, bottom: 34, right: 0)
        return safeArea
      }
      return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
  
  
  /// 是否是异形屏幕？
  public static var isX: Bool? {
    guard let l = layoutInset else {
      return nil
    }
    if #available(iOS 11.0, *) {
      return l.bottom > 0
    }
    return false
  }
  
  /// 导航栏高度
  public static var navBarH: CGFloat {
    44.0
  }
  
  // TabBar高度
  public static var tabBarH: CGFloat {
    49.0
  }
  
  // TabBar高度（包含底部安全区）
  public static var tabStatusBarH: CGFloat? {
    guard let l = layoutInset else {
      return nil
    }
    return l.bottom + tabBarH
  }
  
  // 导航栏高度（包含顶部安全区）
  public static var navStatusBarH: CGFloat? {
    guard let l = layoutInset else {
      return nil
    }
    return l.top + navBarH
  }
  
  // 状态栏高度
  public static var statusBarH: CGFloat? {
    guard let l = layoutInset else {
      return nil
    }
    return l.top
  }
  
  // MARK: - 设备和App信息
  
  /// App名称，TYSwift_Example
  public static var appName: String? {
    // http://stackoverflow.com/questions/28254377/get-app-name-in-swift
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
  }
  
  /// 比如： org.cocoapods.demo.TYSwift-Example
  public static var bundleID: String? {
    return Bundle.main.bundleIdentifier
  }
  
  /// Build构建版本，比如 1
  public static var buildCode: String? {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
  }
  
  /// App版本，比如 1.0
  public static var version: String {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }
  
  /// 设备名称，比如 iPhone
  public static var deviceName: String {
    return UIDevice.current.localizedModel
  }
  
  /// 设备方向
  public static var deviceOrientation: UIDeviceOrientation {
    return UIDevice.current.orientation
  }
  
  /// 系统版本，比如 15.5
  public static var systemVersion: String {
    return UIDevice.current.systemVersion
  }
  
  /// 设备标识，比如：iPhone13,4
  public static var deviceIdentifier: String {
#if targetEnvironment(simulator)
    let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
#else
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
#endif
    return identifier
  }
  
  /// 设备名称，比如：iPhone 13 Pro
  /// https://gist.github.com/adamawolf/3048717
  public static var device: String? {
    let l = [
      "iPhone7,1" : "iPhone 6 Plus",
      "iPhone7,2" : "iPhone 6",
      "iPhone8,1" : "iPhone 6s",
      "iPhone8,2" : "iPhone 6s Plus",
      "iPhone8,4" : "iPhone SE (GSM)",
      "iPhone9,1" : "iPhone 7",
      "iPhone9,2" : "iPhone 7 Plus",
      "iPhone9,3" : "iPhone 7",
      "iPhone9,4" : "iPhone 7 Plus",
      "iPhone10,1" : "iPhone 8",
      "iPhone10,2" : "iPhone 8 Plus",
      "iPhone10,3" : "iPhone X Global",
      "iPhone10,4" : "iPhone 8",
      "iPhone10,5" : "iPhone 8 Plus",
      "iPhone10,6" : "iPhone X GSM",
      "iPhone11,2" : "iPhone XS",
      "iPhone11,4" : "iPhone XS Max",
      "iPhone11,6" : "iPhone XS Max Global",
      "iPhone11,8" : "iPhone XR",
      "iPhone12,1" : "iPhone 11",
      "iPhone12,3" : "iPhone 11 Pro",
      "iPhone12,5" : "iPhone 11 Pro Max",
      "iPhone12,8" : "iPhone SE 2nd Gen",
      "iPhone13,1" : "iPhone 12 Mini",
      "iPhone13,2" : "iPhone 12",
      "iPhone13,3" : "iPhone 12 Pro",
      "iPhone13,4" : "iPhone 12 Pro Max",
      "iPhone14,2" : "iPhone 13 Pro",
      "iPhone14,3" : "iPhone 13 Pro Max",
      "iPhone14,4" : "iPhone 13 Mini",
      "iPhone14,5" : "iPhone 13",
      "iPhone14,6" : "iPhone SE 3rd Gen",
    ]
    return l[deviceIdentifier]
  }
  
  /// 设备ID，苹果已经禁止获取设备UUID，所以只能生成一个ID存储在本地。
  public static func deviceId(bundleID: String) -> String {
    let keychain = Keychain(service: bundleID)
    if let deviceID = try? keychain.get("UUID") {
      return deviceID!
    } else {
      let uuid = UUID().uuidString
      try? keychain.set(uuid, key: "UUID")
      return uuid
    }
  }
  
  /// 设备时区
  public static var timeZone: Int {
    let localZone = NSTimeZone.local
    guard let abbreviation = localZone.abbreviation() else {
      return 0
    }
    let expression = try? NSRegularExpression(pattern: "[a-zA-Z]", options: [])
    return Int(expression?.stringByReplacingMatches(in: abbreviation, options: [], range: NSMakeRange(0, abbreviation.count), withTemplate: "") ?? "0") ?? 0
  }
  
  /// 返回距离GMT的小时数，比如本地时间
  public static var hoursOffsetGMT: Int {
    let timeZoneOffset = TimeZone.current.secondsFromGMT(for: Date())
    return timeZoneOffset / 3600
  }
}

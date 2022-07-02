//
//  TYSwift.swift
//  FBSnapshotTestCase
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation

public typealias TS = TYSwift
public class TYSwift: NSObject {
  
  public static var mainWindow: UIWindow? {
    guard var win = UIApplication.shared.keyWindow else {
      return nil
    }
    if win.windowLevel != UIWindowLevelNormal {
      win = UIApplication.shared.windows.first { $0.windowLevel == UIWindowLevelNormal }!
    }
    return win
  }
  
  
  /// 监听用户截屏的行为
  public static func ObsUserTakeScreenShot(_ action: @escaping (_ notification: Notification) -> Void) {
    // http://stackoverflow.com/questions/13484516/ios-detection-of-screenshot
    _ = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot,
                                               object: nil,
                                               queue: OperationQueue.main) { notification in
      action(notification)
    }
  }
  
  /// 绘制View
  /// - Parameters:
  ///   - view: 某View
  ///   - opaque: 默认false，不透明，为true性能高一点
  ///   - afterScreenUpdates: 默认true，是否等当前更新完再绘制
  /// - Returns: 返回的UIImage
  public static func shotView(view: UIView, opaque: Bool = false, afterScreenUpdates: Bool = true) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: afterScreenUpdates)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndPDFContext()
    return image
  }
  
  /// 全屏截图
  /// - Parameters:
  ///   - opaque: 默认false，不透明，为true性能高一点
  ///   - afterScreenUpdates: 默认true，是否等当前更新完再绘制
  /// - Returns: 返回的UIImage
  public static func shotFullScreen(opaque: Bool = false, afterScreenUpdates: Bool = true) -> UIImage? {
    guard let root = mainWindow else {
      return nil
    }
    return shotView(view: root, opaque: opaque, afterScreenUpdates: afterScreenUpdates)
  }
}

//
//  Drawing.swift
//  TYSwift
//
//  Created by 杨洋 on 22/6/2022.
//

import Foundation

public class TSDrawing {
  
  /// 创建UIImage
  /// - Parameters:
  ///   - block: 绘制块
  ///   - size: 尺寸
  public static func image(withBlock block: (CGRect) -> Void, size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContext(size)
    block(CGRect(origin: CGPoint.zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  
  /// 开启一个新的绘制状态
  /// - Parameter block: 绘制块
  public static func pushNewState(withBlock block: ()->Void) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.saveGState()
    block()
    context.restoreGState()
  }
  
  
}

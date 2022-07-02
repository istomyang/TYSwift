//
//  UIImage+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import UIKit

public extension UIImage {
  
  var pngData: Data? {
    UIImagePNGRepresentation(self)
  }
  
  func makeThumbnail(_ size: CGSize, useFit: Bool = true) -> UIImage? {
    let imgRect = CGRect(origin: CGPoint.zero, size: self.size)
    let targetRect = CGRect(origin: CGPoint.zero, size: size)
    let rect = useFit ? TSGeometry.centerScaleFit(source: imgRect, target: targetRect) : TSGeometry.centerScaleFill(source: imgRect, target: targetRect)
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    self.draw(in: rect)
    let thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext()
    
    return thumbnail
  }
  
  /// 设置图片圆角
  ///
  /// 此为屏幕内渲染，使用CPU绘图。
  ///
  /// - Parameters:
  ///   - radius: 圆角
  ///   - size: View的尺寸
  /// - Returns: 裁剪好的UiImage
  func applyCornerRadius(radius: CGFloat, size: CGSize) -> UIImage? {
    let rect = CGRect(origin: .zero, size: size)
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    
    let context = UIGraphicsGetCurrentContext()
    context?.addPath(UIBezierPath.init(roundedRect: rect, cornerRadius: radius).cgPath)
    context?.clip()
    self.draw(in: rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    return image
  }
  
}

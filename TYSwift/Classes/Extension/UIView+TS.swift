//
//  UIView+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import UIKit

public extension UIView {
  
  /// View 所归属的VC，利用 UIResponder 原理。
  var hostVC: UIViewController? {
    for view in sequence(first: self.superview, next: {$0?.superview}) {
      if let responder = view?.next {
        if responder.isKind(of: UIViewController.self) {
          return responder as? UIViewController
        }
      }
    }
    return nil
  }
}

// MARK: - 尺寸和位置操作
public extension UIView {

  var ts_x: CGFloat {
    set {
      frame.origin.x = newValue
    }
    get {
      return frame.origin.x
    }
  }
  
  var ts_y: CGFloat {
    set {
      frame.origin.y = newValue
    }
    get {
      return frame.origin.y
    }
  }
  
  var ts_w: CGFloat {
    set {
      frame.size.width = newValue
    }
    get {
      return frame.size.width
    }
  }
  
  var ts_h: CGFloat {
    set {
      frame.size.height = newValue
    }
    get {
      return frame.size.height
    }
  }
  
  var ts_centerX: CGFloat {
    set {
      frame.origin.x = newValue - frame.width / 2
    }
    get {
      return frame.maxX - frame.width / 2
    }
  }
  
  var ts_centerY: CGFloat {
    set {
      frame.origin.y = newValue - frame.height / 2
    }
    get {
      return frame.maxY - frame.height / 2
    }
  }
  
  var ts_maxX: CGFloat {
    set {
      frame.origin.x = newValue - frame.width
    }
    get {
      return frame.maxX
    }
  }
  
  var ts_maxY: CGFloat {
    set {
      frame.origin.y = newValue - frame.height
    }
    get {
      return frame.maxY
    }
  }
}

// MARK: - 圆角
public extension UIView {
  
  /// 设置圆角，在 draw(_:) 里
  ///
  /// 注意：必须在布局之后，依赖布局尺寸
  func ts_cornerRadius_cg(radius: CGFloat) {
    TSDrawing.pushNewState {
      let context = UIGraphicsGetCurrentContext()
      context?.addPath(UIBezierPath.init(roundedRect: self.bounds, cornerRadius: radius).cgPath)
      context?.clip()
    }
  }
  
  /// 设置圆角：Layer法
  func ts_cornerRadius(radius: CGFloat) {
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = true
  }
  
  /// 创建四角不同圆角的CGPath
  ///
  /// 注意：必须在布局之后，依赖布局尺寸
  ///
  /// 可以用于离屏渲染，也可用于屏幕内渲染。
  private func ts_DiffCornersRadiusCGPath(
    topLeft: CGFloat,
    topRight: CGFloat,
    bottomLeft: CGFloat,
    bottomRight: CGFloat
  ) -> CGPath {
    let minX = CGFloat.zero
    let minY = CGFloat.zero
    let maxX = self.frame.width
    let maxY = self.frame.height
    
    let topLeftCenterX = minX + topLeft
    let topLeftCenterY = minY + topLeft
    let topLeftPoint = CGPoint(x: topLeftCenterX, y: topLeftCenterY)
    let p0 = CGPoint(x: minX, y: topLeftCenterY)
    
    let topRightCenterX = maxX - topRight
    let topRightCenterY = minY + topRight
    let topRightPoint = CGPoint(x: topRightCenterX, y: topRightCenterY)
    let p1 = CGPoint(x: topRightCenterX, y: minY)
    
    let bottomRightCenterX = maxX - bottomRight
    let bottomRightCenterY = maxY - bottomRight
    let bottomRightPoint = CGPoint(x: bottomRightCenterX, y: bottomRightCenterY)
    let p2 = CGPoint(x: maxX, y: bottomRightCenterY)
    
    let bottomLeftCenterX = minX + bottomLeft
    let bottomLeftCenterY = maxY - bottomLeft
    let bottomLeftPoint = CGPoint(x: bottomLeftCenterX, y: bottomLeftCenterY)
    let p3 = CGPoint(x: bottomLeftCenterX, y: maxY)
    
    let path = UIBezierPath()
    let pi = CGFloat.pi
    
    path.move(to: p0)
    path.addArc(withCenter: topLeftPoint, radius: topLeft, startAngle: pi, endAngle: pi * 3 / 2, clockwise: true)
    path.addLine(to: p1)
    path.addArc(withCenter: topRightPoint, radius: topRight, startAngle: pi * 3 / 2, endAngle: 0, clockwise: true)
    path.addLine(to: p2)
    path.addArc(withCenter: bottomRightPoint, radius: bottomRight, startAngle: 0, endAngle: pi / 2, clockwise: true)
    path.addLine(to: p3)
    path.addArc(withCenter: bottomLeftPoint, radius: bottomLeft, startAngle: pi / 2, endAngle: pi, clockwise: true)
    path.addLine(to: p0)
    
    return path.cgPath
  }
  
  /// 设置圆角：不同角
  ///
  /// - 注意：必须在布局之后，依赖布局尺寸
  /// - 离屏渲染
  func ts_setCorners(
  topLeft: CGFloat = 0,
  topRight: CGFloat = 0,
  bottomLeft: CGFloat = 0,
  bottomRight: CGFloat = 0
  ) {
    let cgPath = ts_DiffCornersRadiusCGPath(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = cgPath
    self.layer.mask = shapeLayer
  }
}

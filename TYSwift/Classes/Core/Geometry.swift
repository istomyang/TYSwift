//
//  Geometry.swift
//  TYSwift
//
//  Created by 杨洋 on 22/6/2022.
//

import Foundation

public class TSGeometry {
  
  // MARK: - Conversion 转换
  
  /// 角度 -> 弧度
  static func degreesFromRadians(radians: CGFloat) -> CGFloat {
    radians * 180.0 / Double.pi
  }
  
  /// 弧度 -> 角度
  static func radiansFromDegrees(degrees: CGFloat) -> CGFloat {
    degrees * Double.pi / 180.0
  }
  
  // MARK: - Clamp 夹逼
  
  /// 一维数值夹逼
  static func clamp(_ a: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    fmin(fmax(min, a), max);
  }
  
  /// 二维点位夹逼
  static func clampRect(_ pt: CGPoint, rect: CGRect) -> CGPoint {
    CGPoint(x: clamp(pt.x, min: rect.minX, max: rect.maxX), y: clamp(pt.y, min: rect.minY, max: rect.maxY))
  }
  
  // MARK: - 一般几何学
  
  /// Rect中心点
  static func centerPoint(rect: CGRect) -> CGPoint {
    CGPoint(x: rect.midX, y: rect.minY)
  }
  
  /// 两点之间的距离
  static func distanceDoublePoint(p1: CGPoint, p2: CGPoint) -> CGFloat {
    let dx = p2.x - p1.x
    let dy = p2.y - p1.y
    return (dx * dx + dy * dy).squareRoot()
  }
  
  /// 按百分比移动CGRect原点并返回
  /// - Parameters:
  ///   - rect: CGRect
  ///   - xp: x轴百分比
  ///   - yp: y轴百分比
  static func pointAwayByPercent(_ rect: CGRect, xp: CGFloat, yp: CGFloat) -> CGPoint {
    let dx = xp * rect.width
    let dy = yp * rect.height
    return CGPoint(x: rect.origin.x + dx, y: rect.origin.y + dy)
  }
  
  // MARK: - 构造CGRect
  
  static func makeRectCenterPoint(center: CGPoint, size: CGSize) -> CGRect {
    let hw = size.width / 2.0
    let hh = size.height / 2.0
    return CGRect(x: center.x - hw, y: center.y - hh, width: size.width, height: size.height)
  }
  
  
  // MARK: - Aspect and Fitting
  
  /// 按比例因子缩放Size
  static func scaleSizeByfactor(size: CGSize, factor: CGFloat) -> CGSize {
    CGSize(width: size.width * factor, height: size.height * factor)
  }
  
  /// 计算得到两个Rect的缩放因子
  static func scaleFactorOf2Rect(source: CGRect, target: CGRect) -> CGSize {
    let sSize = source.size
    let tSize = target.size
    let scaleW = tSize.width / sSize.width
    let scaleH = tSize.height / sSize.height
    return CGSize(width: scaleW, height: scaleH)
  }
  
  /// 比例因子，填满窗口，牺牲全貌，Fill
  static func scaleFactorFill(source: CGRect, target: CGRect) -> CGFloat {
    let f2 = scaleFactorOf2Rect(source: source, target: target)
    return fmax(f2.width, f2.height)
  }
  
  /// 比例因子，填满全貌，会有留白，Fit
  static func scaleFactorFit(source: CGRect, target: CGRect) -> CGFloat {
    let f2 = scaleFactorOf2Rect(source: source, target: target)
    return fmin(f2.width, f2.height)
  }
  
  /// 中心缩放，最大展现全貌，Fit
  /// - Parameters:
  ///   - source: 物品
  ///   - target: 窗口
  /// - Returns: 物品新的坐标系
  static func centerScaleFit(source: CGRect, target: CGRect) -> CGRect {
    let fit = scaleFactorFit(source: source, target: target)
    let targetSize = scaleSizeByfactor(size: source.size, factor: fit)
    let cP = CGPoint(x: target.midX, y: target.midY)
    return makeRectCenterPoint(center: cP, size: targetSize)
  }
  
  /// 中心缩放，填充窗口，Fill
  /// - Parameters:
  ///   - source: 物品
  ///   - target: 窗口
  /// - Returns: 物品新的坐标系
  static func centerScaleFill(source: CGRect, target: CGRect) -> CGRect {
    let fit = scaleFactorFill(source: source, target: target)
    let targetSize = scaleSizeByfactor(size: source.size, factor: fit)
    let cP = CGPoint(x: target.midX, y: target.midY)
    return makeRectCenterPoint(center: cP, size: targetSize)
  }
}



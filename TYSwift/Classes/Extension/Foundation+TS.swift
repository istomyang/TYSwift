//
//  Foundation+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation

// MARK: - Optional
public extension Optional {
  var isNil: Bool {
    guard case Optional.none = self else {
      return false
    }
    return true
  }
  
  var isNotNil: Bool {
    return !self.isNil
  }
}

// MARK: - NSAttributedString
public extension NSAttributedString {
  
  /// 粗体
  var bolded: NSAttributedString {
    guard !string.isEmpty else { return self }
    
    let pointSize: CGFloat
    if let font = attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
      pointSize = font.pointSize
    } else {
      pointSize = UIFont.systemFontSize
    }
    return applying(attributes: [.font: UIFont.boldSystemFont(ofSize: pointSize)])
  }
  
  /// 下划线
  var underlined: NSAttributedString {
    return applying(attributes: [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
  }
  
  /// 斜体
  var italicized: NSAttributedString {
    guard !string.isEmpty else { return self }
    
    let pointSize: CGFloat
    if let font = attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
      pointSize = font.pointSize
    } else {
      pointSize = UIFont.systemFontSize
    }
    return applying(attributes: [.font: UIFont.italicSystemFont(ofSize: pointSize)])
  }
  
  /// 删除线
  var struckthrough: NSAttributedString {
    return applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue)])
  }
  
  /// 富文本
  var attributes: [Key: Any] {
    guard length > 0 else { return [:] }
    return attributes(at: 0, effectiveRange: nil)
  }
  
}

// MARK: - Methods

public extension NSAttributedString {
  /// 字体
  func font(_ font:UIFont) -> NSAttributedString {
    return applying(attributes: [.font: font])
  }
  /// 字体颜色
  func colored(with color: UIColor) -> NSAttributedString {
    return applying(attributes: [.foregroundColor: color])
  }
  
  /// 行间距
  func lineSpaceing(_ lineSpaceing: CGFloat) -> NSAttributedString {
    let style = NSMutableParagraphStyle()
    style.lineSpacing = lineSpaceing
    return applying(attributes: [.paragraphStyle: wordSpaceing])
  }
  
  /// 字间距
  func wordSpaceing(_ wordSpaceing: CGFloat) -> NSAttributedString {
    return applying(attributes: [.kern: wordSpaceing])
  }
  /// 添加富文本属性
  func applying(attributes: [Key: Any]) -> NSAttributedString {
    guard !string.isEmpty else { return self }
    
    let copy = NSMutableAttributedString(attributedString: self)
    copy.addAttributes(attributes, range: NSRange(0..<length))
    return copy
  }
}

// MARK: - Operators

public extension NSAttributedString {
  /// 加等
  ///
  /// - Parameters:
  ///   - lhs: NSAttributedString to add to.
  ///   - rhs: NSAttributedString to add.
  static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
    let string = NSMutableAttributedString(attributedString: lhs)
    string.append(rhs)
    lhs = string
  }
  
  /// 拼接.
  ///
  /// - Parameters:
  ///   - lhs: NSAttributedString to add.
  ///   - rhs: NSAttributedString to add.
  /// - Returns: New instance with added NSAttributedString.
  static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let string = NSMutableAttributedString(attributedString: lhs)
    string.append(rhs)
    return NSAttributedString(attributedString: string)
  }
}


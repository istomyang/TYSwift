//
//  Adapter.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation

// MARK: - 屏幕宽度适配
extension Int {
  var rpx: CGFloat {
    return CGFloat(self).rpx
  }
  
  /// 注意，仅限制于视网膜屏，因为pt是逻辑像素，等于1/72英寸，而在视网膜屏幕上，1pt = 2px。
  var rpt: CGFloat {
    return CGFloat(self).rpt
  }
}

extension CGFloat {
  var rpx: CGFloat {
    return (UIScreen.main.bounds.width / 750) * self
  }
  
  /// 注意，仅限制于视网膜屏，因为pt是逻辑像素，等于1/72英寸，而在视网膜屏幕上，1pt = 2px。
  var rpt: CGFloat {
    return (UIScreen.main.bounds.width / 375) * self
  }
}

// MARK: - 资源国际化适配
public extension String {
  
  /// 文字国际化适配
  var intl: String {
    // @params comment: used by genStrings utils if you use.
    NSLocalizedString(self, comment: "")
  }
  
  /// 资源国际化适配。
  ///
  /// - 必须在翻译字符串中加入 lang="zh"，
  /// - 然后所有资源Assets的命名规范取决于加入的 lang 值，比如 _zh, _en, _de。
  var intlA: String {
    self + "_" + "lang".intl
  }
  
  /// 带有参数处理的文本国际化。
  ///
  /// - 例子："%@ Days Free".intl(["3"]) --> "3 Days Free"
  /// - Parameter args: 数量最好要对称，原生是用null替换，但是我做一些处理，用""替换，但不要差距过大，否则还是用null替换
  private func intl(_ args: [String]) -> String {
    let ags = args + Array.init(repeating: "", count: 10)
    return String(format: self.intl, arguments: ags)
  }
  
  /// 带有参数处理的文本国际化。
  /// - Parameter strings: 传递的参数。
  /// - 例子："%@ Days Free, %@".intl("3", "Tom") --> "3 Days Free, Tom"
  func intl(_ strings: String...) -> String {
    self.intl(strings)
  }
  
  /// 带有数字参数处理的文本国际化。
  func intl(_ ints: Int...) -> String {
    self.intl(ints.map { String($0) })
  }
}

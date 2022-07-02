//
//  NSObject+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation

public extension NSObject {
  /// 类名称，类属性
  class var ts_name: String {
    let array = NSStringFromClass(self).components(separatedBy: ".")
    return array.last ?? ""
  }
  
  /// 对象名称，实例属性
  var ts_name: String {
    let array = NSStringFromClass(type(of: self)).components(separatedBy: ".")
    return array.last ?? ""
  }
}

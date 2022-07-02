//
//  Data+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation

public extension Data {
  
  /// 字符串化
  /// - Parameter encoding: 编码格式
  func toString(encoding: String.Encoding) -> String? {
    return String(data: self, encoding: encoding)
  }
  
  /// 二进制化
  func toBytes() -> [UInt8] {
    return [UInt8](self)
  }
  
  /// 字典化
  func toDict() -> Dictionary<String, Any>? {
    return (try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed)) as? [String: Any]
  }
  
  /// 从给定的JSON数据返回一个基础对象。
  func toObject(options: JSONSerialization.ReadingOptions = []) -> Any? {
    return try? JSONSerialization.jsonObject(with: self, options: options)
  }
  
  /// 指定Model类型解析JSON
  func toModel<T: Decodable>(_ type: T.Type) -> T? {
    return try? JSONDecoder().decode(type, from: self)
  }
}

//
//  Dict+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation

public extension Dictionary {
  
  /// key是否存在在字典中
  func has(key: Key) -> Bool {
    self.index(forKey: key).isNotNil
  }
  
  /// 移除key对应的value
  /// - Parameter keys: 比如：[key1, key2, key3]
  mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
    keys.forEach { removeValue(forKey: $0) }
  }
  
  /// 字典转Data
  /// - Parameter prettify: 是否格式化
  func toData(prettify: Bool = false) -> Data? {
    guard JSONSerialization.isValidJSONObject(self) else {
      return nil
    }
    let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
    return try? JSONSerialization.data(withJSONObject: self, options: options)
  }
  
  /// 字典转json
  /// - Parameter prettify: 是否格式化
  func toJson(prettify: Bool = false) -> String? {
    guard JSONSerialization.isValidJSONObject(self) else { return nil }
    let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
    guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
    return String(data: jsonData, encoding: .utf8)
  }
  
  
  /// 字典转Model
  /// - Parameter type: 类型，比如 BookMo
  func toModel<T>(_ type: T.Type) -> T? where T: Decodable {
    return self.toData()?.toModel(T.self)
  }
}

//
//  Defaults.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation

///  UserDefaults 属性包装器
@propertyWrapper public struct TSDefaults<T> {
  public let key: String
  public let defaultValue: T
  
  public init(_ key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  public var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}

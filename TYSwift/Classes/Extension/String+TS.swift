//
//  String+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation
import CommonCrypto

public extension String {
  
  init?(base64: String) {
    guard let decodedData = Data(base64Encoded: base64) else { return nil }
    guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
    self.init(str)
  }
  
  func toModel<T: Decodable>(_ type: T.Type) -> T? {
    return self.data(using: .utf8)?.toModel(type)
  }
  
  var md5: String {
    let cStr = self.cString(using: String.Encoding.utf8)
    let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    
    let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    CC_MD5(cStr!, strLen, result)
    let hash = NSMutableString()
    for i in 0 ..< digestLen {
      hash.appendFormat("%02x", result[i])
    }
    result.deallocate()
    return String(format: hash as String)
  }
  
  var base64Encoded: String? {
    let plainData = data(using: .utf8)
    return plainData?.base64EncodedString()
  }
  
  var base64Decoded: String? {
    let remainder = count % 4
    
    var padding = ""
    if remainder > 0 {
      padding = String(repeating: "=", count: 4 - remainder)
    }
    
    guard let data = Data(base64Encoded: self + padding,
                          options: .ignoreUnknownCharacters) else { return nil }
    
    return String(data: data, encoding: .utf8)
  }
  
  /// 是否包含emoji
  var containEmoji: Bool {
    for scalar in self.unicodeScalars {
      return String.checkContainEmoji(scalar)
    }
    return false
  }
  
  /// 检查Unicode字符是否处于Emoji范围
  /// - Parameter scalar: Unicode字符
  static func checkContainEmoji(_ scalar: Unicode.Scalar) -> Bool {
    switch Int(scalar.value) {
    case 0x1F600...0x1F64F: return true     // Emoticons
    case 0x1F300...0x1F5FF: return true  // Misc Symbols and Pictographs
    case 0x1F680...0x1F6FF: return true  // Transport and Map
    case 0x1F1E6...0x1F1FF: return true  // Regional country flags
    case 0x2600...0x26FF: return true    // Misc symbols
    case 0x2700...0x27BF: return true    // Dingbats
    case 0xE0020...0xE007F: return true  // Tags
    case 0xFE00...0xFE0F: return true    // Variation Selectors
    case 0x1F900...0x1F9FF: return true  // Supplemental Symbols and Pictographs
    case 127000...127600: return true    // Various asian characters
    case 65024...65039: return true      // Variation selector
    case 9100...9300: return true        // Misc items
    case 8400...8447: return true        //
    default: return false
    }
  }
  
  /// 移除表情
  func removeEmoji() -> String {
    var scalars = self.unicodeScalars
    scalars.removeAll(where: String.checkContainEmoji(_:))
    return String(scalars)
  }
  
  /// 计算字符个数（英文 = 1，数字 = 1，汉语 = 2）
  func countOfChars() -> Int {
    var count = 0
    guard self.count > 0 else { return 0}
    
    for i in 0...self.count - 1 {
      let c: unichar = (self as NSString).character(at: i)
      if (c >= 0x4E00) {
        count += 2
      }else {
        count += 1
      }
    }
    return count
  }
  
  /// 根据字符个数返回从指定位置向后截取的字符串（英文 = 1，数字 = 1，汉语 = 2）
  func clipByChars(from index: Int) -> String {
    if self.count == 0 {
      return ""
    }
    
    var number = 0
    var strings: [String] = []
    for c in self {
      let subStr: String = "\(c)"
      let num = subStr.countOfChars()
      number += num
      if number <= index {
        strings.append(subStr)
      } else {
        break
      }
    }
    var resultStr: String = ""
    for str in strings {
      resultStr = resultStr + "\(str)"
    }
    return resultStr
  }
}

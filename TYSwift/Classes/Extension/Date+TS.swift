//
//  Date+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import Foundation

public extension Date {
  
  /// 格式化输出
  /// - Parameters:
  ///   - dateFormat: 比如："yyyy-MM-dd"
  ///   - locale: 比如：Locale.init(identifier: "zh_CN")
  /// - Returns: 格式化输出的字符串
  func toFormatString(dateFormat:String = "yyyy-MM-dd", locale: Locale = Locale.current) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.string(from: self)
    return date
  }
  
  /// 当前一个月多少天
  var daysInCurrentMonth: Int {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
    let date = calendar.date(from: dateComponents)!
    let range = calendar.range(of: .day, in: .month, for: date)!
    let numDays = range.count
    return numDays
  }
  
  /// 当前月的日期集合
  var datesInMonth: [Date] {
    var rs:[Date] = []
    let numDays = daysInCurrentMonth
    let year = Calendar.current.component(.year, from: self)
    let month = Calendar.current.component(.month, from: self)
    for item in 1...numDays {
      let newdate = Calendar.current.date(from: DateComponents(year: year, month: month, day: item))
      rs.append(newdate!)
    }
    return rs
  }
  
  var day: Int {
    return NSCalendar.current.component(.day, from: self)
  }
  
  var month: Int {
    return NSCalendar.current.component(.month, from: self)
  }
  
  var year: Int {
    return NSCalendar.current.component(.year, from: self)
  }
  
  
  /// 按周为单位增加或者减少日期
  /// - Parameter n: 可为负数。
  mutating func addWeek(n: Int) {
    self =  Calendar.current.date(byAdding: .day, value: n * 7, to: self)!
  }
  
  /// 按月为单位增加或者减少日期
  /// - Parameter n: 可为负数。
  mutating func addMonth(n: Int) {
    self = Calendar.current.date(byAdding: .month, value: n, to: self)!
  }
  
  /// 按年为单位增加或者减少日期
  /// - Parameter n: 可为负数。
  mutating func addYear(n: Int) {
    self = Calendar.current.date(byAdding: .year, value: n, to: self)!
  }
  
  /// 按天为单位增加或者减少日期
  /// - Parameter n: 可为负数。
  mutating func addDay(n: Int) {
    self = Calendar.current.date(byAdding: .day, value: n, to: self)!
  }
}

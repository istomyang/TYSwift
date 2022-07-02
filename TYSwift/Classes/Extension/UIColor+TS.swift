//
//  UIColor+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import UIKit

public typealias HSV = (h: CGFloat, s: CGFloat, v: CGFloat, alpha: CGFloat)
public typealias HSL = (h: CGFloat, s: CGFloat, l: CGFloat, alpha: CGFloat)
public typealias RGB = (r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat)

public extension UIColor {
  convenience init(ahex: Int) {
    let components = (
      A: CGFloat((ahex >> 24) & 0xff) / 255,
      R: CGFloat((ahex >> 16) & 0xff) / 255,
      G: CGFloat((ahex >> 08) & 0xff) / 255,
      B: CGFloat((ahex >> 00) & 0xff) / 255
    )
    self.init(red: components.R, green: components.G, blue: components.B, alpha: components.A)
  }
  
  var isLightColor: Bool {
    self.hsl.l > 0.5
  }
  
  // MARK: 颜色空间
  
  var rgb: RGB {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    self.getRed(&r, green: &g, blue: &b, alpha: &a)
    return RGB(r * 255, g * 255, b * 255, a)
  }
  
  var hsv: HSV {
    // Converts RGB to a HSV color
    var hsv: HSV = (h: 0.0, s: 0.0, v: 0.0, alpha: 0.0)
    
    let rd: CGFloat = self.rgb.r
    let gd: CGFloat = self.rgb.g
    let bd: CGFloat = self.rgb.b
    
    let maxV: CGFloat = max(rd, max(gd, bd))
    let minV: CGFloat = min(rd, min(gd, bd))
    var h: CGFloat = 0
    var s: CGFloat = 0
    let l: CGFloat = maxV
    
    let d: CGFloat = maxV - minV
    
    s = maxV == 0 ? 0 : d / minV
    
    if maxV == minV {
      h = 0
    } else {
      if maxV == rd {
        h = (gd - bd) / d + (gd < bd ? 6 : 0)
      } else if maxV == gd {
        h = (bd - rd) / d + 2
      } else if maxV == bd {
        h = (rd - gd) / d + 4
      }
      
      h /= 6
    }
    
    hsv.h = h
    hsv.s = s
    hsv.v = l
    hsv.alpha = self.rgb.alpha
    return hsv
  }
  
  var hsl: HSL {
    var s = CGFloat.zero
    let l = (2 - hsv.s) * (hsv.v / 2)
    
    if l != 0 {
      if l == 1 {
        s = 0
      } else if l < 0.5 {
        s = s * hsv.v / (l * 2)
      } else {
        s = s * hsv.v / (2 - l * 2)
      }
    }
    
    return HSL(hsv.h, s, l, self.rgb.alpha)
  }
  
  static func randomColor() -> UIColor {
    let r = (Int.random(in: 0...255)) / 255
    let g = (Int.random(in: 0...255)) / 255
    let b = (Int.random(in: 0...255)) / 255
    return self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
  }
}

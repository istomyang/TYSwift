//
//  UIViewController+TS.swift
//  TYSwift
//
//  Created by 杨洋 on 21/6/2022.
//

import UIKit

public extension UIViewController {
  
  var ts_topVC: UIViewController {
    if let nav = self as? UINavigationController {
      return nav.ts_topVC
    } else if let tabC = self as? UITabBarController {
      return tabC.ts_topVC
    } else if let presentVC = self.presentedViewController {
      return presentVC.ts_topVC
    } else {
      return self
    }
  }
  
  /// 获取UIWindow然后拿到它的根控制器。
  var ts_topVCByUIWindow: UIViewController? {
    TS.mainWindow?.rootViewController?.ts_topVC
  }
}

////
////  TSSheet.swift
////  FBSnapshotTestCase
////
////  Created by 杨洋 on 22/6/2022.
////
//
//import UIKit
//
//private let screenF = TSInfo.bounds
//private let kScreenH = TSInfo.h
//private let kScreenW = TSInfo.w
//
//open class TSSheet: UIView {
//  private let foreground: UIColor
//  private let background: UIColor
//  private let alpha2: CGFloat
//  private var height: CGFloat
//  private var corner: CGFloat
//  private var bgClose: Bool
//  private var panClose: Bool
//
//  public init(
//    foreground: UIColor = .white, // sheet后面的前景色
//    background: UIColor = .clear, // sheet后面的背景色
//    alpha: CGFloat = 0.65, // 背景透明度
//    corner: CGFloat = 30, // 上左右圆角
//    height: CGFloat, // sheet高度，初始化
//    bgClose: Bool = true, // Tap背景，是否触发关闭
//    panClose: Bool = true // 滑移关闭
//  ) {
//    self.foreground = foreground
//    self.background = background
//    self.corner = corner
//    self.height = height
//    self.alpha2 = alpha
//    self.bgClose = bgClose
//    self.panClose = panClose
//    super.init(frame: TSInfo.bounds)
//
//    setUI()
//  }
//
//  public required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  func setUI() {
//    addSubview(backgroundView)
//    addSubview(container)
//
//    if panClose {
//      container.addGestureRecognizer(UIPanGestureRecognizer(
//        target: self,
//        action: #selector(pan(gesture:))))
//    }
//  }
//
//  private lazy var backgroundView: UIView = {
//    let bg = UIView(frame: bounds)
//    bg.backgroundColor = background
//    bg.alpha = 0
//    bg.addGestureRecognizer(UITapGestureRecognizer(
//      target: self,
//      action: #selector(bgAction)))
//    return bg
//  }()
//
//  lazy var container: UIView = {
//    let frm = CGRect(x: 0, y: kScreenH, width: kScreenW, height: height) // 隐藏
//    let view = UIView(frame: frm)
//    view.backgroundColor = foreground
//
//    return view
//  }()
//
//  // 动态变高
//  func setHeight(h: CGFloat, complete: (() -> Void)? = nil) {
//    if h > height { // 先增高
//      container.ts_h = h
//      height = h
//    }
//    UIView.animate(withDuration: 0.25) { [unowned self] in
//      container.ts_y = kScreenH - h
//    } completion: { [unowned self] ok in
//      if h < height { // 后降低
//        container.ts_h = h
//        height = h
//      }
//      if ok {
//        complete?()
//      }
//    }
//  }
//
//  func show(parent: UIView) {
//    parent.addSubview(self)
//    UIView.animate(withDuration: 0.25) { [unowned self] in
//      container.ts_y = kScreenH - height
//      backgroundView.alpha = alpha2
//    }
//  }
//
//  @objc private func bgAction() {
//    if bgClose {
//      dismiss()
//    }
//  }
//
//  @objc func dismiss() {
//    UIView.animate(withDuration: 0.25) { [unowned self] in
//      backgroundView.alpha = 0
//      container.ts_y = kScreenH
//    } completion: { _ in
//      self.removeFromSuperview()
//    }
//  }
//
//  public override func layoutSubviews() {
//    super.layoutSubviews()
//    // 因为container是动态的，随时指定
//    container.ts_setCorners(corners: [.topLeft, .topRight], radius: corner)
//  }
//
//  private var beginY: CGFloat = 0
//  @objc private func pan(gesture: UIPanGestureRecognizer) {
//    switch gesture.state {
//    case .began:
//      beginY = container.ts_y
//    case .changed:
//      let delta = gesture.translation(in: container).y
//
//      let targetY = beginY + delta
//      if targetY <= kScreenH - height {
//        container.ts_y = kScreenH - height
//      } else {
//        container.ts_y = targetY
//      }
//      backgroundView.alpha = 0.65 * (1 - CGFloat(abs(Float(targetY))) / height)
//    case .cancelled, .ended:
//      var targetY: CGFloat = 0
//      if container.ts_y < kScreenH - height / 2 {
//        targetY = kScreenH - height
//      } else {
//        targetY = kScreenH
//      }
//      UIView.animate(withDuration: 0.25) { [unowned self] in
//        container.ts_y = targetY
//        if targetY == kScreenH {
//          backgroundView.alpha = 0
//        } else {
//          backgroundView.alpha = 0.65
//        }
//      } completion: { _ in
//        if targetY == kScreenH {
//          self.removeFromSuperview()
//        }
//      }
//    default:
//      break
//    }
//  }
//}

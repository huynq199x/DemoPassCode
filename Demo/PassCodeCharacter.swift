//
//  PassCodeCharacter.swift
//  Demo
//
//  Created by Nguyen Quang Huy on 22/04/2022.
//

import UIKit

@IBDesignable
class PassCodeCharacter: UIView {
  var view: UIView?
  @IBInspectable
  public var value: Bool = false {
    didSet {
      self.view = UIView(frame: CGRect(x: self.frame.width/100, y: self.frame.height/100, width: 60, height: 60))
      guard let view = view else {
        return
      }
      view.layer.borderWidth = 1
      view.layer.cornerRadius = 30
      view.layer.borderColor = self.tintColor.cgColor
      view.backgroundColor = self.value ? self.tintColor : .clear
      self.addSubview(view)
    }
  }

  override func tintColorDidChange() {
    super.tintColorDidChange()
    guard let view = view else {
      return
    }
    view.layer.borderColor = self.tintColor.cgColor
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}


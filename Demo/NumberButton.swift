//
//  NumberButton.swift
//  Demo
//
//  Created by Nguyen Quang Huy on 14/05/2022.
//

import UIKit

class NumberButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        actions()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        actions()
    }
    
    private func actions() {
        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUp), for: .touchUpInside)
    }
    
    @objc func handleTouchDown() {
        var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) = (1, 1, 1)
        tintColor.getRed(&rgb.red, green: &rgb.green, blue: &rgb.blue, alpha: nil)
        animate(back: .darkGray)
    }
    
    @objc func handleTouchUp() {
        animate(back: .black)
    }
    
    private func animate(back: UIColor?) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.backgroundColor = back
        })
    }
}

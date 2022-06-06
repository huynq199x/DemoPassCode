//
//  NumberButton.swift
//  Demo
//
//  Created by Nguyen Quang Huy on 14/05/2022.
//

import UIKit

class NumberButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .black
        }
    }
}

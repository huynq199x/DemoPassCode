//
//  CheckPassCodeViewController.swift
//  Demo
//
//  Created by Nguyen Quang Huy on 14/05/2022.
//

import UIKit

class CheckPassCodeViewController: UIViewController {
    
    @IBOutlet weak var progressLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var stackViewPassCodeCharacter: UIStackView!
    @IBOutlet weak var statusLabel: UILabel!
    
    private let animationDuration: CGFloat = 0.33
    private var input: String = ""
    private let passcodeLength: Int = 4
    private var passcode: String = ""
    private let passcodeFieldSize: CGFloat = 30
    private let delayAnimation: CGFloat = 0.5
    private var passcodeFieldSpacing: CGFloat! {
        return stackViewPassCodeCharacter.spacing
    }
    
    private let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    func setupUI() {
        for subView in self.stackViewPassCodeCharacter.arrangedSubviews {
            subView.layer.borderWidth = 1
            subView.layer.cornerRadius = passcodeFieldSize/2
            subView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if passcode == "" {
            statusLabel.text = "CREATE YOUR PASSCODE"
        } else {
            statusLabel.text = "ENTER YOUR PASSCODE"
        }
        progressView.layer.cornerRadius = passcodeFieldSize/2
    }
    
    func setupData() {
        if userDefaults.value(forKey: "inputPassCode") != nil {
            passcode = userDefaults.value(forKey: "inputPassCode")  as! String
        } else {
            passcode = ""
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if statusLabel.text == "ENTER YOUR PASSCODE" {
            if input.count < passcodeLength {
                input += String(sender.tag)
                setupWidthConstraint()
            } else if input.count == passcodeLength && input == passcode {
                self.progressWidthConstraint.constant = passcodeFieldSize
            } else {
                input = ""
            }
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                if self.input.count == self.passcodeLength {
                    if self.input == self.passcode {
                        self.progressWidthConstraint.constant = self.passcodeFieldSize
                        self.progressLeadingConstraint.isActive = false
                        self.progressCenterConstraint.isActive = true
              
                        UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimation, options: .curveEaseInOut) {
                            self.view.layoutIfNeeded()
                            self.stackViewPassCodeCharacter.isHidden = true
                            self.progressView.backgroundColor = UIColor.green
                        } completion: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.resetPasscodeField()
                                self.showUnlockView()
                            }
                        }
                    } else {
                        UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimation, options: .curveEaseInOut) {
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.delayAnimation) {
                                self.resetPasscodeField()
                            }
                        }
                    }
                }
            }
        } else if statusLabel.text == "CREATE YOUR PASSCODE" {
            if input.count < passcodeLength {
                input += String(sender.tag)
                setupWidthConstraint()
            } else {
                input = ""
            }

            userDefaults.setValue(input, forKey: "inputTemporary")
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                if self.input.count == self.passcodeLength {
                    UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimation, options: .curveEaseInOut) {
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.delayAnimation) {
                            self.resetPasscodeField()
                            self.statusLabel.text = "CONFIRM YOUR PASSCODE"
                        }
                    }
                }
            }
        } else if statusLabel.text == "CONFIRM YOUR PASSCODE" {
            if self.input.count < self.passcodeLength {
                self.input += String(sender.tag)
                setupWidthConstraint()
            } else {
                input = ""
            }
            
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                if self.input.count == self.passcodeLength {
                    if self.input == self.userDefaults.value(forKey: "inputTemporary") as! String {
                        self.userDefaults.setValue(self.input, forKey: "inputPassCode")
                        UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimation, options: .curveEaseInOut) {
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.delayAnimation) {
                                self.resetPasscodeField()
                                self.showUnlockView()
                            }
                        }
                    } else {
                        UIView.animate(withDuration: self.animationDuration, delay: self.delayAnimation, options: .curveEaseInOut) {
                            self.view.layoutIfNeeded()
                        } completion: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.delayAnimation) {
                                self.resetPasscodeField()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setupWidthConstraint(){
        self.progressWidthConstraint.constant = passcodeFieldSize * CGFloat(passcodeLength) * min(CGFloat(self.input.count)/CGFloat(passcodeLength), 1) + passcodeFieldSpacing * CGFloat(self.input.count - 1)
    }
    
    func resetPasscodeField() {
        self.input = ""
        self.progressWidthConstraint.constant = 0
        self.progressLeadingConstraint.isActive = true
        self.progressCenterConstraint.isActive = false
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if self.input.count > 1 {
            self.input.removeLast()
            setupWidthConstraint()
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut){
                self.view.layoutIfNeeded()
            }
        } else if self.input.count == 1 {
            self.input.removeLast()
            self.progressWidthConstraint.constant = passcodeFieldSize * CGFloat(passcodeLength) * min(CGFloat(self.input.count)/CGFloat(passcodeLength), 1) + passcodeFieldSpacing * CGFloat(self.input.count)
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut){
                self.view.layoutIfNeeded()
            }
        } else {
            self.input = ""
        }
    }
    
    @objc func showUnlockView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UnlockView") as! UnlockViewController
        let navigation = UINavigationController(rootViewController: vc)
        self.view.addSubview(navigation.view)
    }
}


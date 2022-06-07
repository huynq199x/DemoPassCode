//
//  CheckPassCodeViewController.swift
//  Demo
//
//  Created by Nguyen Quang Huy on 14/05/2022.
//

import UIKit

class PassCodeViewController: UIViewController {
    
    @IBOutlet weak var progressLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var passcodeStackView: UIStackView!
    @IBOutlet weak var statusLabel: UILabel!
    private let animationDuration: CGFloat = 0.25
    private var input: String = ""
    private let passcodeLength: Int = 4
    private var passcode: String = ""
    private let passcodeFieldSize: CGFloat = 30
    private let delayAnimation: CGFloat = 0.5
    private let userDefaults = UserDefaults.standard
    private var temporary = ""
    private var isAnimating = false
    
    enum Keys {
        static let passcode = "passcode"
    }
    
    struct Titles {
        static let enterPasscode = "ENTER YOUR PASSCODE"
        static let createPasscode = "CREATE YOUR PASSCODE"
        static let confirmPasscode = "CONFIRM YOUR PASSCODE"
    }
    
    struct Messages {
        static let notMatch = "Password is not match"
        static let incorrectPasscode = "Passcode is incorrect."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcode = userDefaults.string(forKey: Keys.passcode) ?? ""
        
        for subView in self.passcodeStackView.arrangedSubviews {
            subView.layer.borderWidth = 1
            subView.layer.cornerRadius = passcodeFieldSize / 2
            subView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if passcode == "" {
            statusLabel.text = Titles.createPasscode
        } else {
            statusLabel.text = Titles.enterPasscode
        }
        progressView.layer.cornerRadius = passcodeFieldSize / 2
    }
    
    func updateProgress(completion: @escaping () -> Void) {
        let spacing = passcodeStackView.spacing
        let inputCount = CGFloat(self.input.count)
        progressWidthConstraint.constant = passcodeFieldSize * inputCount + spacing * (inputCount - 1)
        
        isAnimating = true
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.isAnimating = false
            completion()
        }
    }
    
    func alert(_ title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func onSuccess() {
        progressWidthConstraint.constant = self.passcodeFieldSize
        progressLeadingConstraint.isActive = false
        progressCenterConstraint.isActive = true
        
        UIView.animate(withDuration: self.animationDuration, delay: delayAnimation, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.passcodeStackView.isHidden = true
            self.progressView.backgroundColor = UIColor.green
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.clearPasscodeFields()
                self.showMainScreen()
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard input.count < passcodeLength else {
            return
        }
        
        guard !isAnimating else {
            return
        }
        
        if sender.tag > 0 {
            input += String(sender.tag)
        } else if !input.isEmpty {
            input.removeLast()
        }
        print(input)
        
        updateProgress {
            guard self.input.count == self.passcodeLength else {
                return
            }
            
            if !self.passcode.isEmpty {
                if self.passcode == self.input {
                    self.onSuccess()
                } else {
                    self.clearPasscodeFields()
                    self.alert(Messages.incorrectPasscode)
                }
            }
            else if self.temporary.isEmpty {
                self.clearPasscodeFields()
                self.temporary = self.input
                self.statusLabel.text = Titles.confirmPasscode
            } else {
                self.clearPasscodeFields()
                if self.input == self.temporary {
                    self.userDefaults.set(self.input, forKey: Keys.passcode)
                    self.showMainScreen()
                } else {
                    // Start over
                    self.temporary = ""
                    self.alert(Messages.notMatch)
                    self.statusLabel.text = Titles.createPasscode
                }
            }
            self.input = ""
        }
    }
    
    func clearPasscodeFields() {
        progressWidthConstraint.constant = 0
        progressLeadingConstraint.isActive = true
        progressCenterConstraint.isActive = false
        view.layoutIfNeeded()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.buttonPressed(sender)
    }
    
    @objc func showMainScreen() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "\(MainViewController.self)") as! MainViewController
        let navigation = UINavigationController(rootViewController: vc)
        self.view.addSubview(navigation.view)
    }
}


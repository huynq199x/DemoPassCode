import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var progressLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var progressWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var progressCenterConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var progressView: UIView!
  @IBOutlet var buttons: [UIButton]!
    
  @IBOutlet var passCodeCharacter: [PassCodeCharacter]!
  
  
  private let animationDuration: CGFloat = 0.33
  private var input: String = ""
  private let numberOfPasswordCharacter: Int = 4
  private let pass: String = "0000"
    
  override func viewDidLoad() {
    super.viewDidLoad()
    for button in buttons {
      button.backgroundColor = .black
      button.tintColor = .white
    }
  }
    
  @IBAction func buttonPressed(_ sender: UIButton) {
    input += String(sender.tag)
    self.progressWidthConstraint.constant = 240 * min(CGFloat(self.input.count)/CGFloat(numberOfPasswordCharacter), 1)
    progressView.layer.cornerRadius = 30
    
    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
      self.view.layoutIfNeeded()
    } completion: { _ in
      if self.input.count == self.numberOfPasswordCharacter {
        if self.input == self.pass {

          self.progressWidthConstraint.constant = CGFloat(240 / self.numberOfPasswordCharacter)
          self.progressLeadingConstraint.isActive = false
          self.progressCenterConstraint.isActive = true
          
          UIView.animate(withDuration: self.animationDuration, delay: 0.5, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            for character in self.passCodeCharacter {
              character.isHidden = true
            }
            
            self.progressView.backgroundColor = .green
          } completion: { _ in
            // Reset
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              self.showUnlockView()
            }
          }
        }
        else {
          UIView.animate(withDuration: self.animationDuration, delay: 0.5, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
          } completion: { _ in
            // Reset
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.input = ""
            self.progressWidthConstraint.constant = 0
            self.progressCenterConstraint.isActive = false
            self.progressLeadingConstraint.isActive = true
            }
          }
        }
      }
    }
  }
  @IBAction func deleteButtonPressed(_ sender: Any) {
    if self.input.count > 0 {
      self.input.removeLast()
    }
    self.progressWidthConstraint.constant = 240 * min(CGFloat(self.input.count)/CGFloat(numberOfPasswordCharacter), 1)
    UIView.animate(withDuration: self.animationDuration, delay: 0.05, options: .curveEaseInOut){
      self.view.layoutIfNeeded()
    }
  }
  @objc func showUnlockView(){
    let unlockVC = UIStoryboard(name: "Main", bundle: nil)
    let controller = unlockVC.instantiateViewController(withIdentifier: "UnlockViewController") as! UnlockViewController
    let navigation = UINavigationController(rootViewController: controller)
    self.view.addSubview(navigation.view)
  }
}

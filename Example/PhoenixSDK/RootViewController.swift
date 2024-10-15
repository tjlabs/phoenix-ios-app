
import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var titleVehicleLabel: UILabel!
    @IBOutlet weak var titleGuidanceLabel: UILabel!
    @IBOutlet weak var titleServiceLabel: UILabel!
    

    @IBOutlet weak var businessLoginButton: UIButton!
    @IBOutlet weak var businessLoginImage: UIImageView!
    @IBOutlet weak var businessLoginLabel: UILabel!
    
    @IBOutlet weak var personalLoginButton: UIButton!
    @IBOutlet weak var personalLoginImage: UIImageView!
    @IBOutlet weak var personalLoginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleLabels()
        self.setupLoginButtons()
        self.setupButtonTouchEffects()
    }
    
    private func setupTitleLabels() {
        self.titleVehicleLabel.font = UIFont.pretendardExtraBold(size: 50)
        self.titleGuidanceLabel.font = UIFont.pretendardExtraBold(size: 50)
        self.titleServiceLabel.font = UIFont.pretendardExtraBold(size: 50)
    }
    
    private func setupLoginButtons() {
        // Business
        self.businessLoginButton.backgroundColor = UIColor(hexCode: "F9E64D")
        self.businessLoginButton.borderColor = .clear
        self.businessLoginButton.cornerRadius = 20
        self.businessLoginButton.borderWidth = 1
        self.businessLoginLabel.font = UIFont.pretendardBold(size: 20)
        
        // Personal
        self.personalLoginButton.backgroundColor = UIColor(hexCode: "E8E8E8")
        self.personalLoginButton.borderColor = .clear
        self.personalLoginButton.cornerRadius = 20
        self.personalLoginButton.borderWidth = 1
        self.personalLoginLabel.font = UIFont.pretendardBold(size: 20)
    }
    
    private func setupButtonTouchEffects() {
        businessLoginButton.addTarget(self, action: #selector(businessButtonTouchDown), for: .touchDown)
        businessLoginButton.addTarget(self, action: #selector(businessButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        personalLoginButton.addTarget(self, action: #selector(personalButtonTouchDown), for: .touchDown)
        personalLoginButton.addTarget(self, action: #selector(personalButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func businessButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.businessLoginButton.backgroundColor = UIColor(hexCode: "E5D33C") // Darken on press
            self.businessLoginButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96) // Slightly scale down
        }
    }

    @objc private func businessButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.businessLoginButton.backgroundColor = UIColor(hexCode: "F9E64D") // Original color
            self.businessLoginButton.transform = CGAffineTransform.identity // Reset scale
        }
    }
        
    @objc private func personalButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.personalLoginButton.backgroundColor = UIColor(hexCode: "D0D0D0") // Darken on press
            self.personalLoginButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96) // Slightly scale down
        }
    }

    @objc private func personalButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.personalLoginButton.backgroundColor = UIColor(hexCode: "E8E8E8") // Original color
            self.personalLoginButton.transform = CGAffineTransform.identity // Reset scale
        }
    }
    
    @IBAction func tapBusinessLogin(_ sender: UIButton) {
        print("Business Login Tapped")
    }
    
    @IBAction func tapPersonalLogin(_ sender: UIButton) {
        print("Personal Login Tapped")
    }
}

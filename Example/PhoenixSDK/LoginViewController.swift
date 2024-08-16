
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var companyTitleLabel: UILabel!
    @IBOutlet weak var carNumberTitleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var carNumberTextField: UITextField!
    
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var saveUserInfoButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    var isSaveUserInfo: Bool = false
    var userName: String = ""
    var userCompany: String = ""
    var userCarNumber: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        setTitleLabelWidth()
        loadUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        companyTextField.delegate = self
        carNumberTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
             self.view.endEditing(true)
    }
    
    private func setTitleLabelWidth() {
        let containerWidth = containerView.frame.width
        let titleLabelWidth = containerWidth * 0.3
        
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTitleLabel.widthAnchor.constraint(equalToConstant: titleLabelWidth).isActive = true
        
        companyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        companyTitleLabel.widthAnchor.constraint(equalToConstant: titleLabelWidth).isActive = true
        
        carNumberTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        carNumberTitleLabel.widthAnchor.constraint(equalToConstant: titleLabelWidth).isActive = true
    }
    
    @IBAction func tapSaveUserInfoButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
        }
        
        if sender.isSelected == false {
            isSaveUserInfo = true
        }
        else {
            isSaveUserInfo = false
        }
    }
    
    @IBAction func tapLoginButton(_ sender: UIButton) {
        let userInfo = setUserInfo()
        
        if (checkUserInfo(userInfo: userInfo)) {
            if (isSaveUserInfo) {
                saveUserInfo(userInfo: userInfo, initialize: false)
            } else {
                saveUserInfo(userInfo: userInfo, initialize: true)
            }
            goToDestinationVC(userInfo: userInfo)
//            goToJupiterServiceVC(userInfo: userInfo)
        } else {
            guideLabel.isHidden = false
        }
        
    }
    
    func loadUserInfo() {
        var loadCount: Int = 0
        
        if let name = userDefaults.string(forKey: "userName") {
            nameTextField.text = name
            loadCount += 1
        }
        if let company = userDefaults.string(forKey: "userCompany") {
            companyTextField.text = company
            loadCount += 1
        }
        if let carNumber = userDefaults.string(forKey: "userCarNumber") {
            carNumberTextField.text = carNumber
            loadCount += 1
        }
        
        if (loadCount == 3) {
            isSaveUserInfo = true
            
            if (!saveUserInfoButton.isSelected) {
                saveUserInfoButton.isSelected.toggle()
            }
        }
    }
    
    func checkUserInfo(userInfo: UserInfo) -> Bool {
        let name = userInfo.name
        let company = userInfo.company
        let carNumber = userInfo.carNumber
        
        if (name == "" || name.contains(" ")) {
            return false
        } else if (company == "" || company.contains(" ")) {
            return false
        } else if (carNumber == "" || carNumber.contains(" ")) {
            return false
        }
        return true
    }
    
    func setUserInfo() -> UserInfo {
        self.userName = nameTextField.text ?? ""
        self.userCompany = companyTextField.text ?? ""
        self.userCarNumber = carNumberTextField.text ?? ""
        
        return UserInfo(name: self.userName, company: self.userCompany, carNumber: self.userCarNumber)
    }
    
    func saveUserInfo(userInfo: UserInfo, initialize: Bool) {
        if (initialize) {
            userDefaults.set(nil, forKey: "userName")
            userDefaults.set(nil, forKey: "userCompany")
            userDefaults.set(nil, forKey: "userCarNumber")
        } else {
            let name = userInfo.name
            let company = userInfo.company
            let carNumber = userInfo.carNumber
            
            userDefaults.set(name, forKey: "userName")
            userDefaults.set(company, forKey: "userCompany")
            userDefaults.set(carNumber, forKey: "userCarNumber")
        }
        userDefaults.synchronize()
    }
    
    func goToDestinationVC(userInfo: UserInfo) {
        guard let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: DestinationViewController.identifier) as? DestinationViewController else { return }
        destinationVC.userInfo = userInfo
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    private func goToJupiterServiceVC(userInfo: UserInfo) {
        guard let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: JupiterServiceViewController.identifier) as? JupiterServiceViewController else { return }
        serviceVC.userInfo = userInfo
        
        self.navigationController?.pushViewController(serviceVC, animated: true)
    }
}


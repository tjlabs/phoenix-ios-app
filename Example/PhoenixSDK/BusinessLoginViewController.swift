
import UIKit
import RxSwift
import RxCocoa

class BusinessLoginViewController: UIViewController, UITextFieldDelegate {
    static let identifier = "BusinessLoginViewController"
    
    private lazy var topView = TopView(title: "산업회원 로그인")
    private let disposeBag = DisposeBag()
    
    private let nameTextField = UITextField().then {
        $0.font = UIFont.pretendardRegular(size: 15)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.placeholder = "이름 입력"
    }
    
    private lazy var separatorViewForName: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let carNumberTextField = UITextField().then {
        $0.font = UIFont.pretendardRegular(size: 15)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.placeholder = "차량 번호 입력"
    }
    
    private lazy var separatorViewForCarNumber: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let companyTextField = UITextField().then {
        $0.font = UIFont.pretendardRegular(size: 15)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.placeholder = "소속 입력"
    }
    
    private lazy var separatorViewForCompany: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let phoneNumberTextField = UITextField().then {
        $0.font = UIFont.pretendardRegular(size: 15)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.placeholder = "전화 번호 입력"
    }
    
    private lazy var separatorViewForPhoneNumber: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let saveUserInfoLabel = UILabel().then {
        $0.text = "사용자 정보 저장"
        $0.font = UIFont.pretendardSemiBold(size: 15)
        $0.textAlignment = .right
    }
    
    private let saveUserInfoButton = UIButton().then {
        $0.setImage(UIImage(named: "uncheckedBox_icon"), for: .normal)
        $0.setImage(UIImage(named: "checkedBox_icon"), for: .selected)
    }
    
    private let loginButton = UIButton().then {
        $0.backgroundColor = UIColor.black
        $0.borderColor = .clear
        $0.cornerRadius = 20
        $0.borderWidth = 1
        $0.isUserInteractionEnabled = true
        
        $0.setTitle("LOGIN", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.pretendardBold(size: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindActions()
        loadBusinessUserInfo()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.carNumberTextField.becomeFirstResponder()
        } else if textField == self.carNumberTextField {
            self.companyTextField.becomeFirstResponder()
        } else if textField == self.companyTextField {
            self.phoneNumberTextField.becomeFirstResponder()
        } else if textField == self.phoneNumberTextField {
            textField.resignFirstResponder()
        }
//        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
             self.view.endEditing(true)
    }
    
    private func bindActions() {
        topView.backButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.tapBackButton()
            }).disposed(by: disposeBag)
        
        nameTextField.delegate = self
        carNumberTextField.delegate = self
        companyTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        saveUserInfoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.saveUserInfoButton.isSelected.toggle()
                if self.saveUserInfoButton.isSelected {
                    UserInfoManager.shared.setBusinessUserInfoSaved(flag: true)
                } else {
                    UserInfoManager.shared.setBusinessUserInfoSaved(flag: false)
                }
            })
            .disposed(by: disposeBag)
        
        loginButton.addTarget(self, action: #selector(loginButtonTouchDown), for: .touchDown)
        loginButton.addTarget(self, action: #selector(loginButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
        
    private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func loginButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.loginButton.backgroundColor = UIColor.darkGray
            self.loginButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96) // Slightly scale down
        }
        
        // Login Button Clicked
        let name = nameTextField.text ?? ""
        let carNumber = carNumberTextField.text ?? ""
        let company = companyTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let businessUserInfo = BusinessUserInfo(name: name, car_number: carNumber, company: company, phone_number: phoneNumber)
        
        if (UserInfoManager.shared.checkBusinessUserInfo(userInfo: businessUserInfo)) {
            UserInfoManager.shared.setBusinessUserInfo(userInfo: businessUserInfo)
            if UserInfoManager.shared.isBusinessUserInfoSaved {
                UserInfoManager.shared.saveBusinessUserInfo(userInfo: businessUserInfo, initialize: false)
            } else {
                UserInfoManager.shared.saveBusinessUserInfo(userInfo: businessUserInfo, initialize: true)
            }
            self.loginButtonTouchUp()
            self.goToSetDestinationVC()
        } else {
            // Valid Input
        }
    }

    @objc private func loginButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.loginButton.backgroundColor = UIColor.black // Original color
            self.loginButton.transform = CGAffineTransform.identity // Reset scale
        }
    }
    
    private func loadBusinessUserInfo() {
        let loadedUserInfo = UserInfoManager.shared.loadBusinessUserInfo()
        if UserInfoManager.shared.isBusinessUserInfoSaved {
            self.nameTextField.text = loadedUserInfo.name
            self.carNumberTextField.text = loadedUserInfo.car_number
            self.companyTextField.text = loadedUserInfo.company
            self.phoneNumberTextField.text = loadedUserInfo.phone_number
            
            if (!saveUserInfoButton.isSelected) {
                saveUserInfoButton.isSelected.toggle()
            }
        }
    }
    
    func goToSetDestinationVC() {
        guard let setDestinationVC = self.storyboard?.instantiateViewController(withIdentifier: SetDestinationViewController.identifier) as? SetDestinationViewController else { return }
        self.navigationController?.pushViewController(setDestinationVC, animated: true)
    }
}

private extension BusinessLoginViewController {
    func setupLayout() {
        view.addSubview(topView)
        view.addSubview(nameTextField)
        view.addSubview(separatorViewForName)
        view.addSubview(carNumberTextField)
        view.addSubview(separatorViewForCarNumber)
        view.addSubview(companyTextField)
        view.addSubview(separatorViewForCompany)
        view.addSubview(phoneNumberTextField)
        view.addSubview(separatorViewForPhoneNumber)
        view.addSubview(saveUserInfoLabel)
        view.addSubview(saveUserInfoButton)
        view.addSubview(loginButton)
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        separatorViewForName.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(1)
        }
        
        carNumberTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(separatorViewForName.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        separatorViewForCarNumber.snp.makeConstraints { make in
            make.top.equalTo(carNumberTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(1)
        }
        
        companyTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(separatorViewForCarNumber.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        separatorViewForCompany.snp.makeConstraints { make in
            make.top.equalTo(companyTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(1)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(separatorViewForCompany.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        separatorViewForPhoneNumber.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(1)
        }
        
        saveUserInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorViewForPhoneNumber.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(40)
        }
        
        saveUserInfoButton.snp.makeConstraints { make in
            make.centerY.equalTo(saveUserInfoLabel)
            make.trailing.equalTo(saveUserInfoLabel.snp.leading).offset(-10)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(saveUserInfoButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}


import UIKit
import RxSwift
import RxCocoa

class PersonalLoginViewController: UIViewController, UITextFieldDelegate {
    static let identifier = "PersonalLoginViewController"
    
    private lazy var topView = TopView(title: "개인회원 로그인")
    private let disposeBag = DisposeBag()
    
    private let emailTextField = UITextField().then {
        $0.font = UIFont.pretendardRegular(size: 15)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.placeholder = "이메일 입력"
    }
    
    private lazy var separatorViewForEmail: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let passwordTextField = UITextField().then {
        $0.font = UIFont.pretendardRegular(size: 15)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.placeholder = "비밀번호 입력"
        $0.isSecureTextEntry = true
    }
    
    private lazy var separatorViewForPassword: UIView = {
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
    
    private let findUserInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
//        stackView.backgroundColor = .black
        return stackView
    }()
    
    private let findEmailLabel = UIButton().then {
        $0.setTitle("아이디 찾기", for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.titleLabel?.textAlignment = .right
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 14)
//        $0.backgroundColor = .red
    }
    
    private let findUserInfoSeperator = UILabel().then {
        $0.text = " | "
        $0.textColor = .systemGray
        $0.font = UIFont.pretendardRegular(size: 14)
        $0.textAlignment = .center
//        $0.backgroundColor = .green
    }
    
    private let findPasswordLabel = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
        $0.titleLabel?.textAlignment = .left
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 14)
//        $0.backgroundColor = .blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindActions()
        loadPersonalUserInfo()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        saveUserInfoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.saveUserInfoButton.isSelected.toggle()
                if self.saveUserInfoButton.isSelected {
                    UserInfoManager.shared.setPersonalUserInfoSaved(flag: true)
                } else {
                    UserInfoManager.shared.setPersonalUserInfoSaved(flag: false)
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
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let personalUserInfo = PersonalUserInfo(email: email, password: password)
        
        if (UserInfoManager.shared.checkPersonalUserInfo(userInfo: personalUserInfo)) {
            UserInfoManager.shared.setPersonalUserInfo(userInfo: personalUserInfo)
            if UserInfoManager.shared.isPersonalUserInfoSaved {
                UserInfoManager.shared.savePersonalUserInfo(userInfo: personalUserInfo, initialize: false)
            } else {
                UserInfoManager.shared.savePersonalUserInfo(userInfo: personalUserInfo, initialize: true)
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
    
    private func loadPersonalUserInfo() {
        let loadedUserInfo = UserInfoManager.shared.loadPersonalUserInfo()
        if UserInfoManager.shared.isPersonalUserInfoSaved {
            self.emailTextField.text = loadedUserInfo.email
            self.passwordTextField.text = loadedUserInfo.password
            
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

private extension PersonalLoginViewController {
    func setupLayout() {
        view.addSubview(topView)
        view.addSubview(emailTextField)
        view.addSubview(separatorViewForEmail)
        view.addSubview(passwordTextField)
        view.addSubview(separatorViewForPassword)
        view.addSubview(saveUserInfoLabel)
        view.addSubview(saveUserInfoButton)
        view.addSubview(loginButton)
        
        view.addSubview(findUserInfoStackView)
        findUserInfoStackView.addArrangedSubview(findEmailLabel)
        findUserInfoStackView.addArrangedSubview(findUserInfoSeperator)
        findUserInfoStackView.addArrangedSubview(findPasswordLabel)
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        separatorViewForEmail.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(1)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(separatorViewForEmail.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        separatorViewForPassword.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(1)
        }
        
        saveUserInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorViewForPassword.snp.bottom).offset(20)
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
        
        findUserInfoStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        findEmailLabel.snp.makeConstraints { make in
            make.width.equalTo(findPasswordLabel).multipliedBy(1.0)
        }

        findUserInfoSeperator.snp.makeConstraints { make in
            make.width.equalTo(findEmailLabel).multipliedBy(0.1)
        }

        findEmailLabel.contentHorizontalAlignment = .right
        findPasswordLabel.contentHorizontalAlignment = .left
    }
}

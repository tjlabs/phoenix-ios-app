
import UIKit
import RxSwift
import RxCocoa

class AddDestinationViewController: UIViewController, UITextFieldDelegate {
    static let identifier = "AddDestinationViewController"
    let USER_TYPE = UserInfoManager.shared.userType
    
    private lazy var topView = TopView(title: "")
    private lazy var dialogView = DialogView()
    var isAlreadyHas: Bool = false
    
    private let explainLabelLine1 = UILabel().then {
        $0.font = UIFont.pretendardSemiBold(size: 25)
        $0.text = "산업 현장 목적지 등록을 위해"
        $0.textAlignment = .left
        $0.textColor = .black
    }
    private let explainLabelLine2Blue = UILabel().then {
        $0.font = UIFont.pretendardBold(size: 25)
        $0.text = "산업용 코드"
        $0.textAlignment = .left
        $0.textColor = .systemBlue
    }
    private let explainLabelLine2Black = UILabel().then {
        $0.font = UIFont.pretendardSemiBold(size: 25)
        $0.text = "를 입력해주세요"
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private let codeTextField = UITextField().then {
        $0.font = UIFont.pretendardRegular(size: 30)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.placeholder = "코드 입력"
    }
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let addButton = UIButton().then {
        $0.backgroundColor = UIColor.black
        $0.borderColor = .clear
        $0.cornerRadius = 20
        $0.borderWidth = 1
        $0.isUserInteractionEnabled = true
        
        $0.setTitle("Add", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.pretendardBold(size: 16)
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindActions()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        
        codeTextField.delegate = self
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.addMyDestination()
            })
            .disposed(by: disposeBag)
        
        addButton.addTarget(self, action: #selector(addButtonTouchDown), for: .touchDown)
        addButton.addTarget(self, action: #selector(addButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        dialogView.confirmButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.tapDialogConfirmButton()
            }).disposed(by: disposeBag)
    }
        
    private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func tapDialogConfirmButton() {
        if self.isAlreadyHas {
            self.tapBackButton()
            self.isAlreadyHas = false
        }
    }
    
    private func addMyDestination() {
        let code = self.codeTextField.text ?? ""
        self.codeTextField.resignFirstResponder()
        if code.isEmpty {
            // 코드 입력
            dialogView.changeDialogInformation(message: "유효한 코드를 입력해주세요", buttonColor: .systemRed)
            dialogView.toggleDialogViewHidden()
        } else {
            let input = InputSectors(user_group_code: code)
            NetworkManager.shared.postUserSectors(url: SECTORS_URL, input: input, completion: { [self] statusCode, returnedString in
                if statusCode == 200 {
                    let decodedResult = jsonToOutputSectors(jsonString: returnedString)
                    if decodedResult.0 {
                        let outputSectors: OutputSectors = decodedResult.1
                        if outputSectors.sectors.isEmpty {
                            // 실패
                            dialogView.changeDialogInformation(message: "목적지 등록 실패", buttonColor: .systemRed)
                            dialogView.toggleDialogViewHidden()
                        } else {
                            // 성공
                            let isAlreadyHas = DestinationManager.shared.makeDestinationInformationList(outputSectors: outputSectors)
                            self.isAlreadyHas = isAlreadyHas
                            let message = isAlreadyHas ? "이미 등록된 목적지" : "목적지 등록 성공"
                            dialogView.changeDialogInformation(message: message, buttonColor: .black)
                            dialogView.toggleDialogViewHidden()
                        }
                    } else {
                        // 실패
                        dialogView.changeDialogInformation(message: "목적지 등록 실패", buttonColor: .systemRed)
                        dialogView.toggleDialogViewHidden()
                    }
                } else {
                    // 실패
                    dialogView.changeDialogInformation(message: "목적지 등록 실패(\(statusCode))", buttonColor: .systemRed)
                    dialogView.toggleDialogViewHidden()
                }
            })
        }
    }
    
    @objc private func addButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.addButton.backgroundColor = UIColor.darkGray
            self.addButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96) // Slightly scale down
        }
    }

    @objc private func addButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.addButton.backgroundColor = UIColor.black // Original color
            self.addButton.transform = CGAffineTransform.identity // Reset scale
        }
    }
}

private extension AddDestinationViewController {
    func setupLayout() {
        view.addSubview(topView)
        view.addSubview(explainLabelLine1)
        view.addSubview(explainLabelLine2Blue)
        view.addSubview(explainLabelLine2Black)
        
        view.addSubview(codeTextField)
        view.addSubview(separatorView)
        view.addSubview(addButton)
        
        view.addSubview(dialogView)
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
        
        explainLabelLine1.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(topView.snp.bottom).offset(20)
        }
        
        explainLabelLine2Blue.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(120)
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(explainLabelLine1.snp.bottom).offset(10)
        }
        
        explainLabelLine2Black.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.equalTo(explainLabelLine2Blue.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(explainLabelLine2Blue)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(explainLabelLine2Blue.snp.bottom).offset(20)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(separatorView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dialogView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

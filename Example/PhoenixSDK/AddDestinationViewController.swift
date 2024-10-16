
import UIKit
import RxSwift
import RxCocoa

class AddDestinationViewController: UIViewController, UITextFieldDelegate {
    static let identifier = "AddDestinationViewController"
    let USER_TYPE = UserInfoManager.shared.userType
    
    private lazy var topView = TopView(title: "")
    
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
            })
            .disposed(by: disposeBag)
        
        addButton.addTarget(self, action: #selector(addButtonTouchDown), for: .touchDown)
        addButton.addTarget(self, action: #selector(addButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
        
    private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
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
    }
}

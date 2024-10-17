
import UIKit
import RxSwift
import RxCocoa

class SetDestinationViewController: UIViewController, UITextFieldDelegate {
    static let identifier = "SetDestinationViewController"
    let USER_TYPE = UserInfoManager.shared.userType
    
    private lazy var topView = TopView(title: "목적지 설정")
    private lazy var myDestinationView = MyDestinationView()
    private lazy var searchedDestinationView = SearchedDestinationView()
    private lazy var dialogView = DialogView()
    private let addDestinationButton = UIButton().then {
        $0.setImage(UIImage(named: "plus_button"), for: .normal)
    }
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var searchDestinationView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.borderColor = .clear
        view.cornerRadius = 10
        view.borderWidth = 1
        
        return view
    }()
    private let searchImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "search_icon")
    }
    private let searchGuideLabel = UILabel().then {
        $0.text = "도로명 주소, 건물명 또는 지번"
        $0.textColor = .darkGray
        $0.font = UIFont.pretendardSemiBold(size: 17)
        $0.textAlignment = .left
    }
    
    private let searchTextField = UITextField().then {
        $0.font = UIFont.pretendardRegular(size: 17)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        loadDestinationInformationList()
    }
    
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
        
        addDestinationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tapAddDestinationButton()
            })
            .disposed(by: disposeBag)

        searchTextField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: searchGuideLabel.rx.isHidden)
            .disposed(by: disposeBag)
        searchTextField.delegate = self
    }
        
    private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func goToAddDestinationVC() {
        guard let addDestinationVC = self.storyboard?.instantiateViewController(withIdentifier: AddDestinationViewController.identifier) as? AddDestinationViewController else { return }
        self.navigationController?.pushViewController(addDestinationVC, animated: true)
    }
    
    private func tapAddDestinationButton() {
        if USER_TYPE == .BUSINESS {
            self.goToAddDestinationVC()
        } else {
            dialogView.toggleDialogViewHidden()
        }
    }
    
    private func loadDestinationInformationList() {
        if USER_TYPE == .BUSINESS {
            DestinationManager.shared.loadBusinessDestinationInformationList(businessUserInfo: UserInfoManager.shared.getBussinessUserInfo())
        } else if USER_TYPE == .PERSONAL {
            DestinationManager.shared.loadPersonalDestinationInformationList(personalUserInfo: UserInfoManager.shared.getPersonalUserInfo())
        }
    }
}

private extension SetDestinationViewController {
    func setupLayout() {
        view.addSubview(topStackView)
        topStackView.addArrangedSubview(topView)
        topStackView.addArrangedSubview(addDestinationButton)
        view.addSubview(searchDestinationView)
        view.addSubview(searchImage)
        view.addSubview(searchGuideLabel)
        view.addSubview(searchTextField)
        
        view.addSubview(myDestinationView)
        view.addSubview(searchedDestinationView)
        
        view.addSubview(dialogView)
        
        topStackView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
        
        addDestinationButton.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
        
        // 검색
        searchDestinationView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(topStackView.snp.bottom).offset(10)
        }
        searchImage.snp.makeConstraints { make in
            make.centerY.equalTo(searchDestinationView)
            make.width.equalTo(25)
            make.leading.equalTo(searchDestinationView.snp.leading).offset(15)
            make.top.equalTo(searchDestinationView.snp.top).inset(10)
            make.bottom.equalTo(searchDestinationView.snp.bottom).inset(10)
        }
        searchGuideLabel.snp.makeConstraints { make in
            make.centerY.equalTo(searchDestinationView)
            make.leading.equalTo(searchImage.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(searchDestinationView.snp.top).inset(10)
            make.bottom.equalTo(searchDestinationView.snp.bottom).inset(10)
        }
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalTo(searchDestinationView)
            make.leading.equalTo(searchImage.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(searchDestinationView.snp.top).inset(10)
            make.bottom.equalTo(searchDestinationView.snp.bottom).inset(10)
        }
        
        // 내 장소
        myDestinationView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchDestinationView.snp.bottom).offset(10)
        }
        
        // 장소
        searchedDestinationView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(myDestinationView.snp.bottom)
        }
        
        dialogView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

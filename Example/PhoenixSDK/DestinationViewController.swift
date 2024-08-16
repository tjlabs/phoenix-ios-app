
import UIKit
import RxSwift
import RxCocoa

class DestinationViewController: UIViewController {
    static let identifier = "DestinationViewController"
    
    var userInfo = UserInfo(name: "", company: "", carNumber: "")
    private let viewModel = DestinationViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var destinationView: DestinationView = {
        let view = DestinationView(frame: .zero, viewModel: viewModel)
        return view
    }()
    private lazy var myInfoView = MyInfoView(userInfo: userInfo)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 현장"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
//        label.backgroundColor = .yellow
        return label
    }()
    
    private lazy var addNewLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemCyan
        button.borderColor = .clear
        button.cornerRadius = 10
        button.borderWidth = 2
        button.shadowColor = .systemGray
        button.shadowOpacity = 1.0
//        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        button.setTitle("+ 신규 현장 등록", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var editLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.buttonTapped
            .subscribe(onNext: { [weak self] info in
                self?.handleButtonTapped(destinationInfo: info)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleButtonTapped(destinationInfo: DestinationInfo) {
        showPopUp(title: destinationInfo.name,
                  message: "이 목적지를 설정하사겠습니까?",
                  leftActionTitle: "취소",
                  rightActionTitle: "확인",
                  rightActionCompletion: { self.goToVgsVC(userInfo: self.userInfo, destinationInfo: destinationInfo) })
    }
    
    func goToVgsVC(userInfo: UserInfo, destinationInfo: DestinationInfo) {
        guard let vgsVC = self.storyboard?.instantiateViewController(withIdentifier: VGSViewController.identifier) as? VGSViewController else { return }
        vgsVC.userInfo = userInfo
        vgsVC.destinationInfo = destinationInfo
        
        self.navigationController?.pushViewController(vgsVC, animated: true)
    }
}

private extension DestinationViewController {
    func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(addNewLocationButton)
        view.addSubview(editLocationButton)

        view.addSubview(myInfoView)
        myInfoView.backgroundColor = .systemGray6
        
        view.addSubview(destinationView)
        destinationView.backgroundColor = .green
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        addNewLocationButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        editLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(addNewLocationButton.snp.top).offset(-20)
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        myInfoView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(40)
        }
        
        destinationView.snp.makeConstraints { make in
            make.top.equalTo(editLocationButton.snp.bottom).offset(10)
            make.bottom.equalTo(myInfoView.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

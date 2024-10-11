
import UIKit
import RxSwift
import RxCocoa

class DestinationViewController: UIViewController {
    static let identifier = "DestinationViewController"
    
    var userInfo = UserInfo(name: "", company: "", carNumber: "")
    private let destinationViewModel = DestinationViewModel()
    private let addSectorViewModel = AddNewSectorViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var destinationView: DestinationView = {
        let view = DestinationView(frame: .zero, viewModel: destinationViewModel)
        return view
    }()
    
    private lazy var addNewSectorView: AddNewSectorView = {
        let view = AddNewSectorView(frame: .zero, viewModel: addSectorViewModel)
        return view
    }()
    
    private lazy var myInfoView = MyInfoView(userInfo: userInfo)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 현장"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var addNewLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.borderColor = .clear
        button.cornerRadius = 8
        button.borderWidth = 1
        button.shadowColor = .systemGray
        button.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        button.setTitle("+", for: .normal)
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
        
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.isHidden = true
        return view
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
        destinationViewModel.buttonTapped
            .subscribe(onNext: { [weak self] info in
                self?.handleButtonTapped(destinationInfo: info)
            })
            .disposed(by: disposeBag)
        
        addNewLocationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showPopup()
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
    
    private func showPopup() {
        overlayView.isHidden = false
    }
        
    // Dismiss popup when tapping outside
    @objc private func dismissPopup() {
        overlayView.isHidden = true
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
        view.addSubview(overlayView)
        overlayView.addSubview(addNewSectorView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        addNewLocationButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
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
            make.top.equalTo(addNewLocationButton.snp.bottom).offset(10)
            make.bottom.equalTo(myInfoView.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addNewSectorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        overlayView.addGestureRecognizer(tapGesture)
    }
}

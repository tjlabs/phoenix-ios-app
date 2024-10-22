import UIKit
import SnapKit

class SelectDestinationBottomViewController: BottomSheetViewController {
    // MARK: - Properties
    var destinationInfo: DestinationInformation? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI
    private lazy var countdownView: CircularProgressView = {
        let view = CircularProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var buttonTitleLabel = UILabel().then {
        $0.text = "길안내 시작"
        $0.textColor = .white
        $0.font = UIFont.pretendardBold(size: 24)
        $0.textAlignment = .center
    }

    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    let nameLabel = UILabel().then {
//        $0.backgroundColor = .red
        $0.font = UIFont.pretendardExtraBold(size: 22)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    let serviceAvailabilityLabel = UILabel().then {
//        $0.backgroundColor = .green
        $0.font = UIFont.pretendardExtraBold(size: 17)
        $0.textAlignment = .left
        $0.textColor = .systemBlue
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = UIFont.pretendardSemiBold(size: 17)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    lazy var stackViewTitle: UIStackView = {
        let stackView = UIStackView()
//        stackView.backgroundColor = .yellow
        stackView.axis = .horizontal
        stackView.alignment = .fill
//        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(serviceAvailabilityLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateUI()
        
        startCountdown()
    }
    
    private func setupView() {
        contentStackView.addArrangedSubview(stackViewTitle)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(dismissButton)
        
        dismissButton.addSubview(buttonTitleLabel)
        dismissButton.addSubview(countdownView)
        buttonTitleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        countdownView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(buttonTitleLabel.snp.trailing).offset(10)
            make.width.height.equalTo(40)
        }
        
        serviceAvailabilityLabel.snp.makeConstraints { make in
            make.width.equalTo(130)
        }
        
        self.setContent(content: contentStackView)
    }
    
    private func startCountdown() {
        countdownView.startCountdown { [weak self] in
            self?.dismissBottomSheet()
        }
    }

    @objc private func handleDismissButton() {
        self.dismissBottomSheet()
    }
    
    private func updateUI() {
        guard let destination = destinationInfo, isViewLoaded else { return }
        nameLabel.text = "     " + destination.name
        serviceAvailabilityLabel.text = "서비스 가능 지역"
        descriptionLabel.text = "      " + destination.description
    }
}

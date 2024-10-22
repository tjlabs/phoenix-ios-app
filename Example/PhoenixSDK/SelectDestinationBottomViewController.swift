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

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("길안내 시작", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.pretendardBold(size: 24)

        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.isUserInteractionEnabled = true
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
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
        stackView.distribution = .fillProportionally
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
    }
    
    private func setupView() {
        contentStackView.addArrangedSubview(stackViewTitle)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(dismissButton)
        
        serviceAvailabilityLabel.snp.makeConstraints { make in
            make.width.equalTo(130)
        }
        
        self.setContent(content: contentStackView)
    }

    @objc private func handleDismissButton() {
        self.dismissBottomSheet()
    }
    
    private func updateUI() {
        guard let destination = destinationInfo, isViewLoaded else { return }
        nameLabel.text = "     " + destination.name
        serviceAvailabilityLabel.text = "서비스 가능 지역"
        descriptionLabel.text = "     " + destination.description
    }
}

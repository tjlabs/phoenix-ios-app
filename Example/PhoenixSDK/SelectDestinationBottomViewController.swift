import UIKit

class SelectDestinationBottomViewController: BottomSheetViewController {
    // MARK: - Properties
    var destinationInfo: DestinationInformation? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.text = "title"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "desc"
        return label
    }()
    
    lazy var topLabelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(descriptionLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateUI()
    }
    
    private func setupView() {
        contentStackView.addArrangedSubview(topLabelStackView)
        contentStackView.addArrangedSubview(bodyLabel)
        contentStackView.addArrangedSubview(dismissButton)
        bodyLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        
        self.setContent(content: contentStackView)
    }

    @objc private func handleDismissButton() {
        self.dismissBottomSheet()
    }
    
    private func updateUI() {
        guard let destination = destinationInfo, isViewLoaded else { return }
        titleLabel.text = destination.name
        descriptionLabel.text = destination.description
    }
}

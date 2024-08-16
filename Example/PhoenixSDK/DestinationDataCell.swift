import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DestinationDataCell: UICollectionViewCell {
    static let identifier = "DestinationDataCell"
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    let addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    let setDestinationButton = UIButton().then {
        $0.backgroundColor = .systemCyan
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.setTitle("목적지 설정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.borderColor = .systemGray4
        contentView.borderWidth = 1
        contentView.cornerRadius = 8
        
        contentView.addSubview(stackView)
        contentView.addSubview(setDestinationButton)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(setDestinationButton.snp.leading).offset(-20)
        }
        
        setDestinationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
    private func setupBindings() {
        setDestinationButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.setDestinationButton.backgroundColor = UIColor.systemCyan.withAlphaComponent(0.5)
            })
            .disposed(by: disposeBag)
        
        setDestinationButton.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel])
            .subscribe(onNext: { [weak self] in
                self?.setDestinationButton.backgroundColor = .systemCyan
            })
            .disposed(by: disposeBag)
    }

    func configure(viewModel: DestinationDataCellViewModel){
        nameLabel.text = viewModel.destinationInfo.name
        addressLabel.text = viewModel.destinationInfo.address
        
        setDestinationButton.rx.tap
            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
    }
}

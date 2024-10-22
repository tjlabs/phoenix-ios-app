import UIKit
import SnapKit

final class MyDestinationCell: UICollectionViewCell {
    static let identifier = "MyDestinationCell"
    
    let nameLabel = UILabel().then {
//        $0.backgroundColor = .red
        $0.font = UIFont.pretendardExtraBold(size: 20)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    let serviceAvailabilityLabel = UILabel().then {
//        $0.backgroundColor = .green
        $0.font = UIFont.pretendardExtraBold(size: 15)
        $0.textAlignment = .left
        $0.textColor = .systemBlue
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = UIFont.pretendardSemiBold(size: 15)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private let stackViewTitle: UIStackView = {
        let stackView = UIStackView()
//        stackView.backgroundColor = .yellow
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    private let stackViewTotal: UIStackView = {
        let stackView = UIStackView()
//        stackView.backgroundColor = .blue
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(stackViewTotal)
        stackViewTotal.addArrangedSubview(stackViewTitle)
        stackViewTitle.addArrangedSubview(nameLabel)
        stackViewTitle.addArrangedSubview(serviceAvailabilityLabel)
        stackViewTotal.addArrangedSubview(descriptionLabel)
        
        stackViewTotal.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        serviceAvailabilityLabel.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
    }
    
    func configure(with data: DestinationInformation) {
        nameLabel.text = data.name
        serviceAvailabilityLabel.text = "서비스 가능 지역"
        descriptionLabel.text = data.description
    }
}

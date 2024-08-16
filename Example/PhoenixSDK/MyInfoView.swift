
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class MyInfoView: UIView {
    
    private var userInfo: UserInfo?
    
    // MARK: - Truck Image
    private let truckImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "truckIcon")
//        $0.backgroundColor = .yellow
    }
    
    // MARK: - Driver Name
    private let stackViewName: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
//        stackView.backgroundColor = .red
        return stackView
    }()
    
    private let nameTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
        $0.text = "운전자 명"
        $0.textColor = .black
    }
    
    private let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .black
//        $0.backgroundColor = .green
    }
    
    // MARK: - Company
    private let stackViewCompany: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
//        stackView.backgroundColor = .red
        return stackView
    }()
    
    private let companyTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
        $0.text = "소속"
        $0.textColor = .black
    }
    
    private let companyLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .black
//        $0.backgroundColor = .green
    }
    
    // MARK: - Car Number
    private let stackViewCarNumber: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
//        stackView.backgroundColor = .red
        return stackView
    }()
    
    private let carNumberTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
        $0.text = "차량 번호"
        $0.textColor = .black
    }
    
    private let carNumberLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .black
//        $0.backgroundColor = .green
    }
    
    // MARK: - StackView for combine
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
//        stackView.spacing = 5
//        stackView.backgroundColor = .blue
        return stackView
    }()
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(frame: .zero)
        
        self.borderColor = .black
        self.cornerRadius = 8
        self.borderWidth = 1
        
        setupLayout(userInfo: userInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(userInfo: UserInfo) {
        addSubview(truckImageView)
        addSubview(stackView)
        stackView.addArrangedSubview(stackViewName)
        stackView.addArrangedSubview(stackViewCompany)
        stackView.addArrangedSubview(stackViewCarNumber)
        
        stackViewName.addArrangedSubview(nameTitleLabel)
        nameTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        stackViewName.addArrangedSubview(nameLabel)
        
        stackViewCompany.addArrangedSubview(companyTitleLabel)
        companyTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        stackViewCompany.addArrangedSubview(companyLabel)
        
        stackViewCarNumber.addArrangedSubview(carNumberTitleLabel)
        carNumberTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        stackViewCarNumber.addArrangedSubview(carNumberLabel)
        
        truckImageView.snp.makeConstraints{ make in
            make.width.equalTo(100)
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(2)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(truckImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        nameLabel.text = "  :  \(userInfo.name)"
        companyLabel.text = "  :  \(userInfo.company)"
        carNumberLabel.text = "  :  \(userInfo.carNumber)"
    }
}



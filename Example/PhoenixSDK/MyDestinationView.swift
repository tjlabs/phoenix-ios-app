
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class MyDestinationView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendardSemiBold(size: 17)
        $0.text = "내 장소"
        $0.textAlignment = .left
        $0.textColor = .darkGray
    }
    
    let toggleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "arrowDown_icon")
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemGray6
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(toggleImageView)
        addSubview(titleLabel)
        
        toggleImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(toggleImageView.snp.leading).offset(20)
            make.centerY.equalToSuperview()
        }
    }
}




import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class SearchedDestinationView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendardSemiBold(size: 17)
        $0.text = "장소"
        $0.textAlignment = .left
        $0.textColor = .darkGray
    }
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemGray6
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(separatorView)
        addSubview(titleLabel)
        
        separatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
}



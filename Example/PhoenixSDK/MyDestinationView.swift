
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
    
    private let showMyDestinationButton = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setImage(UIImage(named: "arrowDown_icon"), for: .normal)
        $0.setImage(UIImage(named: "arrowUp_icon"), for: .selected)
    }
    
    let showMyDestinationButtonTapped = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemGray6
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(showMyDestinationButton)
        addSubview(titleLabel)
        
        showMyDestinationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(showMyDestinationButton.snp.leading).offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func bindActions() {
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.showMyDestinationButtonTapped.accept(())
                self?.showMyDestinationButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)
    }
}



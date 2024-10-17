
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class DialogView: UIView {
    
    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        
        return view
    }()
    
    private let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let messageLabel = UILabel().then {
        $0.text = "산업회원 전용 서비스 입니다"
        $0.textColor = .darkGray
        $0.font = UIFont.pretendardSemiBold(size: 20)
        $0.textAlignment = .left
    }
    
    private let confirmButton = UIButton().then {
        $0.backgroundColor = UIColor.black
        $0.borderColor = .clear
        $0.cornerRadius = 15
        $0.borderWidth = 1
        $0.isUserInteractionEnabled = true
        
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.pretendardBold(size: 16)
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.isHidden = true
        
        addSubview(blackView)
        addSubview(messageView)
        messageView.addSubview(messageLabel)
        messageView.addSubview(confirmButton)
        
        // Dialog
        blackView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        messageView.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        messageLabel.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(messageView.snp.top).inset(30)
            make.height.equalTo(50)
        }
        
        confirmButton.snp.makeConstraints{ make in
            make.trailing.equalTo(messageView.snp.trailing).inset(20)
            make.bottom.equalTo(messageView.snp.bottom).inset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    private func bindActions() {
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.toggleDialogViewHidden()
            })
            .disposed(by: disposeBag)
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTouchDown), for: .touchDown)
        confirmButton.addTarget(self, action: #selector(confirmButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        let blackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDialogViewHidden))
        blackView.addGestureRecognizer(blackViewTapGesture)
    }
    
    public func changeDialogInformation(message: String, buttonColor: UIColor) {
        self.messageLabel.text = message
        self.confirmButton.backgroundColor = buttonColor
    }
    
    @objc private func confirmButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.confirmButton.backgroundColor = UIColor.darkGray
            self.confirmButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96) // Slightly scale down
        }
    }

    @objc private func confirmButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.confirmButton.backgroundColor = UIColor.black // Original color
            self.confirmButton.transform = CGAffineTransform.identity // Reset scale
        }
    }
    
    @objc func toggleDialogViewHidden() {
        if self.isHidden {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}



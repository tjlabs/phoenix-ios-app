
import UIKit
import RxSwift
import RxCocoa

class BusinessLoginViewController: UIViewController {
    static let identifier = "BusinessLoginViewController"
    
    private lazy var loginTopView = LoginTopView(title: "산업회원 로그인")
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindActions()
    }
    
    private func bindActions() {
        loginTopView.backButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.tapBackButton()
            }).disposed(by: disposeBag)
    }
        
    private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension BusinessLoginViewController {
    func setupLayout() {
        view.addSubview(loginTopView)
        
        loginTopView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
    }
}

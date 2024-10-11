
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class AddNewSectorView: UIView {
    
    private var viewModel: AddNewSectorViewModel
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .left
        $0.text = "Add New Sector"
        $0.textColor = .black
    }
    
    private let sectorTextField = UITextField().then {
        $0.placeholder = "Sector"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private let codeTextField = UITextField().then {
        $0.placeholder = "Code"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private let checkButton = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.setTitle("CEHCK", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    init(frame: CGRect, viewModel: AddNewSectorViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        backgroundColor = .systemGray4
        cornerRadius = 4
        borderWidth = 1
        borderColor = .clear
        shadowColor = .black
        shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        
        self.viewModel.initalize()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
    }
}



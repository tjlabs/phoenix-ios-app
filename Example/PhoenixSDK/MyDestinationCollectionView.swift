
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class MyDestinationCollectionView: UIView {
    let destinationInfoRelay = BehaviorRelay<[DestinationInformation]>(value: [])
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyDestinationCell.self, forCellWithReuseIdentifier: MyDestinationCell.identifier)
        return collectionView
    }()

    private var destinationInfoList: [DestinationInformation] = []
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        bindActions()
        bindCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.backgroundColor = .systemCyan
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.edges.equalToSuperview()
        }
    }
    
    private func bindActions() {

    }
    
    private func bindCollectionView() {
        // Bind the destination info relay to update the collectionView data source
        destinationInfoRelay
            .subscribe(onNext: { [weak self] destinations in
                self?.destinationInfoList = destinations
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}


extension MyDestinationCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MyDestinationCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("(Phoenix) Cell : count = \(destinationInfoList.count)")
        return destinationInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDestinationCell.identifier, for: indexPath) as? MyDestinationCell else {
            return UICollectionViewCell()
        }
        
        let destination = destinationInfoList[indexPath.item]
        cell.configure(with: destination)
        return cell
    }
}

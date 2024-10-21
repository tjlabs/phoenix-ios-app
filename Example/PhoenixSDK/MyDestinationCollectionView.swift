
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class MyDestinationCollectionView: UIView {
    let destinationInfoRelay = BehaviorRelay<[DestinationInformation]>(value: [])
    let cellSelected = PublishRelay<Int>()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyDestinationCell.self, forCellWithReuseIdentifier: MyDestinationCell.identifier)
        collectionView.register(MyDestinationEmptyCell.self, forCellWithReuseIdentifier: MyDestinationEmptyCell.identifier)
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
//        collectionView.backgroundColor = .systemCyan
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.edges.equalToSuperview()
        }
    }
    
    private func bindActions() {

    }
    
    private func bindCollectionView() {
        destinationInfoRelay
            .subscribe(onNext: { [weak self] destinations in
                self?.destinationInfoList = destinations
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    public func getDestinationInfoListCount() -> Int {
        return self.destinationInfoList.count
    }
}


extension MyDestinationCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MyDestinationCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinationInfoList.isEmpty ? 1 : destinationInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if destinationInfoList.isEmpty {
            // Show "Empty Data" cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDestinationEmptyCell.identifier, for: indexPath) as? MyDestinationEmptyCell else {
                return UICollectionViewCell()
            }
            cell.configure(message: "추가된 내 장소가 없습니다.")
            return cell
        } else {
            // Show normal destination cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDestinationCell.identifier, for: indexPath) as? MyDestinationCell else {
                return UICollectionViewCell()
            }
            let destination = destinationInfoList[indexPath.item]
            cell.configure(with: destination)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelected.accept(indexPath.item)
    }
}

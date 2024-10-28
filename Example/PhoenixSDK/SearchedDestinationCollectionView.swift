import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class SearchedDestinationCollectionView: UIView {
    let destinationInfoRelay = BehaviorRelay<[DestinationInformation]>(value: [])
    let cellSelected = PublishRelay<Int>()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchedDestinationCell.self, forCellWithReuseIdentifier: SearchedDestinationCell.identifier)
        return collectionView
    }()

    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        bindCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.edges.equalToSuperview()
        }
    }
    
    private func bindCollectionView() {
        destinationInfoRelay
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    public func getDestinationInfoListCount() -> Int {
        return destinationInfoRelay.value.count
    }
}

extension SearchedDestinationCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SearchedDestinationCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinationInfoRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedDestinationCell.identifier, for: indexPath) as? SearchedDestinationCell else {
            return UICollectionViewCell()
        }
        let destination = destinationInfoRelay.value[indexPath.item]
        cell.configure(with: destination)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelected.accept(indexPath.item)
    }
}

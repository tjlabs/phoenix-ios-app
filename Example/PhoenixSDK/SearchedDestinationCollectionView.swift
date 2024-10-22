
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

    private var destinationInfoList: [DestinationInformation] = []
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        bindActions()
        bindCollectionView()
        
        initDestinationInfoList()
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
    
    private func initDestinationInfoList() {
        let latitude_start = 37.495758
        let longitude_start = 127.038249
        let destination = DestinationInformation(name: "티제이랩스", address: "현승빌딩 7F", coord: DestinationCoord(latitude: latitude_start, longitude: longitude_start), description: "서울시 강남구 역삼로 175 현승빌딩 7층")
        
        for _ in 0..<5 {
            self.destinationInfoList.append(destination)
        }
//        print("(Phoenix) Search : destinationInfoList = \(destinationInfoList)")
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
        return destinationInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedDestinationCell.identifier, for: indexPath) as? SearchedDestinationCell else {
            return UICollectionViewCell()
        }
        let destination = destinationInfoList[indexPath.item]
        cell.configure(with: destination)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelected.accept(indexPath.item)
    }
}

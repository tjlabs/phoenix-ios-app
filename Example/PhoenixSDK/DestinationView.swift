
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class DestinationView: UIView {
    
    var destinationInfoList = [DestinationInfo]()
    private var viewModel: DestinationViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DestinationDataCell.self, forCellWithReuseIdentifier: DestinationDataCell.identifier)
        return collectionView
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear
//        makeDestinationInfoList()
//        viewModel.initalize(destinationList: destinationInfoList)
//        setupLayout()
//    }
    
    init(frame: CGRect, viewModel: DestinationViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .clear
        makeDestinationInfoList()
        self.viewModel.initalize(destinationList: destinationInfoList)
        setupLayout()
    }
    
//    private var userInfo: UserInfo?
    
//    init(userInfo: UserInfo) {
//        self.userInfo = userInfo
//        super.init(frame: .zero)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeDestinationInfoList() {
        self.destinationInfoList.append(DestinationInfo(name: "COEX 하역장", address: "서울 강남구 영동대로 513", coord: DestinationCoord(latitude: 37.513109, longitude: 127.058375)))
        self.destinationInfoList.append(DestinationInfo(name: "SK 에코플랜트", address: "충북 청주시 M15X", coord: DestinationCoord(latitude: 37.513109, longitude: 127.058375)))
        self.destinationInfoList.append(DestinationInfo(name: "TJLABS", address: "서울 강남구 역삼로 175", coord: DestinationCoord(latitude: 37.495758, longitude: 127.038249)))
    }

    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DestinationView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UIEdgeInsets, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension DestinationView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let destinationCell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationDataCell.identifier, for: indexPath) as? DestinationDataCell else {
            return UICollectionViewCell()
        }
        
//        let info = destinationInfoList[indexPath.row]
//        destinationCell.configure(destinationInfo: info)
        
        let viewModel = self.viewModel.cellViewModels.value[indexPath.row]
        destinationCell.configure(viewModel: viewModel)
        
        return destinationCell
    }
}

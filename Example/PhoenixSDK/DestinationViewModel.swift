import Foundation
import RxSwift
import RxCocoa

class DestinationViewModel {
    let destinationInfoList = BehaviorRelay<[DestinationInfo]>(value: [])
    let cellViewModels: BehaviorRelay<[DestinationDataCellViewModel]> = BehaviorRelay(value: [])
    let buttonTapped = PublishRelay<DestinationInfo>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        
    }
    
    public func initalize(destinationList: [DestinationInfo]) {
        destinationInfoList.accept(destinationList)
        setupBindings()
    }
    
    private func setupBindings() {
        destinationInfoList
            .map { $0.map { DestinationDataCellViewModel(destinationInfo: $0) } }
            .bind(to: cellViewModels)
            .disposed(by: disposeBag)
        
        cellViewModels
            .flatMap { Observable.from($0) }
            .flatMap { viewModel in
                viewModel.buttonTapped.map { viewModel.destinationInfo }
            }
            .bind(to: buttonTapped)
            .disposed(by: disposeBag)
    }
}

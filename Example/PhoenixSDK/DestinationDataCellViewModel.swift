import Foundation
import RxSwift
import RxCocoa

struct DestinationDataCellViewModel {
    let destinationInfo: DestinationInfo
    let buttonTapped = PublishRelay<Void>()
    
    init(destinationInfo: DestinationInfo) {
        self.destinationInfo = destinationInfo
    }
}

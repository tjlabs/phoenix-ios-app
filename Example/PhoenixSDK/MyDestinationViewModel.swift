import Foundation
import RxSwift
import RxCocoa

class MyDestinationViewModel {
    let destinationInformationList = BehaviorRelay<[DestinationInformation]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init() {
        
    }
    
}

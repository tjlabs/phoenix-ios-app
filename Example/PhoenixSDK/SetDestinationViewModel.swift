import RxSwift
import RxCocoa

class SetDestinationViewModel {
    let destinationInfoList = BehaviorRelay<[DestinationInformation]>(value: [])
    let selectedDestination = PublishRelay<DestinationInformation?>()
    
    private let disposeBag = DisposeBag()

    init() {
        DestinationManager.shared.destinationInfoListObservable
            .bind(to: destinationInfoList)
            .disposed(by: disposeBag)
    }

    func loadDestinationInformationList(for userType: UserType) {
        if userType == .BUSINESS {
            DestinationManager.shared.loadBusinessDestinationInformationList(businessUserInfo: UserInfoManager.shared.getBussinessUserInfo())
        } else if userType == .PERSONAL {
            DestinationManager.shared.loadPersonalDestinationInformationList(personalUserInfo: UserInfoManager.shared.getPersonalUserInfo())
        }
    }
    
    func selectDestination(at index: Int) {
        let destinations = destinationInfoList.value
        if index >= 0 && index < destinations.count {
            selectedDestination.accept(destinations[index])
        } else {
            selectedDestination.accept(nil)
        }
    }
}
